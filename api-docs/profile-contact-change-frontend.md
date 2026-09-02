# Profil: email / telefon dəyişikliyi — frontend inteqrasiya sənədi

**Hədəf:** Next.js sayt (`carfy`) və mobil tətbiq
**Tarix:** 2026-08-06
**Backend statusu:** hazırdır, lokalda test edilib

---

## 1. Nə dəyişdi

Əvvəllər istifadəçi email və telefon nömrəsini heç bir yolla dəyişə bilmirdi.
`POST /profile/update` yalnız `name`, `surname`, `gender`, `birth_date` qəbul edirdi.

İndi:

1. **Email və telefon üçün ayrıca OTP təsdiqli endpointlər var** (aşağıda).
2. **`gender` artıq məcburi deyil** — nə qeydiyyatda, nə də profil update-də.
3. **`gender_label` artıq `null` qaytara bilər** (əvvəl `"_gender_"` kimi sınıq dəyər qaytarırdı).

> `POST /profile/update` email və telefon **qəbul etmir**. Bu sahələri göndərsəniz
> sadəcə nəzərə alınmayacaq. Dəyişiklik yalnız aşağıdakı endpointlərlə mümkündür.

---

## 2. Ümumi qaydalar

**Base path.** Bütün route-lar həm sayt, həm tətbiq prefiksində mövcuddur:

```
https://<host>/api/site/profile/...   ← Next.js sayt
https://<host>/api/app/profile/...    ← mobil tətbiq
```

Yalnız prefiks fərqlidir, gövdə və cavablar eynidir.

**Header-lər.** Mövcud profil endpointləri ilə eyni — əlavə bir şey lazım deyil:

| Header | Dəyər |
|---|---|
| `Token` | sayt üçün site app token, tətbiq üçün app token |
| `Authorization` | `Bearer <istifadəçinin login token-i>` |
| `Accept` | `application/json` |
| `Accept-Language` | `az` \| `en` \| `ru` |

Bütün 4 endpoint **authenticated**-dir (`auth:user`), yəni istifadəçi giriş etmiş olmalıdır.

**Rate limit.**

| Endpoint | Limit |
|---|---|
| `change-email/send-otp` | dəqiqədə **2** |
| `change-phone/send-otp` | dəqiqədə **2** |
| `change-email/verify` | dəqiqədə **5** |
| `change-phone/verify` | dəqiqədə **5** |

Limit aşılanda `429` və `{"message": "Too Many Attempts."}` gəlir. UI-da "Kodu yenidən
göndər" düyməsini **60 saniyəlik geri sayımla** bloklayın, əks halda istifadəçi limitə dirənəcək.

**OTP qaydaları.**

- Kod **4 rəqəmlidir**, `integer` kimi göndərilir (string yox).
- Etibarlılıq müddəti: **3 dəqiqə**.
- Maksimum **3 yanlış cəhd**, sonra kod tamamilə bloklanır və yenisi tələb olunur.
- Kod bir dəfə istifadə olunur; təkrar göndərsəniz "artıq istifadə olunub" xətası gəlir.
- Yeni kod istəsəniz köhnəsi praktiki olaraq əvəzlənir (sistem həmişə ən sonuncunu yoxlayır).

**Xəta formatı.** İki fərqli format var, hər ikisini emal edin:

Validasiya xətası — `422`:
```json
{
    "message": "email etibarlı e-poçt ünvanı olmalıdır.",
    "errors": {
        "email": ["email etibarlı e-poçt ünvanı olmalıdır."]
    }
}
```

Biznes qaydası xətası — `400`:
```json
{
    "message": "Bu artıq sizin mövcud email ünvanınızdır"
}
```

`message` sahəsi hər iki halda var və artıq `Accept-Language`-ə uyğun tərcümə olunub —
birbaşa istifadəçiyə göstərə bilərsiniz. Lokal mühitdə cavaba əlavə `exception` və `trace`
sahələri düşür (`APP_DEBUG=true`), produksiyada onlar olmur — onlara güvənməyin.

---

## 3. Email dəyişikliyi

### Addım 1 — kod göndər

