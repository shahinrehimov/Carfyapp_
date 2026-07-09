# Google Sign In — Mobile & Frontend Developer Guide

> **Base URL:** `{{url}}/api/{provider}/` — `provider` = `site` (sayt/frontend) və ya `app` (Flutter mobile)
> **Platform header (hər sorğuda):** `Token: {{app_site_token}}` (site) və ya `Token: {{app_mobile_token}}` (app)
> **Accept:** `application/json`

İki tamamilə fərqli axın var. **Frontend saytda → Web redirect axını.** **Flutter mobil app-də → Native axın.** İkisini qarışdırmayın.

---

## Ümumi qeydlər (hər iki tərəf üçün vacib)

| Nüans | İzah |
|-------|------|
| **Ad hər dəfə gəlir** | Apple-dan fərqli olaraq Google ad/soyad və avatarı hər login-də verir. Backend `name`/`avatar`-ı token-dən özü götürür — mobil tərəfdən ayrıca ad göndərmək lazım deyil. |
| **Email təsdiqlənmiş sayılır** | Google email-i onsuz da təsdiqli gəlir; backend user-i `email_verified` kimi yaradır. |
| **Provider prefiksi** | Frontend `site`, mobil `app` prefiksindən istifadə edir. |
| **Nəticə token** | Uğurlu login-də API `token` qaytarır (Bearer). Sonrakı bütün sorğularda `Authorization: Bearer <token>`. |

---

## 1) FRONTEND (sayt) — Web Redirect axını

Apple login ilə **eyni** pattern. Google düyməsini göstərmək qərarı frontend-dədir.

### Addımlar

**Addım 1 — Google login URL-ni al**

```
GET /api/site/auth/google
Headers: Token: {{app_site_token}}, Accept: application/json
```

Cavab:
```json
{
  "step": "redirect",
  "url": "https://accounts.google.com/o/oauth2/auth?client_id=386808043304-...&redirect_uri=...&scope=openid+profile+email&response_type=code&state=..."
}
```

**Addım 2 — İstifadəçini `url`-ə yönləndir.** İstifadəçi Google-da təsdiqləyir.

**Addım 3 — Google backend-ə qayıdır** (`/auth/google/callback`). Frontend burada heç nə etmir. Backend user-i yaradır/tapır və frontend-ə **birdəfəlik token** ilə redirect edir:

```
{FRONTEND_URL}/auth/third-party-login?token=<one_time_token>&provider=google
```

**Addım 4 — Frontend bu tokeni əsl login tokeninə dəyişir:**

```
POST /api/site/login/with-third-party
Headers: Token: {{app_site_token}}, Accept: application/json
```
```json
{
  "device_type": "web",
  "provider": "google",
  "token": "<one_time_token from url>"
}
```

> ⚠️ Bu birdəfəlik token **60 saniyə** etibarlıdır və **yalnız 1 dəfə** işlədilə bilər. Redirect-dən dərhal sonra çağırın.

Cavab (`UserResource`) — bax [Login cavab formatı](#login-cavab-format%C4%B1).

---

## 2) MOBILE (Flutter iOS/Android) — Native axın

Flutter `google_sign_in` paketindən istifadə edir. Cihaz native Google Sign In göstərir və bir **`idToken`** (JWT) qaytarır. Bunu birbaşa backend-ə göndərirsiniz — redirect YOXDUR. Apple-dakı `authorization_code`/refresh-token addımı Google-da YOXDUR.

### Flutter tərəfi (nümunə)

```dart
final googleSignIn = GoogleSignIn(
  // MÜTLƏQ: bizim WEB client id — backend id_token-un audience-i kimi bunu gözləyir.
  serverClientId: '386808043304-up5aa57o65luaf3fgd1vqtq2p5vmsbcq.apps.googleusercontent.com',
  scopes: ['email', 'profile'],
);

final account = await googleSignIn.signIn();
final auth = await account!.authentication;

// auth.idToken  ->  id_token (backend-ə bunu göndərin)
```

> **iOS:** `Info.plist`-ə iOS client id-nin reversed URL scheme-i əlavə olunmalıdır.
> **Android:** app-ın SHA-1 fingerprint-i Google Cloud Console-da Android client id-yə qeyd olunmalıdır.
> Bu client id-lər backend tərəfə göndərilmir — yalnız cihazda nativ ekranın açılması üçündür.

### Backend sorğusu

```
POST /api/app/auth/google/native
Headers: Token: {{app_mobile_token}}, Accept: application/json
```
```json
{
  "id_token": "<auth.idToken>",
  "device_type": "ios",
  "ref_code": ""
}
```

| Sahə | Məcburi | Qeyd |
|------|---------|------|
| `id_token` | ✅ | Cihazdan gələn Google JWT. Backend Google-un public açarları ilə doğrulayır (`iss`, `aud`, `email`). |
| `device_type` | ➖ | `ios`, `android` və ya `web`. |
| `ref_code` | ➖ | Referral kodu (varsa). |

Cavab (`UserResource`) — dərhal əsl login tokeni qaytarır (web-dəki token-exchange addımı native-də YOXDUR).

---

## Login cavab formatı

Hər iki axın eyni `UserResource` qaytarır:

```json
{
  "uuid": "9b1f2c3d-...",
  "image": null,
  "email": "user@example.com",
  "phone": null,
  "name": "John",
  "surname": "Doe",
  "gender": null,
  "gender_label": "",
  "birth_date": null,
  "email_is_verified": true,
  "phone_is_verified": false,
  "token": "123|AbCdEf..."   // Bearer token — sonrakı sorğular üçün
}
```

---

## Xəta cavabları

| Vəziyyət | Kod | Nümunə mesaj |
|----------|-----|--------------|
| Google hesabından email alınmadı | 403 | `Unable to retrieve email from Google account!` |
| Yanlış/etibarsız id token (native) | 403 | `Invalid Google id token!` |
| Birdəfəlik token vaxtı keçib və ya işlədilib (web) | 400 | `Invalid or expired token` |
| Google email bizim qeydlə uyğun gəlmir | 403 | `The Google account email does not match our records!` |
| Platform `Token` header səhv/yoxdur | 403 | `You do not have access!` |

---

## Yekun — hansı endpoint kimə

| Client | Endpoint | Method |
|--------|----------|--------|
| Frontend (sayt) | `/api/site/auth/google` | GET (redirect URL al) |
| Frontend (sayt) | `/api/site/login/with-third-party` (`provider: google`) | POST (token exchange) |
| Flutter mobile | `/api/app/auth/google/native` | POST (id_token) |

---

## Google Cloud tərəfdən lazım olanlar (referans)

Backend hazırdır; işləməsi üçün Google Cloud Console-da:

1. **Web client** → "Authorized redirect URIs"-ə əlavə olunmalı: `https://api.carfy.az/auth/google/callback`
2. **iOS OAuth client id** yaradılmalı (bundle id: `app.carfy.az`) — Flutter iOS üçün.
3. **Android OAuth client id** yaradılmalı (package name + SHA-1) — Flutter Android üçün.
4. Flutter `serverClientId` = **Web client id** (`386808043304-...`).
