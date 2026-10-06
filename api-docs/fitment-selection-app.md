# Maşın seçimi (marka + model) səbətə əlavə edərkən: Sayt və mobil tətbiq

**Tarix:** 2026-10-05
**Kimə:** Next.js sayt (`carfy`) və mobil tətbiq
**Backend statusu:** hazırdır, lokalda real data üzərində test edilib
**Geriyə uyğunluq:** pozulmur. Yeni sahələr əlavə olunub. Satıcı funksiyanı yandırmayan məhsullarda heç nə dəyişmir.

---

## 1. Nə dəyişdi

Bəzi satıcılar bir hissəni (məsələn emblem, şüşə, fənər) bir neçə maşın üçün satır. Hər maşının hissəsi **fiziki olaraq ayrıdır**, amma hamısı **eyni məhsul, eyni qiymət və eyni stok** kimi satılır.

Satıcı variantda `requires_fitment_selection = true` edəndə:

1. Müştəri məhsulu səbətə atarkən **modal açılmalıdır**. Müştəri orada **marka və model** seçir. Hər ikisi məcburidir.
2. Seçim səbət sətrinə, oradan da sifarişə düşür. Satıcı və admin seçilmiş maşını görür.
3. Eyni məhsulu müştəri **fərqli maşınlar üçün** ayrı-ayrı ata bilər. Səbətdə bunlar **ayrı sətirlər** kimi görünür.

> Set məhsullarda (`is_set = true`) bu funksiya yoxdur, həmişə `false` qayıdır.

**Base path** (hər iki prefiksdə eynidir):

```
/api/site/...   ← Next.js sayt
/api/app/...    ← mobil tətbiq
```

---

## 2. Bayraq: `requires_fitment_selection`

Bütün məhsul kartlarında var: products load, groups, related, wishlist, basket, order items, checkout preview.

```json
{
  "uuid": "901bb01b-a4ad-4bea-9b1e-897e17faa0cc",
  "title": "...",
  "is_set": false,
  "requires_fitment_selection": true
}
```

`true` olan kartda "Səbətə at" düyməsi birbaşa `basket/add` çağırmamalıdır. Əvvəl modal açılmalıdır (bax: §3).

---

## 3. Modal üçün seçimlər

`GET /products/show/{cpvUuid}` və slug ilə olan iki show endpoint-i:

```json
{
  "requires_fitment_selection": true,
  "fitment_selection_options": {
    "any_brand": false,
    "brands": [
      {
        "id": 24,
        "title": "BMW",
        "any_model": false,
        "models": [
          { "id": 703, "title": "325" },
          { "id": 704, "title": "328" }
        ]
      },
      {
        "id": 20,
        "title": "BAIC",
        "any_model": true,
        "models": []
      }
    ]
  }
}
```

`requires_fitment_selection = false` olanda `fitment_selection_options = null` qayıdır.

### Modalın qurulması

| Sahə | Mənası | UI |
|---|---|---|
| `any_brand: false` | Yalnız `brands[]` siyahısındakı markalar | Marka dropdown-u `brands[]`-dan |
| `any_brand: true` | İstənilən marka (universal məhsul) | Marka dropdown-u `GET /car-libraries/brands`-dan |
| `brand.any_model: false` | Yalnız `models[]` siyahısındakı modellər | Model dropdown-u `models[]`-dan |
| `brand.any_model: true` | Markanın istənilən modeli | Model dropdown-u `GET /car-libraries/brands/{brandId}/models`-dan |

- **Marka və model hər ikisi məcburidir.** Model seçilməyibsə "Səbətə at" düyməsi aktiv olmamalıdır.
- Tək istisna: `any_model: true` olan və kitabxanada heç bir aktiv modeli olmayan marka. Bu halda models endpoint-i boş qaytarır və `brand_model_id` göndərməmək olar.
- Siyahıda bir marka və bir model varsa, onları avtomatik seçmək olar, amma modalı göstərmək yenə də yaxşıdır ki, müştəri seçimi görsün.
- **Siyahıdakı kartdan** atılırsa (products load, groups və s.): show cavabında seçimlər yoxdur. Modal açılanda `GET /products/show/{uuid}` çağırıb `fitment_selection_options` götürün.

---

## 4. Səbət endpoint-ləri

### 4.1 Əlavə et

```
POST /basket/add/{cpvUuid}
```

```json
{
  "quantity": 1,
  "brand_id": 24,
  "brand_model_id": 703
}
```

- `requires_fitment_selection = true` olanda `brand_id` və `brand_model_id` məcburidir.
- `false` olan məhsulda göndərilsə də **ignore** olunur.
- **Eyni** maşın seçimi ilə təkrar `add` həmin sətrin miqdarını **əvəzləyir**. Bu, köhnə davranışdır.
- **Fərqli** maşın seçimi ilə `add` **yeni sətir** yaradır.
- Stok yoxlaması məhsulun bütün sətirlərinin **cəmi** üzrə aparılır. Məsələn, stok 4-dürsə, BMW üçün 2 + BAIC üçün 2 olar, 3-cü əlavə rədd olunur.