```
POST /api/site/profile/change-email/send-otp
POST /api/app/profile/change-email/send-otp
```

```json
{
    "email": "new.email@example.com"
}
```

**200:**
```json
{
    "data": {
        "step": "otp_email",
        "otp_expires_in": 180,
        "message": "Yeni email ünvanınıza OTP kodu göndərildi. Dəyişikliyi tamamlamaq üçün kodu təsdiqləyin."
    }
}
```

> Diqqət: bu cavab `data` obyektinin **içindədir**. Addım 2-nin cavabı isə `data`-sızdır
> (aşağıya baxın) — bu, mövcud kolleksiyadakı digər endpointlərlə eyni davranışdır.

`otp_expires_in` — kodun neçə **saniyə** sonra etibarsız olacağı. Geri sayımı bu dəyərdən
qurun, `180`-i sabit kimi yazmayın: müddət backend-də dəyişsə, cavab da avtomatik dəyişəcək.

Kod **yeni** email ünvanına göndərilir, köhnəsinə yox.

### Addım 2 — təsdiqlə

```
POST /api/site/profile/change-email/verify
POST /api/app/profile/change-email/verify
```

```json
{
    "email": "new.email@example.com",
    "otp": 1907
}
```

`email` Addım 1-də göndərdiyinizlə **eyni olmalıdır**. Fərqli ünvan göndərsəniz kod qəbul
edilmir (kod göndərildiyi ünvana bağlıdır).

**200:**
```json
{
    "user": {
        "uuid": "36901ccd-e74d-45b1-8bfe-298c7508294d",
        "register_type": "phone",
        "image": null,
        "email": "new.email@example.com",
        "phone": "994507941476",
        "name": "Doc",
        "surname": "Fixture",
        "gender": null,
        "gender_label": null,
        "birth_date": null,
        "email_is_verified": true,
        "phone_is_verified": true
    },
    "message": "Email ünvanınız uğurla dəyişdirildi"
}
```

Cavabdakı `user` obyekti tam yenilənmiş profildir — lokal state-i bununla əvəzləyin,
əlavə `GET /profile/me` sorğusuna ehtiyac yoxdur.

`email_is_verified` dərhal `true` olur, çünki dəyişiklik onsuz da OTP ilə təsdiqlənib.

---

## 4. Telefon dəyişikliyi

### Addım 1 — kod göndər

```
POST /api/site/profile/change-phone/send-otp
POST /api/app/profile/change-phone/send-otp
```

```json
{
    "phone": "994501234567"
}
```

**Format məcburidir:** tam 12 simvol, `994` ilə başlayır, sonra 9 rəqəm — `^994\d{9}$`.
Boşluq, `+`, mötərizə və defis **qəbul edilmir**. Input-dakı maskanı göndərməzdən əvvəl
təmizləyin (`+994 50 123 45 67` → `994501234567`).

**200:**
```json
{
    "data": {
        "step": "otp_phone",
        "otp_expires_in": 180,
        "message": "Yeni telefon nömrənizə OTP kodu göndərildi. Dəyişikliyi tamamlamaq üçün kodu təsdiqləyin."
    }
}
```

### Addım 2 — təsdiqlə

```
POST /api/site/profile/change-phone/verify
POST /api/app/profile/change-phone/verify
```

```json
{
    "phone": "994501234567",
    "otp": 1907
}
```

**200:** email ilə eyni struktur — yenilənmiş `user` obyekti və `message`:

```json
{
    "user": { "...": "...", "phone": "994501234567", "phone_is_verified": true },
    "message": "Telefon nömrəniz uğurla dəyişdirildi"
}
```

---

## 5. Xəta halları

Hamısı `400` (rate limit istisna olmaqla) və hazır tərcümə olunmuş `message` ilə gəlir.

