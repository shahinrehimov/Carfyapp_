# Axtarış təklifləri (search suggestions)

**Tarix:** 2026-10-05
**Kimə:** Next.js sayt (`carfy`) və mobil tətbiq
**Backend statusu:** hazırdır, lokalda real data üzərində test edilib
**Miqrasiya:** yoxdur

---

## 1. Qısa xülasə

Axtarış inputuna yazılan kimi açılan dropdown üçün yeni yüngül endpoint əlavə olundu. Dropdown-da göstərilənlər:

- **Məhsullar:** şəkil, ad, kateqoriya, qiymət, endirim varsa köhnə qiymət. Başqa mağazalarda da satılırsa, onların qiymət aralığı da gəlir.
- **Kateqoriyalar:** yazılan sözə uyğun nəticəsi olan kateqoriyalar və hər birində neçə nəticə olduğu.

Bunlardan əlavə, mövcud endpoint-lərdə üç dəyişiklik var (bax: [bölmə 6](#6-mövcud-endpoint-lərdə-dəyişikliklər)):

1. Yarımçıq söz axtarışı. Məsələn, `nis` yazanda `Nissan` tapılır.
2. Bütün məhsul siyahılarında yeni `product.category` sahəsi.
3. Müddəti bitmiş endirimin sahələri artıq `null` qayıdır.

> **Geriyə uyğunluq:** Heç bir sahə silinməyib, adı dəyişməyib. Yeni sahələr əlavə olunub.
> Bir davranış dəyişib: bitmiş endirimdə `discount`, `discount_type` və `discount_type_title` artıq `null` gəlir.

**Base path.** Endpoint həm sayt, həm tətbiq prefiksində eynidir:

```
https://<host>/api/site/...   ← Next.js sayt
https://<host>/api/app/...    ← mobil tətbiq
```

---

## 2. Endpoint

```
GET /products/suggestions?search={mətn}&limit=6&categories_limit=5
```

### 2.1 Header-lər

| Header | Dəyər | Qeyd |
|---|---|---|
| `Token` | app token | Məcburi (digər public endpoint-lərdəki kimi) |
| `Accept` | `application/json` | |
| `Accept-Language` | `az` / `en` / `ru` | Ad və kateqoriya tərcümələri bu dilə görə qayıdır |

Login və ya `identifier` (qonaq) tələb olunmur. Cavabda wishlist/səbət məlumatı yoxdur.

### 2.2 Parametrlər

| Parametr | Tip | Məcburi | Default | İzah |
|---|---|---|---|---|
| `search` | string | bəli | — | 2–100 simvol. Son söz yarımçıq ola bilər |
| `limit` | int | yox | `6` | Məhsul sayı, 1–10 |
| `categories_limit` | int | yox | `5` | Kateqoriya sayı, 0–10. `0` göndərsəniz kateqoriyalar qaytarılmır |

### 2.3 Limit

Dəqiqədə **60 sorğu** (IP/istifadəçi üzrə). Aşanda `429` qayıdır. Ona görə [bölmə 5](#5-frontend-üçün-tövsiyələr)-dəki debounce mütləqdir.

### 2.4 Xətalar

| Status | Nə vaxt |
|---|---|
| `422` | `search` boşdur, 2 simvoldan qısadır və ya 100-dən uzundur; `limit` aralıqdan kənardır |
| `429` | Limit aşılıb |

Heç nə tapılmayanda xəta qayıtmır, `200` ilə boş massivlər gəlir:

```json
{ "products": [], "categories": [] }
```

---

## 3. Cavab strukturu

```json
{
  "products": [
    {
      "id": 15,
      "uuid": "932e4505-4ad2-4cb0-8b55-dbcb7bd56ba6",
      "variant_slug": "et-minima-laboris-ea",
      "product_slug": "natus-sequi-omnis-au",
      "title": "Nissan Qashqai ön əyləc diski",
      "oem_code": "40206-JD00A",
      "image": "https://<host>/storage/14/conversions/disk-thumb.webp",
      "price": 408.1,
      "price_final": 367.29,
      "has_discount": true,
      "discount_type": "by_percentage",
      "discount_type_title": "Faizlə",
      "discount": 10,
      "category": {
        "title": "Əyləc diskləri",
        "slug": "eylec-diskleri",
        "parent_title": "Əyləc sistemi",
        "parent_slug": "eylec-sistemi"
      },
      "seller": {
        "store_code": "LQNTP",
        "label": "Mağaza LQNTP"
      },
      "sellers": {
        "count": 3,
        "min_price": 367.29,
        "max_price": 452.0,
        "has_other_prices": true
      }
    }
  ],
  "categories": [
    {
      "id": 2,
      "title": "Əyləc diskləri",
      "slug": "eylec-diskleri",
      "is_sub": true,
      "parent": {
        "title": "Əyləc sistemi",
        "slug": "eylec-sistemi"
      },
      "products_count": 14
    }
  ]
}
```

### 3.1 `products[]`

**Hər variant bir sətirdir.** Eyni məhsulu (variantı) bir neçə mağaza satırsa, dropdown-da təkrar sətirlər çıxmır. Sətir **ən ucuz mağazanın** listing-i ilə göstərilir. `uuid`, qiymət, endirim və `seller` həmin listing-ə aiddir. Sıra uyğunluğa görədir: ən uyğun nəticə birinci gəlir.

| Sahə | Tip | İzah |
|---|---|---|
| `id` | int | Variant id. Siyahıda `key` kimi istifadə edə bilərsiniz |
| `uuid` | string | Ən ucuz listing-in (CPV) uuid-i. `products/show/{uuid}` üçün |
| `variant_slug` | string | Detal URL-in `variant` parametri |
| `product_slug` | string | Detal URL-in son seqmenti |
| `title` | string | Variantın tam adı (məhsul adı + option dəyərləri) |
| `oem_code` | string\|null | OEM kodu. Axtarılan sözü vurğulamaq üçün göstərə bilərsiniz |
| `image` | string\|null | Kiçik şəkil (400x400 WebP). Şəkil yoxdursa `null` olur, placeholder göstərin |
| `price` | float | Endirimsiz qiymət (₼) |
| `price_final` | float | Müştərinin ödəyəcəyi qiymət (₼). **Əsas göstəriləcək qiymət budur** |
| `has_discount` | bool | `true` olanda `price` üstündən xətt çəkilib göstərilir |
| `discount_type` | string\|null | `by_percentage` və ya `by_amount`. Endirim yoxdursa `null` |
| `discount_type_title` | string\|null | Tərcümə olunmuş ad |
| `discount` | number\|null | Faizlə endirimdə faiz (`10` = 10%), məbləğlə endirimdə məbləğ. Endirim yoxdursa `null` |
| `category` | object | Məhsulun kateqoriyası, bax 3.2 |
| `seller.store_code` | string | Ən ucuz mağazanın kodu. Slug-lı detal URL-in `seller` parametri |
| `seller.label` | string | Hazır mətn, məsələn "Mağaza LQNTP" |
| `sellers` | object | Bütün mağazalar üzrə məlumat, bax 3.3 |

Qiymətlərdə platforma komissiyası artıq hesablanıb. Müştəriyə nə göstərilməlidirsə, o gəlir. Əlavə hesablama lazım deyil.

### 3.2 `category`

| Sahə | Tip | İzah |
|---|---|---|
| `title` | string\|null | Məhsulun əsas (alt) kateqoriyasının adı |
| `slug` | string\|null | Onun slug-ı |
| `parent_title` | string\|null | Valideyn kateqoriyanın adı. Kateqoriya özü üst səviyyədədirsə `null` olur |
| `parent_slug` | string\|null | Valideynin slug-ı |

Göstərmək üçün tövsiyə: `parent_title` varsa `"Əyləc sistemi › Əyləc diskləri"`, yoxdursa yalnız `title`.

### 3.3 `sellers`: başqa mağazalardakı qiymətlər

| Sahə | Tip | İzah |
|---|---|---|
| `count` | int | Bu variantı satan mağaza sayı (göstərilən mağaza da daxil) |
| `min_price` | float | Mağazalar arasında ən aşağı yekun qiymət (= bu sətirdəki `price_final`) |
| `max_price` | float | Ən yüksək yekun qiymət |
| `has_other_prices` | bool | Mağazalarda qiymət fərqlidirsə `true` |

Göstərmə qaydası:

| Hal | Nə göstərmək |
|---|---|
| `count == 1` | Yalnız qiymət |
| `count > 1` və `has_other_prices == true` | `"3 mağazada · 367.29 ₼-dan"` və ya `"367.29 – 452.00 ₼"` |
| `count > 1` və `has_other_prices == false` | `"3 mağazada"` (qiymət hamısında eynidir) |

### 3.4 `categories[]`

Tapılan məhsulların aid olduğu kateqoriyalardır. Ən çox nəticəsi olan birinci gəlir.

| Sahə | Tip | İzah |
|---|---|---|
| `id` | int | |
| `title` | string | Kateqoriya adı |
| `slug` | string | |
| `is_sub` | bool | `true`: alt kateqoriyadır. `false`: üst səviyyəli kateqoriyadır |
| `parent` | object\|null | `{ title, slug }`. `is_sub == false` olanda `null` |
| `products_count` | int | Bu axtarışla həmin kateqoriyada neçə nəticə var. Göstərmək üçün: `"Əyləc diskləri (14)"` |

---

## 4. Kliklər hara aparır

### 4.1 Məhsula klik → detal səhifəsi

**Slug ilə (web, SEO):**

```
/products/show/{category.parent_slug}/{category.slug}/{product_slug}?variant={variant_slug}&seller={seller.store_code}
```

`category.parent_slug` `null`-dursa qısa forma işlədilir:

```
/products/show/{category.slug}/{product_slug}?variant={variant_slug}&seller={seller.store_code}
```

**UUID ilə (mobil üçün daha sadədir):**

```
/products/show/{uuid}
```

Hər iki halda ən ucuz mağazanın listing-i açılır. Digər mağazalar detal səhifəsində `other_sellers=yes` ilə göstərilir, bu mövcud davranışdır.

### 4.2 Kateqoriyaya klik → axtarış nəticələri, kateqoriya filtri ilə

Axtarış mətni saxlanılır, üstünə kateqoriya filtri əlavə olunur:

| `is_sub` | Sorğu |
|---|---|
| `true` | `GET /products/load?search={mətn}&sub_categories[]={slug}` |
| `false` | `GET /products/load?search={mətn}&categories[]={slug}` |

Saytda bu, `/products?search=...&sub_categories=...` səhifəsinə keçid deməkdir (mövcud filtr parametrləri).

### 4.3 Enter / "Bütün nəticələr"

İndiki kimi: `/products?search={mətn}`. Dropdown-da görünən məhsullar həmin səhifədə də çıxır, çünki hər ikisi eyni axtarışdan istifadə edir.

---

## 5. Frontend üçün tövsiyələr

- **Debounce:** son düymədən 250–300 ms sonra sorğu göndərin.
- **Minimum 2 simvol:** 2-dən az simvolda sorğu atmayın, dropdown-u bağlayın. Backend onsuz da `422` qaytarır.
- **Köhnə cavabları atın:** istifadəçi sürətli yazanda cavablar qarışıq sırada gələ bilər. `AbortController` ilə əvvəlki sorğunu ləğv edin və ya yalnız son sorğunun cavabını göstərin.
- **Boş nəticə:** `products` və `categories` ikisi də boşdursa, "Heç nə tapılmadı" yazın və ya dropdown-u gizlədin.
- **Klaviatura:** ↑/↓ ilə sətirlər arasında keçid, Enter seçilmiş sətrə, sətir seçilməyibsə axtarış səhifəsinə aparır, Esc bağlayır.
- **Tövsiyə olunan düzülüş:**

```
┌──────────────────────────────────────────────┐
│ KATEQORİYALAR                                │
│  Əyləc sistemi › Əyləc diskləri       (14)   │
│  Əyləc sistemi › Əyləc qəlibləri       (6)   │
├──────────────────────────────────────────────┤
│ MƏHSULLAR                                    │
│ [img] Nissan Qashqai ön əyləc diski          │
│       Əyləc sistemi › Əyləc diskləri         │
│       ̶4̶0̶8̶.̶1̶0̶ ̶₼̶  367.29 ₼  -10%                │
│       3 mağazada · 367.29 ₼-dan              │
│ [img] ...                                    │
├──────────────────────────────────────────────┤
│  "nissan disk" üçün bütün nəticələr →        │
└──────────────────────────────────────────────┘
```

---

## 6. Mövcud endpoint-lərdə dəyişikliklər

### 6.1 Yarımçıq söz axtarışı

`GET /products/load?search=...` artıq yarımçıq sözü də tapır. Məsələn, `nis` yazanda `Nissan` tapılır. Əvvəl bunun üçün söz tam yazılmalı idi. Frontend-də heç nə dəyişmir.

### 6.2 `product.category` (bütün məhsul siyahıları)

[Vahid siyahı strukturunda](product-list-structure.md) `product` obyektinə yeni sahə əlavə olunub:

```json
"product": {
  "category_slugs": {
    "parent_category_slug": "eylec-sistemi",
    "sub_category_slug": "eylec-diskleri"
  },
  "category": {
    "title": "Əyləc diskləri",
    "parent_title": "Əyləc sistemi"
  }
}
```

Bu sahə `category_slugs`-ın göstəriləcək adlarıdır. Kartlarda kateqoriya adını göstərmək üçün istifadə edin.

### 6.3 Bitmiş endirim

Seller endirim üçün başlanğıc/bitmə tarixi qoya bilir. Endirim aktiv deyilsə (hələ başlamayıb və ya bitib), bütün məhsul siyahılarında:

- `has_discount: false`, `price == price_final`;
- `discount`, `discount_type`, `discount_type_title` → `null`.

Əvvəl bu halda `has_discount: false` gəlsə də, `discount` hələ köhnə dəyəri (məsələn `10`) qaytarırdı. `-10%` badge-i `discount`-a görə çəkirdinizsə, artıq yanlış göstərilməyəcək. Badge üçün yenə də `has_discount` yoxlanmalıdır.
