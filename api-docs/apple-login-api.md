# Apple Sign In — Mobile & Frontend Developer Guide

> **Base URL:** `{{url}}/api/{provider}/` — `provider` = `site` (sayt/frontend) və ya `app` (Flutter mobile)
> **Platform header (hər sorğuda):** `Token: {{app_site_token}}` (site) və ya `Token: {{app_mobile_token}}` (app)
> **Accept:** `application/json`

İki tamamilə fərqli axın var. **Frontend saytda → Web redirect axını.** **Flutter mobil app-də → Native axın.** İkisini qarışdırmayın.

---

## Ümumi qeydlər (hər iki tərəf üçün vacib)

| Nüans | İzah |
|-------|------|
| **Ad yalnız İLK dəfə gəlir** | Apple istifadəçinin ad/soyadını YALNIZ ilk autorizasiyada verir. Sonrakı girişlərdə ad gəlmir — backend ilk dəfə saxlayır. Ona görə ilk login-də adı mütləq ötürün. |
| **Email gizli ola bilər** | İstifadəçi "Hide My Email" seçsə, email `xxxxx@privaterelay.appleid.com` formasında gəlir. Bu real, unikaldır və işləyir — normal email kimi göstərin. |
| **Provider prefiksi** | Frontend `site`, mobil `app` prefiksindən istifadə edir. |
| **Nəticə token** | Uğurlu login-də API `token` qaytarır (Bearer). Sonrakı bütün sorğularda `Authorization: Bearer <token>`. |

---

## 1) FRONTEND (sayt) — Web Redirect axını

Google login ilə **eyni** pattern. Bütün brauzerlərdə işləyir (yalnız Safari deyil). Apple düyməsini göstərmək qərarı frontend-dədir.

### Addımlar

**Addım 1 — Apple login URL-ni al**

```
GET /api/site/auth/apple
Headers: Token: {{app_site_token}}, Accept: application/json
```

Cavab:
```json
{
  "step": "redirect",
  "url": "https://appleid.apple.com/auth/authorize?response_type=code&response_mode=form_post&client_id=com.carfy.web&redirect_uri=...&scope=name+email&state=...&nonce=..."
}
```

**Addım 2 — İstifadəçini `url`-ə yönləndir.** İstifadəçi Apple-da təsdiqləyir.

**Addım 3 — Apple birbaşa backend-ə POST edir** (`/auth/apple/callback`). Frontend burada heç nə etmir. Backend user-i yaradır/tapır və frontend-ə **birdəfəlik token** ilə redirect edir:

```
{FRONTEND_URL}/auth/third-party-login?token=<one_time_token>&provider=apple
```

**Addım 4 — Frontend bu tokeni əsl login tokeninə dəyişir:**

```
POST /api/site/login/with-third-party
Headers: Token: {{app_site_token}}, Accept: application/json
```
```json
{
  "device_type": "web",
  "provider": "apple",
  "token": "<one_time_token from url>"
}
```

> ⚠️ Bu birdəfəlik token **60 saniyə** etibarlıdır və **yalnız 1 dəfə** işlədilə bilər. Redirect-dən dərhal sonra çağırın.

Cavab (`UserResource`) — bax [Login cavab formatı](#login-cavab-format%C4%B1).

---

## 2) MOBILE (Flutter iOS) — Native axın

Flutter `sign_in_with_apple` paketindən istifadə edir. Cihaz native Sign in with Apple göstərir və `identity_token` (JWT) + `authorizationCode` qaytarır. Bunları birbaşa backend-ə göndərirsiniz — redirect YOXDUR.

### Flutter tərəfi (nümunə)

```dart
final credential = await SignInWithApple.getAppleIDCredential(
  scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
);

// credential.identityToken        -> identity_token
// credential.authorizationCode    -> authorization_code
// credential.givenName / familyName -> YALNIZ ilk login-də dolu olur
```

### Backend sorğusu

```
POST /api/app/auth/apple/native
Headers: Token: {{app_mobile_token}}, Accept: application/json
```
```json
{
  "identity_token": "<credential.identityToken>",
  "authorization_code": "<credential.authorizationCode>",
  "name": "John",
  "surname": "Appleseed",
  "device_type": "ios",
  "ref_code": ""
}
```

| Sahə | Məcburi | Qeyd |
|------|---------|------|
| `identity_token` | ✅ | Cihazdan gələn Apple JWT. Backend Apple-ın public açarları ilə doğrulayır. |
| `authorization_code` | ➖ | Göndərilməsi tövsiyə olunur — backend refresh_token alıb saxlayır (hesab silinəndə Apple-dan token ləğvi üçün lazımdır). |
| `name` / `surname` | ➖ | Yalnız İLK login-də (`credential.givenName` dolu olanda) göndərin. |
| `device_type` | ➖ | `ios` |
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
  "surname": "Appleseed",
  "gender": null,
  "gender_label": "",
  "birth_date": null,
  "email_is_verified": true,
  "phone_is_verified": false,
  "token": "123|AbCdEf..."   // Bearer token — sonrakı sorğular üçün
}
```

---

## Hesabın silinməsi (Apple tələbi)

Apple App Store qaydası: Sign in with Apple olan app hesab silməni təklif etməli və silmə zamanı Apple token-i ləğv etməlidir.

```
DELETE /api/app/profile/delete-account   (və ya /api/site/...)
Headers: Token, Accept, Authorization: Bearer <token>
```

Backend avtomatik olaraq: user Apple ilə girmişsə → Apple-a token revoke sorğusu göndərir, sonra hesabı **soft-delete** edir. Frontend/mobil tərəfdə əlavə addım lazım deyil.

---

## Xəta cavabları

| Vəziyyət | Kod | Nümunə mesaj |
|----------|-----|--------------|
| Apple hesabından email alınmadı | 403 | `Unable to retrieve email from Apple account!` |
| Yanlış/etibarsız identity token (native) | 403 | `Invalid Apple identity token!` |
| Birdəfəlik token vaxtı keçib və ya işlədilib (web) | 400 | `Invalid or expired token` |
| Platform `Token` header səhv/yoxdur | 403 | `You do not have access!` |

---

## Yekun — hansı endpoint kimə

| Client | Endpoint | Method |
|--------|----------|--------|
| Frontend (sayt) | `/api/site/auth/apple` | GET (redirect URL al) |
| Frontend (sayt) | `/api/site/login/with-third-party` (`provider: apple`) | POST (token exchange) |
| Flutter mobile | `/api/app/auth/apple/native` | POST (identity_token) |
| Hər ikisi | `/api/{provider}/profile/delete-account` | DELETE |