| Hal | Nümunə mesaj (az) |
|---|---|
| Ünvan/nömrə artıq cari dəyərdir | `Bu artıq sizin mövcud email ünvanınızdır` |
| Başqa təsdiqlənmiş hesab istifadə edir | `Bu email ünvanı artıq istifadə olunur` |
| Kod yanlışdır | `OTP kodu yanlışdır` |
| Kod tapılmadı / vaxtı bitdi | `OTP kodu tapılmadı və ya vaxtı bitib` |
| Kod artıq istifadə olunub | `Bu OTP kodu artıq istifadə olunub` |
| 3 cəhd bitdi | `OTP cəhdlərinin maksimum sayı aşıldı. Yeni kod tələb edin.` |
| Google/Apple hesabı email dəyişməyə çalışır | `Google və ya Apple ilə yaradılmış hesabın email ünvanı dəyişdirilə bilməz.` |
| SMS göndərilə bilmədi | `SMS göndərilə bilmədi. Zəhmət olmasa bir az sonra yenidən cəhd edin.` |
| Rate limit (`429`) | `Too Many Attempts.` |

### Google / Apple hesabları

`user` obyektində artıq **`register_type`** sahəsi var — dəyərlər: `email`, `phone`,
`google`, `apple`. Email dəyişmə düyməsini bununla idarə edin:

```js
const canChangeEmail = !["google", "apple"].includes(user.register_type);
```

Telefon dəyişikliyi **bütün** hesab növləri üçün açıqdır, yalnız email bağlıdır.

> `register_type` `UserResource`-a əlavə edilib, yəni bu sahə **bütün** cavablarda görünür —
> login, qeydiyyat, `GET /profile/me` və profil update daxil. Bu, əlavə edilmiş yeni sahədir;
> mövcud heç nəyi dəyişmir.

---

## 6. Login davranışı — dəyişməyib

Bunu UI mətnlərində nəzərə alın ki, istifadəçini yanıltmayasınız:

- Emaillə qeydiyyatdan keçib **telefon əlavə edən** istifadəçi həmin telefonla giriş edə
  **bilmir**. Telefon yalnız əlaqə məlumatı olaraq saxlanılır.
- Telefonla qeydiyyatdan keçib **email əlavə edən** istifadəçi həmin emaillə (parolla)
  giriş edə **bilmir**.

Yəni "artıq bu nömrə ilə daxil ola bilərsiniz" tipli mətn yazmayın. Bu qəsdən belədir;
dəyişməsi ayrıca qərar tələb edir.

---

## 7. `gender` dəyişikliyi

`gender` artıq heç bir yerdə məcburi deyil:

- `POST /profile/update` — sahəni ümumiyyətlə göndərməyə bilərsiniz.
- Qeydiyyat endpointləri — onsuz da məcburi deyildi.

Davranış:

| Göndərilən | Nəticə |
|---|---|
| sahə yoxdur | mövcud dəyər **dəyişmir** |
| `"gender": null` | dəyər **silinir** |
| `"gender": "male"` | dəyər yazılır |
| `"gender": "abc"` | `422` — yanlış dəyər hələ də rədd olunur |

Formu "sıfırla" düyməsi üçün: dəyəri silmək istəyirsinizsə açıq şəkildə `null` göndərin,
sahəni buraxmaq kifayət deyil.

### `gender_label` artıq `null` ola bilər — bu breaking change-dir

`gender` boş olanda `gender_label` da `null` qaytarır:

```json
{ "gender": null, "gender_label": null }
```

Əvvəl bu halda sınıq `"_gender_"` sətri gəlirdi. Əgər UI `gender_label`-ı birbaşa
render edirsə, `null` yoxlaması əlavə edin:

```js
{user.gender_label ?? "—"}
```

`birth_date` isə **hələ də məcburidir** (`POST /profile/update`), format `Y-m-d`
(məsələn `1990-01-01`) və bugünkü tarixdən əvvəl olmalıdır.

---

## 8. Tövsiyə olunan UI axını

```
Profil səhifəsi
  └── "Email dəyiş" / "Telefon dəyiş"
        ├── Modal 1: yeni dəyər input-u  →  send-otp
        │     ├── 200 → Modal 2-yə keç
        │     └── 400 → xətanı input altında göstər, modalda qal
        └── Modal 2: 4 rəqəmli OTP input-u  →  verify
              ├── 200 → modalı bağla, state-i cavabdakı `user` ilə yenilə, success toast
              ├── 400 "kod yanlışdır" → input-u təmizlə, modalda qal, cəhd sayını göstər
              └── 400 "cəhd sayı aşıldı" / "vaxtı bitib" → Modal 1-ə qaytar
```

