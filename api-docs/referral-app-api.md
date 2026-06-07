# Referral Sistemi — App / Site API

> **Base URL:** `{{url}}/api/{provider}/`  (`provider` = `site` | `app`)
> **Auth:** Bearer `{{login_token_site}}`
> **Headers:** `Token: {{app_site_token}}`, `Accept: application/json`

---

## İcmal

Referral sistemin iki tərəfi var:

| Rol | Kim | Nə alır |
|-----|-----|---------|
| **Referrer** (dəvət edən) | Öz linki ilə başqasını qeydiyyata dəvət edir | Dəvət etdiyi şəxsin alışlarından tier üzrə % (balansa düşür) |
| **Referred** (dəvət olunan) | Referral link ilə qeydiyyatdan keçib | İlk 3 sifarişdə pulsuz çatdırılma + 1% endirim |

Hər user **eyni vaxtda hər iki rol** ola bilər (özü dəvət edirsə).

---

## Qeydiyyat — `ref_code` parametri

Qeydiyyat endpointlərinə isteğe bağlı `ref_code` göndərin:

```json
POST /api/site/register-with-email
POST /api/site/register-with-phone

{
  "name": "Anar",
  "surname": "Əliyev",
  "email": "anar@example.com",
  "password": "...",
  "password_confirmation": "...",
  "phone": "994501234567",
  "ref_code": "ZAUR26",            // referral kodu (isteğe bağlı)
  "device_fingerprint": "abc123"   // cihaz fingerprint (isteğe bağlı, fraud üçün)
}
```

> `ref_code` verilmədikdə heç bir attribution yaranmır. Kod mövcud deyilsə, sessiz şəkildə keçilir.

---

## Checkout — `use_referral_balance`

```json
POST /api/site/orders/checkout

{
  "payment_method": "kapitalbank",
  "address_id": 5,
  "use_referral_balance": true   // isteğe bağlı, default false
}
```

### Otomatik tətbiq edilən perk-lər (referred user)
Aşağıdakılar **frontend müdaxiləsi olmadan** otomatik tətbiq olunur:
- **Pulsuz çatdırılma** — `free_delivery_remaining > 0` olduqda, həmin checkout-da shipping = 0
- **1% endirim** — `discount_orders_remaining > 0` olduqda, subtotaldan 1% çıxılır

### Balans xərcləmə (referrer)
- `use_referral_balance: true` göndərildikdə `available_balance`-dən sifariş məbləğini qarşılayacaq qədər düşülür
- Minimum 20 AZN `available_balance` tələbi var (`can_use_balance` ilə yoxlayın)

### Checkout Preview cavabındakı referral məlumatı
`GET /orders/checkout-preview` cavabında `referral` obyekti əlavə edilib:

```json
{
  "referral": {
    "free_delivery_applied": true,
    "discount_applied": true,
    "discount_amount": 0.25,
    "subtotal_after_discount": 24.75,
    "shipping_after_perk": 0,
    "grand_total_after_perks": 24.75,
    "can_use_balance": true,
    "available_balance": 5.20,
    "free_delivery_remaining": 2,
    "discount_orders_remaining": 2
  }
}
```

## Status / Enum dəyərləri

### Earning status
| Dəyər | Məna |
|-------|------|
| `pending` | Sifariş delivered, 14 gün refund window gözlənilir |
| `available` | Balansa köçürülüb, istifadəyə hazır |
| `refunded` | Sifariş refund olundu |
| `cancelled` | Sifariş cancel olundu |
| `fraud_hold` | Admin review gözlənilir |

### Withdrawal status
| Dəyər | Məna |
|-------|------|
| `pending` | Yaradılıb, admin baxır |
| `approved` | Onaylandı, ödəniş gözlənilir |
| `paid` | Ödəniş edildi |
| `rejected` | Rədd edildi, balans geri qaytarıldı |

### Attribution status
| Dəyər | Məna |
|-------|------|
| `pending` | Qeydiyyat var, hələ 20 AZN+ sifariş yoxdur |
| `active` | Aktivləşdi, referrer earning alır |
| `fraud_blocked` | Fraud aşkar edildi, bloklandı |

---

## UI ipucları

1. **Referral paneli:** `GET /referral/my` → kod + link + QR (kod-dan generate et) + tier badge + statistika
2. **"Balans ilə ödə" düyməsi:** `can_use_balance` = `true` olduqda checkout-da göstər
3. **Perk banner:** `free_delivery_remaining > 0` → "Pulsuz çatdırılma hüquqlarınız var!"; `discount_orders_remaining > 0` → "Növbəti X sifarişinizdə 1% endirim"
4. **Passive xəbərdarlıq:** `is_active: false` → "30 gündür aktiv deyilsiniz, earning dayandırılıb"
5. **Withdrawal minimal check:** UI-da `available_balance < 50` olduqda düyməni disable et + `"Minimum 50 AZN tələb olunur"` göstər
