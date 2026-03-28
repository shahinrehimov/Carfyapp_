# App — Product Module API Documentation

Bu sənəd **public/site (app)** API-nin product modulunu izah edir.

---

## Mündəricat

1. [Arxitektura — CPV nədir?](#1-arxitektura--cpv-nədir)
2. [Qiymət məntiqi](#2-qiymət-məntiqi)
3. [Şəkil məntiqi (Image cascade)](#3-şəkil-məntiqi-image-cascade)
4. [Məhsul siyahısı — `/products/load`](#4-məhsul-siyahısı--productsload)
5. [Axtarış filtrləri — `/products/filters`](#5-axtarış-filtrləri--productsfilters)
6. [Məhsul detalı — `/products/show/...`](#6-məhsul-detalı--productsshow)
7. [Digər satıcılar — `/products/{variant}/other-sellers`](#7-digər-satıcılar--productsvariantother-sellers)
8. [Rəylər — `/products/{cpv}/reviews/...`](#8-rəylər--productscpvreviews)
9. [İstək siyahısı (Wishlist)](#9-i̇stək-siyahısı-wishlist)
10. [Səbət (Basket)](#10-səbət-basket)
11. [Qruplar (Groups)](#11-qruplar-groups)
12. [URL quruluşu — frontend necə link düzəldəcək?](#12-url-quruluşu--frontend-necə-link-düzəldəcək)
13. [Bütün endpointlər — cədvəl](#13-bütün-endpointlər--cədvəl)

---

## 1. Arxitektura — CPV nədir?

Sistemdə məhsulun özü (`Product`) və onun variantları (`ProductVariant`) ayrıdır.
Hər variantı bir neçə satıcı sata bilər. Hər satıcının öz qiyməti, stoku, şəkilləri var.

Bu əlaqəni tutan model: **`CompanyProductVariant`** (qısaca: **CPV**).

```
Product
  └── ProductVariant (variant, məs. "Bosch Filtr 1.6 TDI")
        └── CompanyProductVariant (satıcı A-nın bu variantı üçün listinqi)
        └── CompanyProductVariant (satıcı B-nin bu variantı üçün listinqi)
```

**Niyə bu vacibdir?**
Public API-də hər "məhsul kartı" əslində bir **CPV**-dir, variant deyil.
Yəni `uuid`, qiymət, stok, `in_wishlist`, `in_basket` — hamısı CPV-ə aiddir.

**URL-də seller necə göstərilir?**
Hər satıcının `store_code`-u var (5 simvol, məs: `"AB123"`).
Detail səhifəyə keçəndə bu kod query param kimi göndərilir:

```
/products/show/elektrik/filtrler/bosch-filtr-16-tdi?variant=bosch-filtr-16-tdi&seller=AB123
```

---

## 2. Qiymət məntiqi

Bütün qiymətlər **API-dən dollar olaraq gəlir** (backend sentdə saxlayır, cavabda bölüb göndərir).

| Field | İzah |
|---|---|
| `price` | Endirim olmadan əsas qiymət |
| `price_final` | Endirimdən sonra ödəniləcək qiymət |
| `has_discount` | `price != price_final` olarsa `true` |
| `discount_type` | `"by_percentage"` (faiz) ya `"by_amount"` (məbləğ) |
| `discount` | Endirim dəyəri |

**Endirim hesablanması:**
- `discount_type = "by_percentage"` → `price_final = price - (price × discount / 100)`
- `discount_type = "by_amount"` → `price_final = price - discount`
- Əgər endirim müddəti keçibsə (`discount_end_at < now`) → `price_final = price`

---

## 3. Şəkil məntiqi (Image cascade)

CPV-in şəkilləri **cascade** məntiqi ilə gəlir:

1. Satıcının özünün yüklediyi şəkil (CPV media)
2. Yoxdursa → variantın şəkli (ProductVariant media)
3. Yoxdursa → məhsulun şəkli (Product media)

List API-də bu `hover_image` field-ında gəlir.
Detail API-də `gallery` array-i hər şəkilin mənbəyini göstərir: `"source": "seller"/"variant"/"product"`.

---

## 4. Məhsul siyahısı — `/products/load`

**`GET /products/load`**

### Request params

| Param | Tip | Məcburi | İzah |
|---|---|---|---|
| `page` | integer | - | Səhifə nömrəsi (default: 1) |
| `limit` | integer 5–100 | - | Səhifə başına (default: 10) |
| `search` | string (max 500) | - | Mətn axtarışı (başlıq, qısa desc, desc) |
| `sort` | `date`/`title`/`price` | - | Sıralama sahəsi |
| `sort_type` | `asc`/`desc` | - | Sıralama istiqaməti |
| `brands[]` | string[] (brand slug) | - | Marka filtri |
| `categories[]` | string[] (category slug) | - | Kateqoriya filtri |
| `sub_categories[]` | string[] (category slug) | - | Alt kateqoriya filtri |
| `is_set` | `yes`/`no` | - | Set məhsul filtri |
| `min_price` | numeric ≥ 0 | - | Minimum qiymət (dollarda) |
| `max_price` | numeric | - | Maksimum qiymət (dollarda) |
| `city_id` | integer | - | Şəhər filtri |
| `seller_store_code` | string (5 simvol) | - | Konkret satıcı filtri |
| `colors[]` | string[] (item slug) | - | Rəng filtri (`/products/filters`-dən alınan slug) |
| `conditions[]` | string[] (item slug) | - | Vəziyyət filtri (New, Used, Refurbished...) |
| `min_year` | integer ≥ 1900 | - | Minimum il |
| `max_year` | integer ≥ 1900 | - | Maksimum il |

**Qeyd:** Yalnız `is_active=true` olan və `approval_status='approved'` olan CPV-lər gəlir.

### Response

```json
{
  "data": [
    {
      "uuid": "cpv-uuid-burada",
      "variant_slug": "bosch-filtr-16-tdi",
      "title": "Bosch Filtr 1.6 TDI",
      "oem_code": "1457434310",
      "hover_image": "https://cdn.example.com/image.jpg",
      "is_set": false,
      "stock": 15,
      "price": 45.00,
      "price_final": 38.25,
      "has_discount": true,
      "discount_type": "by_percentage",
      "discount_type_title": "Faiz",
      "discount": 15,
      "in_wishlist": false,
      "in_basket": false,
      "seller": {
        "uuid": "cpv-uuid-burada",
        "store_code": "AB123",
        "label": "Texno Parts",
        "city": {
          "id": 1,
          "title": "Bakı"
        }
      },
      "product": {
        "id": 42,
        "uuid": "product-uuid",
        "slug": "bosch-filtr-16-tdi",
        "category_slugs": {
          "sub_category_slug": "filtrler",
          "parent_category_slug": "elektrik"
        },
        "title": "Bosch Filtr 1.6 TDI",
        "description_short": "Orijinal Bosch filtr",
        "hover_image": "https://cdn.example.com/product.jpg",
        "is_set": false,
        "brand": {
          "id": 3,
          "slug": "bosch",
          "title": "Bosch"
        }
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "per_page": 10,
    "total": 84,
    "last_page": 9
  }
}
```

### Detail səhifəsinə URL necə düzəldiləcək?

`product.category_slugs` + `product.slug` + `variant_slug` + `seller.store_code` istifadə et:

```
/products/show/{parent_category_slug}/{sub_category_slug}/{product_slug}
  ?variant={variant_slug}&seller={store_code}

// Nümunə:
/products/show/elektrik/filtrler/bosch-filtr-16-tdi
  ?variant=bosch-filtr-16-tdi&seller=AB123
```

Əgər `parent_category_slug` null-dursa (ana kateqoriya yoxdur):
```
/products/show/{sub_category_slug}/{product_slug}?variant=...&seller=...
```

---

## 5. Axtarış filtrləri — `/products/filters`

**`GET /products/filters`**

Auth yoxdur. Axtarış UI-ni doldurmaq üçün istifadə edilir.

### Response

```json
{
  "data": {
    "categories": [
      {
        "id": 1,
        "slug": "elektrik",
        "title": "Elektrik",
        "children": [
          { "id": 11, "slug": "filtrler", "title": "Filtrlər" }
        ]
      }
    ],
    "brands": [
      {
        "id": 3,
        "slug": "bosch",
        "title": "Bosch",
        "models": [
          { "id": 7, "title": "A1" },
          { "id": 8, "title": "A3" }
        ]
      }
    ],
    "cities": [
      { "id": 1, "title": "Bakı" },
      { "id": 2, "title": "Sumqayıt" }
    ],
    "price_ranges": {
      "min": 5.00,
      "max": 850.00
    },
    "colors": [
      { "slug": "red", "title": "Qırmızı" },
      { "slug": "black", "title": "Qara" }
    ],
    "conditions": [
      { "slug": "new", "title": "Yeni" },
      { "slug": "used", "title": "İstifadə edilmiş" },
      { "slug": "refurbished", "title": "Təmirli" },
      { "slug": "open-box", "title": "Açıq qutu" },
      { "slug": "like-new", "title": "Yeni kimisi" }
    ],
    "year_range": {
      "min": 2010,
      "max": 2025
    }
  }
}
```

---

## 6. Məhsul detalı — `/products/show/...`

İki URL forması var:

```
GET /products/show/{parentCategorySlug}/{subCategorySlug}/{productSlug}
GET /products/show/{subCategorySlug}/{productSlug}
```

### Request params

| Param | Tip | Məcburi | İzah |
|---|---|---|---|
| `variant` | string | - | Variant slug. Göndərilməsə default variant seçilir |
| `seller` | string | **Bəli** | Satıcının `store_code`-u (5 simvol). Yanlış kod → 404 |
| `other_sellers` | `yes`/`no` | - | `yes` olsa ilk 3 digər satıcı da gəlir |
| `with_related` | `yes`/`no` | - | `yes` olsa oxşar məhsullar da gəlir |

**Mühüm:** `seller` parametri **məcburidir**. Yanlış `store_code` verilərsə API **404** qaytarır (artıq ən ucuz satıcıya fallback etmir).

### Seller resolution məntiqi:
1. `seller` verilsə → həmin `store_code`-lu şirkətin CPV-ini axtar
2. Tapılmasa → **404** at
3. `seller` verilməsə → ən ucuz aktiv/təsdiqlənmiş CPV-i götür

### Response

```json
{
  "data": {
    "id": 101,
    "uuid": "variant-uuid",
    "slug": "bosch-filtr-16-tdi",
    "oem_code": "1457434310",
    "title": "Bosch Filtr 1.6 TDI",
    "main_image": "https://cdn.example.com/main.jpg",
    "hover_image": "https://cdn.example.com/hover.jpg",
    "images": [
      "https://cdn.example.com/img1.jpg",
      "https://cdn.example.com/img2.jpg"
    ],
    "is_set": false,
    "sets": [],
    "stock": 15,
    "price": 45.00,
    "price_final": 38.25,
    "has_discount": true,
    "discount_type": "by_percentage",
    "discount_type_title": "Faiz",
    "discount": 15,
    "year": 2022,
    "in_wishlist": false,
    "in_basket": false,
    "city": {
      "id": 1,
      "title": "Bakı"
    },
    "brand_models": [
      { "id": 7, "title": "A1" },
      { "id": 8, "title": "A3" }
    ],
    "options": [
      {
        "option": { "id": 1, "title": "Ölçü" },
        "item": { "id": 5, "title": "120x80mm" }
      }
    ],
    "ratings": {
      "average": 4.3,
      "count": 17,
      "list": [
        { "rating": 5, "count": 10 },
        { "rating": 4, "count": 4 },
        { "rating": 3, "count": 2 },
        { "rating": 2, "count": 1 },
        { "rating": 1, "count": 0 }
      ]
    },
    "seller": {
      "uuid": "cpv-uuid",
      "seller_label": "Texno Parts",
      "city": {
        "id": 1,
        "title": "Bakı"
      },
      "images": [
        "https://cdn.example.com/seller-img.jpg"
      ],
      "gallery": [
        { "source": "seller", "url": "https://cdn.example.com/seller1.jpg" },
        { "source": "variant", "url": "https://cdn.example.com/var1.jpg" },
        { "source": "product", "url": "https://cdn.example.com/prod1.jpg" }
      ]
    },
    "sellers_count": 4,
    "other_sellers": [
      {
        "uuid": "other-cpv-uuid",
        "seller_label": "Auto Depo",
        "price": 42.00,
        "price_final": 42.00,
        "has_discount": false,
        "discount_type": null,
        "discount": 0,
        "stock": 3,
        "city": { "id": 2, "title": "Sumqayıt" },
        "images": ["https://cdn.example.com/other.jpg"]
      }
    ],
    "other_sellers_total": 3,
    "related_products": [
      {
        "uuid": "related-cpv-uuid",
        "variant_slug": "mann-filtr-18-tsi",
        "title": "Mann Filtr 1.8 TSI",
        "hover_image": "https://cdn.example.com/related.jpg",
        "price": 38.00,
        "price_final": 38.00,
        "has_discount": false,
        "seller": {
          "uuid": "related-cpv-uuid",
          "store_code": "XY456",
          "label": "Parts Az",
          "city": null
        },
        "product": { "..." : "..." }
      }
    ],
    "product": {
      "id": 42,
      "uuid": "product-uuid",
      "slug": "bosch-filtr-16-tdi",
      "category_slugs": {
        "sub_category_slug": "filtrler",
        "parent_category_slug": "elektrik"
      },
      "title": "Bosch Filtr 1.6 TDI",
      "description_short": "Orijinal Bosch filtr",
      "hover_image": "https://cdn.example.com/product.jpg",
      "is_set": false,
      "brand": {
        "id": 3,
        "slug": "bosch",
        "title": "Bosch",
        "models": [
          { "id": 7, "title": "A1" },
          { "id": 8, "title": "A3" }
        ]
      }
    }
  }
}
```

### Set məhsullar haqqında

`is_set: true` olan variantlar **set**-dir (dəst).
Set-in öz qiyməti yoxdur — `sets` array-indəki hər item-in öz qiyməti var.

```json
{
  "is_set": true,
  "sets": [
    {
      "id": 201,
      "slug": "bosch-yag-filtr",
      "title": "Bosch Yağ Filtri",
      "price": 12.00,
      "price_final": 12.00,
      "stock": 20
    },
    {
      "id": 202,
      "slug": "bosch-hava-filtr",
      "title": "Bosch Hava Filtri",
      "price": 18.00,
      "price_final": 18.00,
      "stock": 8
    }
  ]
}
```

---

## 7. Digər satıcılar — `/products/{variant}/other-sellers`

**`GET /products/{productVariant}/other-sellers`**

`{productVariant}` — ProductVariant-ın `id`-si (route model binding).

Həmin variant üçün bütün aktiv/təsdiqlənmiş satıcıları listələyir. Qiymətə görə sıralanır.

### Request params

| Param | Tip | İzah |
|---|---|---|
| `page` | integer | Səhifə |
| `limit` | integer 5–100 | Limit (default: 20) |

### Response

```json
{
  "data": [
    {
      "uuid": "cpv-uuid",
      "price": 38.00,
      "price_final": 38.00,
      "has_discount": false,
      "discount_type": null,
      "discount": 0,
      "stock": 5,
      "city": { "id": 1, "title": "Bakı" },
      "seller_label": "Auto Depo",
      "images": ["https://cdn.example.com/img.jpg"]
    }
  ],
  "meta": {
    "current_page": 1,
    "per_page": 20,
    "total": 4
  }
}
```

Başqa satıcıya keçmək üçün həmin CPV-in `uuid`-si lazımdır — show endpoint isə `seller=store_code` gözləyir.

> **Qeyd:** `other-sellers` cavabında `store_code` yoxdur, yalnız `uuid` var. Show endpoint-ə birbaşa bu `uuid`-ni `seller` kimi göndərmək olmaz. Bu endpoint-dən istifadəçi satıcı seçəndə ən uyğun axın: `?other_sellers=yes` ilə show endpoint-i çağırmaq və oradakı `other_sellers` array-indəki `store_code`-u istifadə etmək. Əgər yalnız paginated other-sellers list-indən keçid lazımdırsa — backend-dən CPV uuid ilə `seller` resolve etmə əlavə edilməlidir.

---

## 8. Rəylər — `/products/{cpv}/reviews/...`

### Rəy əlavə et

**`POST /products/{companyProductVariant}/reviews/store`**

`{companyProductVariant}` — CPV-in `uuid`-si.

**Throttle:** 2 sorğu / dəqiqə

#### Request body (JSON)

```json
{
  "rating": 4,
  "name": "Əli",
  "surname": "Həsənov",
  "email": "ali@example.com",
  "review": "Məhsul çox keyfiyyətlidir, tövsiyə edirəm."
}
```

#### Validation

| Field | Qaydalar |
|---|---|
| `rating` | integer, 1–5, məcburi |
| `name` | string, max 150, məcburi |
| `surname` | string, max 150, məcburi |
| `email` | email format, max 150, məcburi |
| `review` | string, max 5000, məcburi |

#### Response

```json
{
  "data": {
    "id": 55,
    "rating": 4,
    "name": "Əli",
    "surname": "Həsənov",
    "review": "Məhsul çox keyfiyyətlidir, tövsiyə edirəm.",
    "date": "27.03.2026"
  }
}
```

---

### Rəyləri yüklə

**`GET /products/{companyProductVariant}/reviews/load`**

Yalnız **təsdiqlənmiş** rəylər gəlir.

#### Request params

| Param | Tip | İzah |
|---|---|---|
| `page` | integer | Səhifə |
| `limit` | integer 5–100 | Limit |

#### Response

```json
{
  "data": [
    {
      "id": 55,
      "rating": 4,
      "name": "Əli",
      "surname": "Həsənov",
      "review": "Məhsul çox keyfiyyətlidir.",
      "date": "27.03.2026"
    }
  ],
  "meta": {
    "current_page": 1,
    "per_page": 10,
    "total": 17
  }
}
```

---

## 9. İstək siyahısı (Wishlist)

**Auth tələb olunur** (login olmuş user).

Wishlist əməliyyatları CPV `uuid`-si ilə aparılır.

### Bütün wishlist ID-lərini al

**`GET /wishlist/ids`**

Cari istifadəçinin (və ya guestin) wishlist-indəki bütün CPV `uuid`-lərini qaytarır.
Frontend-in hansı kartların wishlist-də olduğunu yoxlamaq üçün istifadə edir.

```json
{
  "data": [
    "3f7a2c1b-...",
    "a1b2c3d4-..."
  ]
}
```

### Wishlist-i yüklə

**`GET /wishlist/load`**

### Əlavə et

**`POST /wishlist/add/{companyProductVariant}`**

#### Response (uğurlu)

```json
{
  "data": {
    "message": "Məhsul istək siyahısına əlavə edildi"
  }
}
```

#### Response (artıq əlavə edilib)

```
HTTP 400 Bad Request
```

### Sil

**`POST /wishlist/remove/{companyProductVariant}`**

---

### Wishlist response formatı

`/wishlist/load` cavabı `CompanyProductVariantListResource` formatında deyil — `ProductVariantsInBasketResource` formatında gəlir (aşağıda basket ilə eyni format).

---

## 10. Səbət (Basket)

Basket həm login olmuş, həm də **guest** istifadəçilər üçün işləyir.
Guest üçün `guest_identifier` header göndərilməlidir.

### Səbəti yüklə

**`GET /basket/load`**

#### Response

```json
{
  "data": [
    {
      "id": 101,
      "uuid": "cpv-uuid",
      "slug": "bosch-filtr-16-tdi",
      "title": "Bosch Filtr 1.6 TDI",
      "hover_image": "https://cdn.example.com/img.jpg",
      "is_set": false,
      "stock": 15,
      "price": 45.00,
      "price_final": 38.25,
      "has_discount": true,
      "discount_type": "by_percentage",
      "discount_type_title": "Faiz",
      "discount": 15,
      "in_wishlist": false,
      "in_basket": true,
      "basket_quantity": 2,
      "price_in_basket": 90.00,
      "price_final_in_basket": 76.50,
      "seller": {
        "uuid": "cpv-uuid",
        "seller_label": "Texno Parts",
        "city": { "id": 1, "title": "Bakı" },
        "images": ["https://cdn.example.com/seller.jpg"]
      },
      "product": {
        "id": 42,
        "title": "Bosch Filtr 1.6 TDI"
      },
      "sets": []
    }
  ],
  "basket_data": {
    "total_price": 90.00,
    "total_price_final": 76.50,
    "total_items": 2,
    "total_discount": 13.50
  }
}
```

### Səbətə əlavə et

**`POST /basket/add/{companyProductVariant}`**

#### Request body — adi məhsul

```json
{
  "quantity": 2
}
```

#### Request body — set məhsul

```json
{
  "quantity": 1,
  "sets": [
    { "id": 201, "quantity": 1 },
    { "id": 202, "quantity": 2 }
  ]
}
```

`sets[].id` — ProductVariant `id`-si (set item-in).

#### Response

```json
{
  "data": {
    "message": "Məhsul səbətə əlavə edildi",
    "basket_data": { "..." : "..." }
  }
}
```

### Digər basket əməliyyatları

| Endpoint | Metod | İzah |
|---|---|---|
| `/basket/remove/{cpv}` | POST | Səbətdən sil |
| `/basket/increment/{cpv}` | POST | Miqdarı artır (+1) |
| `/basket/decrement/{cpv}` | POST | Miqdarı azalt (-1) |
| `/basket/remove/{cpv}/set/{setItem}` | POST | Set item-i sil |
| `/basket/increment/{cpv}/set/{setItem}` | POST | Set item miqdarını artır |
| `/basket/decrement/{cpv}/set/{setItem}` | POST | Set item miqdarını azalt |

`{cpv}` — CPV `uuid`, `{setItem}` — ProductVariant `id`.

Increment/decrement cavabında:
```json
{
  "data": {
    "message": "Miqdar artırıldı",
    "quantity": 3,
    "basket_data": { "..." : "..." }
  }
}
```

---

## 11. Qruplar (Groups)

Məhsulları qruplara bölmək üçündür (məs: "Kampaniyalı məhsullar", "Ən çox satılanlar").
Hər qrup öz CPV-lərini gətirir.

### Tək qrup

**`GET /groups/single/{groupName}/products/load`**

| Param | Tip | İzah |
|---|---|---|
| `limit` | integer 1–50 | Neçə məhsul (default: backend-ə bağlıdır) |

#### Response

```json
{
  "data": {
    "name": "top-sellers",
    "slug": "top-satislar",
    "title": "Ən çox satılanlar",
    "description": "Bu həftənin ən çox satılan məhsulları",
    "image": "https://cdn.example.com/group.jpg",
    "product_variants": [
      {
        "uuid": "cpv-uuid",
        "variant_slug": "bosch-filtr-16-tdi",
        "title": "Bosch Filtr 1.6 TDI",
        "hover_image": "...",
        "price": 45.00,
        "price_final": 38.25,
        "seller": { "store_code": "AB123", "..." : "..." },
        "product": { "..." : "..." }
      }
    ]
  }
}
```

### Çoxlu qrup (bulk)

**`GET /groups/bulk/products/load`**

Birdən çox qrupu bir sorğuda almaq üçün.

#### Request params

```
groups[0][name]=top-sellers&groups[0][limit]=6
groups[1][name]=new-arrivals&groups[1][limit]=4
```

Və ya JSON formatında göndərilərsə:
```json
{
  "groups": [
    { "name": "top-sellers", "limit": 6 },
    { "name": "new-arrivals", "limit": 4 }
  ]
}
```

#### Response

```json
{
  "data": [
    {
      "name": "top-sellers",
      "title": "Ən çox satılanlar",
      "product_variants": [ "..." ]
    },
    {
      "name": "new-arrivals",
      "title": "Yeni gələnlər",
      "product_variants": [ "..." ]
    }
  ]
}
```

---

## 12. URL quruluşu — frontend necə link düzəldəcək?

### Siyahıdan detail-ə keçid

`/products/load` cavabında hər CPV-də bunlar var:

```json
{
  "variant_slug": "bosch-filtr-16-tdi",
  "seller": {
    "store_code": "AB123"
  },
  "product": {
    "slug": "bosch-filtr-16-tdi",
    "category_slugs": {
      "sub_category_slug": "filtrler",
      "parent_category_slug": "elektrik"
    }
  }
}
```

URL düzəltmə məntiqi:

```js
function buildProductUrl(cpv) {
  const { variant_slug, seller, product } = cpv;
  const { slug, category_slugs } = product;
  const { sub_category_slug, parent_category_slug } = category_slugs;

  const basePath = parent_category_slug
    ? `/products/show/${parent_category_slug}/${sub_category_slug}/${slug}`
    : `/products/show/${sub_category_slug}/${slug}`;

  return `${basePath}?variant=${variant_slug}&seller=${seller.store_code}`;
}
```

### Digər satıcıya keçid

İstifadəçi `other_sellers` siyahısından başqa satıcını seçəndə, həmin CPV-in `uuid`-si var.
Amma show endpoint `seller` param kimi `store_code` gözləyir, `uuid` deyil.
Buna görə `other-sellers` endpoint-indən gələn `uuid`-ni birbaşa `seller` kimi göndərmək olmaz.

**Tövsiyə olunan axın:**
- `other_sellers` array-i show cavabından gəlir: `?other_sellers=yes` ilə
- O array-dəki CPV-lərin `uuid`-si var
- İstifadəçi həmin CPV-i seçəndə backend-ə həmin `uuid`-ni göndər — bunun üçün ayrıca endpoint lazımdır ya da show endpoint-ə CPV uuid-ni `seller` yerinə göndərmək, amma hal-hazırda backend yalnız `store_code` ilə qəbul edir.
- **Ən sadə həll:** `?other_sellers=yes` ilə gələn data-dan show detail-i yenilə, ya da satıcı dəyişməni müstəqil bir "seller tab" kimi göstər.

> Əgər bu davranış dəyişəcəksə (uuid-lə də seller resolve etmək), backend-ə bildirin.

---

## 13. Bütün endpointlər — cədvəl

| Endpoint | Metod | Auth | Paginasiya | İzah |
|---|---|---|---|---|
| `/products/filters` | GET | Yox | Yox | Axtarış UI meta-datası (categories, brands, cities, price\_ranges, colors, conditions, year\_range) |
| `/products/load` | GET | Yox | Bəli | CPV siyahısı (filter: brands, categories, city\_id, colors, conditions, min/max\_year, ...) |
| `/products/show/{parentSlug}/{subSlug}/{productSlug}` | GET | Yox | Yox | Məhsul detalı (3-hissəli URL) |
| `/products/show/{subSlug}/{productSlug}` | GET | Yox | Yox | Məhsul detalı (2-hissəli URL) |
| `/products/{variant}/other-sellers` | GET | Yox | Bəli | Digər satıcılar |
| `/products/{cpv}/reviews/store` | POST | Yox | Yox | Rəy əlavə et (2/dəq throttle) |
| `/products/{cpv}/reviews/load` | GET | Yox | Bəli | Rəylər siyahısı |
| `/wishlist/ids` | GET | Login/Guest | Yox | Wishlist-dəki bütün CPV uuid-lərinin array-i |
| `/wishlist/load` | GET | Login/Guest | Bəli | İstək siyahısı (tam kart formatı) |
| `/wishlist/add/{cpv}` | POST | Login/Guest | Yox | Əlavə et (`{cpv}` = CPV uuid) |
| `/wishlist/remove/{cpv}` | POST | Login/Guest | Yox | Sil (`{cpv}` = CPV uuid) |
| `/basket/load` | GET | Login/Guest | Bəli | Səbət |
| `/basket/add/{cpv}` | POST | Login/Guest | Yox | Əlavə et |
| `/basket/remove/{cpv}` | POST | Login/Guest | Yox | Sil |
| `/basket/increment/{cpv}` | POST | Login/Guest | Yox | Miqdarı artır |
| `/basket/decrement/{cpv}` | POST | Login/Guest | Yox | Miqdarı azalt |
| `/basket/remove/{cpv}/set/{setItem}` | POST | Login/Guest | Yox | Set item sil |
| `/basket/increment/{cpv}/set/{setItem}` | POST | Login/Guest | Yox | Set item artır |
| `/basket/decrement/{cpv}/set/{setItem}` | POST | Login/Guest | Yox | Set item azalt |
| `/groups/single/{name}/products/load` | GET | Yox | Yox | Tək qrup məhsulları |
| `/groups/bulk/products/load` | GET | Yox | Yox | Çoxlu qrup məhsulları |

---

## Əlavə qeydlər

### Headers

| Header | İzah |
|---|---|
| `Authorization: Bearer {token}` | Login olmuş user üçün |
| `X-Guest-Identifier: {uuid}` | Guest user üçün (basket/wishlist) |
| `Accept-Language: az` | Lokalizasiya üçün (az/en/ru) |

### Ümumi xəta formatı

```json
{
  "message": "Seller listing not found!"
}
```

HTTP status kodları:
- `200` — uğurlu
- `400` — bad request (məs: artıq səbətdə var)
- `404` — tapılmadı (yanlış seller kodu, silinmiş məhsul, və s.)
- `422` — validation xətası
- `429` — throttle (rəy üçün: 2/dəq)

### `{cpv}` nədir — route-da?

Bütün `{companyProductVariant}` route parametrləri CPV-in **`uuid`**-si ilə resolve olunur.
Yəni: `/wishlist/add/3f7a2c1b-...` — buradakı dəyər CPV `uuid`-sidir.

Bunu list API-dən alırsınız: `cpv.uuid`.