Nəzərə alın:

- Modal 2-də **iki ayrı sayğac** lazımdır, onları qarışdırmayın:
  - **Kodun etibarlılığı** — `send-otp` cavabındakı `otp_expires_in` (saniyə, hazırda 180).
    Sıfıra çatanda kod işləmir, istifadəçiyə yenisini istəməyi təklif edin.
  - **"Yenidən göndər" bloku** — **60 saniyə**, çünki rate limit dəqiqədə 2-dir. Bu, backend
    dəyəri deyil, sadəcə UI-ın limitə dirənməməsi üçün qoruyucudur.
- Modal 2-də yeni email/telefonu ekranda göstərin ki, istifadəçi səhv yazdığını görsün,
  və "Dəyiş" linki ilə Modal 1-ə qayıtmaq imkanı verin.
- OTP input-unu `inputmode="numeric"`, `maxlength=4` edin; göndərməzdən əvvəl `Number()`-ə
  çevirin, çünki backend `integer` gözləyir.
- Lokal test üçün `APP_OTP_DEBUG_MODE=true` olduqda kod həmişə **1907**-dir və SMS/email
  real göndərilmir.

---

## 9. Postman

`postman/Carfy.postman_collection.json` yenilənib. `App → Profile` qovluğunda 4 yeni sorğu:

- `Change email send OTP`
- `Change email verify`
- `Change phone send OTP`
- `Change phone verify`

Hər sorğuda `:provider` path dəyişəni var — default `site`, mobil tətbiqi test etmək üçün
`app` yazın.

---

## 10. `otp_expires_in` — bütün OTP endpointlərində

Sahə yalnız profil dəyişikliyində deyil, **OTP göndərən bütün endpointlərdə** var. Yəni
qeydiyyat, login və parol ekranlarında da eyni geri sayım məntiqini işlədə bilərsiniz.

| Endpoint | Cavabda yeri |
|---|---|
| `POST /register/with-phone/send-otp` | kök |
| `POST /register/with-email/submit` | kök |
| `POST /send-verification-email` | kök |
| `POST /login/with-phone/send-otp` | kök |
| `POST /profile/change-password` | `data` içində |
| `POST /profile/change-email/send-otp` | `data` içində |
| `POST /profile/change-phone/send-otp` | `data` içində |
| `POST /sellers/store-profile/notification-phone/send-otp` | kök *(satıcı paneli)* |

> **Diqqət — cavabın quruluşu hər yerdə eyni deyil.** Bəzi endpointlər sahəni kökdə,
> bəziləri `data` obyektinin içində qaytarır. Bu, hər endpointin mövcud (əvvəldən gələn)
> quruluşudur — biz onu dəyişmədik ki, işləyən ekranlar sınmasın. Oxuyarkən nəzərə alın:
> ```js
> const expiresIn = res.data?.otp_expires_in ?? res.otp_expires_in;
> ```

Nümunələr:

```json
// POST /site/login/with-phone/send-otp
{ "step": "otp_phone", "otp_expires_in": 180, "message": "OTP sent to your phone!" }

// POST /site/profile/change-password
{ "data": { "step": "otp_email", "otp_expires_in": 180, "message": "..." } }
```

**İstisna:** `POST /register/with-email/submit` və `POST /send-verification-email`
cavabında `otp_expires_in` **yalnız OTP rejimində** olur. Backend link ilə təsdiqə keçsə
(`step: "verify_email"`), sahə ümumiyyətlə gəlmir — çünki sayılacaq kod yoxdur. Hazırda
sistem OTP rejimindədir, amma kodunuz `step` dəyərini yoxlasın, sahənin varlığına güvənməsin.

### Əvvəlki versiyada açıq qalan məsələlər

- ✅ `register_type` `user` obyektinə əlavə edildi (bölmə 5).
- ✅ `otp_expires_in` bütün OTP endpointlərinə əlavə edildi.