Xətalar (`400`, `message`):

| Mesaj | Səbəb |
|---|---|
| `Please choose the car brand this product is for.` | `brand_id` yoxdur |
| `Please choose the car model this product is for.` | `brand_model_id` yoxdur |
| `The selected car brand is not available for this product.` | Marka bu məhsula uyğun deyil |
| `The selected car model is not available for this product.` | Model markaya və ya məhsula uyğun deyil |

### 4.2 Artır / azalt / sil

```
POST /basket/increment/{cpvUuid}
POST /basket/decrement/{cpvUuid}
POST /basket/remove/{cpvUuid}
```

Body **optional**-dır:

```json
{ "brand_id": 24, "brand_model_id": 703 }
```

- Məhsul səbətdə **bir sətirdirsə**, body lazım deyil. Bu, köhnə davranışdır.
- Məhsul **bir neçə maşın üçün** səbətdədirsə, hansı sətir nəzərdə tutulursa onun `fitment_selection` dəyərlərini göndərin. Göndərilməsə `400` qayıdır: `This product is in the basket for several cars. Please specify which one.`
- **Tövsiyə:** səbət ekranında bu üç düyməyə həmişə sətrin `fitment_selection.brand.id` / `fitment_selection.brand_model.id` dəyərlərini göndərin (null-dursa göndərməyin).
- Məhsul səhifəsindəki +/- düymələri üçün də eyni qayda keçərlidir. Seçim tələb olunan məhsulda səhifədə +/- əvəzinə yalnız "Səbətə at" (modal ilə) göstərmək daha sadədir.

### 4.3 Səbəti yüklə

```
GET /basket/load
```

Hər sətirdə yeni sahə var:

```json
{
  "uuid": "901bb01b-...",
  "basket_quantity": 2,
  "requires_fitment_selection": true,
  "fitment_selection": {
    "brand": { "id": 24, "title": "BMW" },
    "brand_model": { "id": 703, "title": "325" }
  }
}
```

> ⚠️ **Eyni `uuid` səbətdə bir neçə dəfə gələ bilər**, çünki hər maşın seçimi ayrı sətirdir. List key kimi tək `uuid` istifadə etməyin. `uuid + brand.id + brand_model.id` istifadə edin.

- Sətrin altında "BMW 325 üçün" kimi göstərin.
- `fitment_selection = null`, amma `requires_fitment_selection = true` ola bilər. Bu o deməkdir ki, satıcı funksiyanı məhsul səbətə atılandan sonra yandırıb. Belə sətirdə "Maşın seçin" xəbərdarlığı göstərin. Düzəltmək üçün: `remove` (body-siz), sonra seçimlə `add`.
- `basket/ids` dəyişməyib: hər elan bir dəfə qayıdır.
- Siyahılardakı `basket_quantity` artıq məhsulun **bütün sətirlərinin cəmidir**.

---

## 5. Checkout

`GET /orders/checkout-preview` və `POST /orders/checkout` hər sətrin seçimini **yenidən yoxlayır**. Arada satıcı fitment-i dəyişmiş və ya funksiyanı yeni yandırmış ola bilər.

Problemli sətir varsa `400` qayıdır:

```
Please choose the car brand and model for <məhsul adı> in your basket. <səbəb>
```

Checkout preview-da hər item-də `fitment_selection` də var:

```json
{
  "quantity": 1,
  "price": 218.9,
  "fitment_selection": { "brand": {...}, "brand_model": {...} },
  "product": { ... }
}
```

---

## 6. Sifarişlər

`GET /orders/show/{id}` və `GET /orders/details/{id}` → `items[]`:

```json
{
  "quantity": 1,
  "amount": 218.9,
  "amount_final": 218.9,
  "fitment_selection": {
    "brand": { "id": 24, "title": "BMW" },
    "brand_model": { "id": 703, "title": "325" }
  },
  "product": { ... }
}
```

Seçim yoxdursa `fitment_selection = null`. Eyni məhsul bir sifarişdə fərqli maşınlar üçün iki item ola bilər.

---

## 7. Yoxlama siyahısı

- [ ] Kartda `requires_fitment_selection = true` → "Səbətə at" modal açır
- [ ] Modal `fitment_selection_options` ilə qurulur, `any_brand` / `any_model` halları car-libraries endpoint-lərinə gedir
- [ ] Marka + model seçilmədən əlavə etmək olmur
- [ ] `basket/add` body-sinə `brand_id`, `brand_model_id`
- [ ] Səbətdə list key = `uuid + brand + model`; sətirdə "BMW 325 üçün"
- [ ] increment / decrement / remove sətrin seçimini göndərir
- [ ] `fitment_selection = null` + `requires = true` → xəbərdarlıq
- [ ] Sifariş detalında seçim göstərilir
