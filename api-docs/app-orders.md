# App — Orders Module

Bu sənəd **App/Site panel** üçün (giriş etmiş istifadəçilər) sifariş endpointlərini izah edir.

**Base URL:** `{{url}}/:provider/` (`:provider` = `site` və ya `app`)  
**Auth:** Bearer token → `{{login_token_site}}`  
**Header:** `Token: {{app_site_token}}`

---

## 1. Checkout Preview

```
GET /:provider/orders/checkout-preview
```

Ödənişdən **əvvəl** göstərilən sifariş xülasəsi. Səbətdəki məhsulları sellerlərə görə qruplaşdırır, hər seller üçün catdırılma haqqını əlavə edir.

### Response

```json
{
  "sellers": [
    {
      "company_id": 1,
      "store_code": "abc-store",
      "items": [
        {
          "quantity": 2,
          "price": 170.00,
          "product": {
            "uuid": "cpv-uuid",
            "variant_slug": "nike-air-max-90",
            "title": "Nike Air Max 90 (Qara, 42)",
            "hover_image": "https://...",
            "stock": 5,
            "price": 85.00,
            "price_final": 85.00,
            "has_discount": false,
            "seller": {
              "store_code": "abc-store",
              "label": "Store abc-store"
            }
          }
        }
      ],
      "subtotal": 170.00,
      "shipping": 3.00
    }
  ],
  "subtotal": 170.00,
  "total_shipping": 3.00,
  "grand_total": 173.00
}
```

**Qeyd:** `product` sahəsi product list və basket API-ləri ilə eyni `CompanyProductVariantListResource` strukturunu qaytarır.

**Qeyd:** Bütün məbləğlər AZN ilə, dollar formatında (məs. `85.00`).

---

## 2. Checkout (Sifariş ver)

```
POST /:provider/orders/checkout
```

Səbəti sifarişə çevirir. Ödəniş metoduna görə dərhal ödəniş emal edilir (kart) və ya gözlənilir (bank köçürməsi).

### Request Body

```json
{
  "payment_method": "stripe",
  "address_id": 5,
  "note": "Zəng etməyin, SMS göndərin"
}
```

### Response (uğurlu)

```json
{
  "data": {
    "order_uuid": "abc123-...",
    "status": "processing",
    "payment_status": "paid",
    "grand_total": 173.00
  }
}
```

### Response (ödəniş gözlənilir)

```json
{
  "data": {
    "order_uuid": "abc123-...",
    "status": "payment_pending",
    "payment_status": "pending",
    "redirect_url": "https://payment-gateway.com/pay/..."
  }
}
```

**Qeyd:** `redirect_url` varsa, istifadəçini həmin URL-ə yönləndir.

---

## 3. Sifarişlər siyahısı

```
GET /:provider/orders/load?limit=15&page=1
```

İstifadəçinin bütün sifarişləri.

### Query params

| Param | Default | Açıqlama |
|-------|---------|----------|
| `limit` | 15 | Səhifə başına say |
| `page` | 1 | Səhifə nömrəsi |

### Response

```json
{
  "data": [
    {
      "id": 201,
      "code": "ORD-00201",
      "uuid": "abc123-...",
      "products_count": 2,
      "status": "processing",
      "status_label": "Hazırlanır",
      "date": "21.04.2026"
    }
  ],
  "meta": { "current_page": 1, "total": 5 }
}
```

---

## 4. Sifariş detayları

```
GET /:provider/orders/show/:orderUuid
```

### Response

```json
{
  "data": {
    "id": 201,
    "code": "ORD-00201",
    "uuid": "abc123-...",
    "products_count": 2,
    "status": "courier_assigned",
    "status_label": "Kuryer təyin edildi",
    "date": "21.04.2026",
    "amount": 170.00,
    "amount_final": 173.00,
    "payment_method": {
      "name": "stripe",
      "label": "Kredit kartı",
      "payment_status": "paid",
      "payment_status_label": "Ödənilib"
    },
    "address": {
      "address_type": {},
      "city": {},
      "address_line_1": "Nizami küç. 10",
      "address_line_2": null,
      "latitude": 40.4093,
      "longitude": 49.8671,
      "phone": "+994501234567"
    },
    "statuses": [
      { "status": "processing", "status_label": "Hazırlanır", "date": "21.04.2026, 10:30" },
      { "status": "courier_assigned", "status_label": "Kuryer təyin edildi", "date": "21.04.2026, 14:00" }
    ],
    "items": [
      {
        "quantity": 2,
        "amount": 85.00,
        "amount_final": 85.00,
        "product": { /* CompanyProductVariantListResource */ }
      }
    ]
  }
}
```

---

## Sifariş statusları (status field)

| Dəyər | Mənası |
|-------|--------|
| `payment_pending` | Ödəniş gözlənilir |
| `processing` | Ödəniş alındı, hazırlanır |
| `courier_assigned` | Kuryer təyin edildi |
| `delivered` | Çatdırıldı |
| `canceled` | Ləğv edildi |
| `failed` | Ödəniş uğursuz oldu |

## Item statusları (order `items` massivindəki hər item üçün — `product.status` kimi göstərilə bilər)

| Dəyər | Mənası |
|-------|--------|
| `pending` | Seller cavab gözlənilir |
| `processing` | Seller hazırlayır |
| `ready_for_delivery` | Kuryerə hazır |
| `handed_to_courier` | Kuryerə verildi |
| `canceled` | Bu item ləğv edildi (qismən refund edilmiş ola bilər) |

---

## Ödəniş statusları (payment_status field)

| Dəyər | Mənası |
|-------|--------|
| `pending` | Ödəniş gözlənilir |
| `paid` | Tam ödənilib |
| `refunded` | Tam geri qaytarılıb |
| `partially_refunded` | Qismən geri qaytarılıb |
| `failed` | Ödəniş uğursuz |

---

## Xəta kodları

| HTTP | Hal |
|------|-----|
| 401 | Token yoxdur / etibarsızdır |
| 422 | Validation xətası |
| 404 | Sifariş tapılmadı |

---

## Köhnə versiyadan keçid üçün dəyişikliklər

### Yeni endpoint

| # | Endpoint | Qeyd |
|---|----------|------|
| + | `GET /:provider/orders/checkout-preview` | Yeni. Checkout səhifəsindən əvvəl çağırılmalıdır |

### Checkout response dəyişikliyi

`POST /:provider/orders/checkout` — cavab strukturu genişləndirildi:

```diff
+ "grand_total": 173.00   // əvvəl yox idi
```

### Order show response dəyişiklikləri

`GET /:provider/orders/show/:orderUuid` — `payment_method` strukturu dəyişdi:

```diff
- "payment_method": "stripe"   // əvvəl sadə string idi
+ "payment_method": {
+   "name": "stripe",
+   "label": "Kredit kartı",
+   "payment_status": "paid",
+   "payment_status_label": "Ödənilib"
+ }
```

Həmçinin `status_label` əlavə edildi:

```diff
+ "status_label": "Hazırlanır"
```

### Yeni status dəyərləri

**order `status` — yeni əlavə:**

| Dəyər | Mənası |
|-------|--------|
| `courier_assigned` | Kuryer təyin edildi (əvvəl yox idi) |

**order `payment_status` — yeni əlavə:**

| Dəyər | Mənası |
|-------|--------|
| `partially_refunded` | Qismən geri qaytarılıb (əvvəl yox idi) |
