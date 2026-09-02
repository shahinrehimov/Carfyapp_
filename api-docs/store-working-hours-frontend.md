# Mağaza iş saatları: açıq/bağlı statusu və sifariş bloklaması

**Tarix:** 2026-08-06
**Kimə:** Next.js sayt (`carfy`) və mobil tətbiq
**Backend statusu:** hazırdır, lokalda real data üzərində test edilib
**Miqrasiya:** yoxdur — cədvəl (`company_working_hours`) və satıcı/admin redaktə ekranları artıq mövcud idi

---

## 1. Qısa xülasə

Hər mağazanın həftəlik iş qrafiki var (satıcı özü panelindən doldurur). İndiyə qədər bu qrafik
heç yerdə istifadə olunmurdu — istifadəçi gecə saat 3-də də sifariş verə bilirdi.

İki dəyişiklik:

1. **Hər yerdə `seller.availability` obyekti qayıdır** — mağazanın həmin an açıq/bağlı olduğunu,
   nə vaxt bağlanacağını / açılacağını və hazır mətn mesajını verir.
2. **Bağlı mağaza ilə checkout mümkün deyil** — `POST /orders/checkout` `400` qaytarır.
   Səbətə əlavə etmək, artırmaq, azaltmaq **bloklanmayıb** (istifadəçi səbəti sabah üçün hazırlaya bilsin).

> **Geriyə uyğunluq:** Heç bir mövcud sahə silinməyib və ya adı dəyişməyib. Yalnız yeni sahələr əlavə olunub.
> Bu gün DB-də hələ heç bir mağazanın qrafiki doldurulmayıb — **qrafiksiz mağaza həmişə açıq sayılır**,
> yəni deploy-dan dərhal sonra heç nə bloklanmayacaq. Bloklama satıcılar qrafiklərini doldurduqca işə düşəcək.

**Base path.** Hər şey həm sayt, həm tətbiq prefiksində eynidir:

```
https://<host>/api/site/...   ← Next.js sayt
https://<host>/api/app/...    ← mobil tətbiq
```

---

## 2. `availability` obyekti

Bu obyekt **hər yerdə eyni struktura malikdir**. Bir dəfə komponent yazın, hər yerdə işlədin.

### 2.1 Mağaza bağlıdırsa

```json
{
  "is_open": false,
  "status": "closed",
  "today": {
    "is_closed": false,
    "open_time": "09:00",
    "close_time": "17:00"
  },
  "closes_at": null,
  "opens_at": "2026-08-07T09:00:00+04:00",
  "opens_at_time": "09:00",
  "opens_at_day_of_week": 5,
  "message": "Mağaza MECCP hazırda bağlıdır. Sifarişinizi sabah saat 09:00-dan verə bilərsiniz."
}
```

### 2.2 Mağaza açıqdırsa

```json
{
  "is_open": true,
  "status": "open",
  "today": {
    "is_closed": false,
    "open_time": "08:00",
    "close_time": "23:00"
  },
  "closes_at": "2026-08-06T23:00:00+04:00",
  "opens_at": null,
  "opens_at_time": null,
  "opens_at_day_of_week": null,
  "message": null
}
```

### 2.3 Sahələrin izahı

| Sahə | Tip | İzah |
|---|---|---|
| `is_open` | `boolean` | **Əsas sahə.** Mağaza həmin an sifariş qəbul edirmi. UI qərarlarını buna görə verin. |
| `status` | `"open"` \| `"closed"` | `is_open`-in mətn variantı. Gələcəkdə yeni dəyər əlavə oluna bilər — `switch`-də `default` qoyun. |
| `today.is_closed` | `boolean` | Mağaza **bu gün ümumiyyətlə işləmir** (istirahət günü). `true` olanda `open_time`/`close_time` `null` olur. |
| `today.open_time` | `"HH:mm"` \| `null` | Bugünkü açılış saatı. |
| `today.close_time` | `"HH:mm"` \| `null` | Bugünkü bağlanış saatı. |
| `closes_at` | ISO 8601 \| `null` | **Yalnız açıq olanda dolu.** Mağazanın bu gün bağlanacağı tam an. "2 saat sonra bağlanır" kimi geri sayım üçün. |
| `opens_at` | ISO 8601 \| `null` | **Yalnız bağlı olanda dolu.** Növbəti açılış anı. Bütün 7 gün bağlıdırsa `null`. |
| `opens_at_time` | `"HH:mm"` \| `null` | `opens_at`-ın yalnız saat hissəsi (rahatlıq üçün). |
| `opens_at_day_of_week` | `1..7` \| `null` | Növbəti açılış günü. **1 = Bazar ertəsi, 7 = Bazar** (ISO-8601). |
| `message` | `string` \| `null` | Bağlı olanda hazır, tərcümə olunmuş mətn. Açıq olanda **həmişə `null`**. |

**Vacib qeydlər:**

- `opens_at` və `closes_at` **saat qurşağı ofseti ilə** gəlir (`+04:00`). `new Date(...)` düzgün parse edir.
  Backend Asia/Baku qurşağında işləyir.
- İnterval **yarımaçıqdır**: `open_time <= indi < close_time`. Yəni saat tam `close_time` olanda mağaza
  artıq bağlıdır. Açılış anında isə açıqdır.
- Gecə keçən qrafik (məsələn 09:00–02:00) **dəstəklənmir** — validasiya `close_time > open_time` tələb edir.
- `message` `Accept-Language` header-inə görə tərcümə olunur. Öz mətninizi qurmaq istəyirsinizsə
  `opens_at` + `opens_at_day_of_week`-dən istifadə edin, amma **sadə hal üçün `message`-i olduğu kimi göstərmək kifayətdir**.

---

## 3. `availability` hansı endpoint-lərdə gəlir

### 3.1 Bütün məhsul siyahılarında — `seller.availability`

[Kanonik məhsul siyahısı strukturuna](product-list-structure.md) `seller` blokunun içində
yeni `availability` açarı əlavə olundu. Yəni **bu strukturu qaytaran bütün endpoint-lərdə var**:

| Endpoint | Yol |
|---|---|
| `GET /products/load` | `data[].seller.availability` |
| `GET /basket/load` | `data[].seller.availability` |
| `GET /wishlist/load` | `data[].seller.availability` |
| `GET /groups/single/{groupName}/products/load` | `product_variants[].seller.availability` |
| `GET /groups/bulk/products/load` | `data[].product_variants[].seller.availability` |
| `GET /products/{productVariant}/other-sellers` | `data[].seller.availability` |
| `GET /products/show/...` → `related_products[]` | `related_products[].seller.availability` |
| `GET /products/show/...` → `other_sellers[]` | `other_sellers[].seller.availability` |
| `GET /orders/show/{order}` → `items[]` | `items[].product.seller.availability` |
| `GET /orders/details/{order}` → `items[]` | `items[].product.seller.availability` |
| `GET /orders/checkout-preview` → `sellers[].items[]` | `...items[].product.seller.availability` |

> ⚠️ **`seller` bloku `null` ola bilər.** Səbətdəki set (komplekt) elementləri və köhnə sətirlər üçün
> satıcı bağlantısı olmur və `seller: null` qayıdır. Həmişə optional chaining işlədin:
> `item.seller?.availability?.is_open !== false`. Diqqət: `?? true` yox, `!== false` —
> `seller` yoxdursa məhsulu bağlı kimi göstərməyin.

Nümunə (`products/load`-dan bir sətir, yalnız `seller` bloku):

```json
"seller": {
  "uuid": "d1a86638-15a2-49c8-a0d4-7b5150bf3d8f",
  "store_code": "LQNTP",
  "label": "Mağaza LQNTP",
  "availability": {
    "is_open": false,
    "status": "closed",
    "today": { "is_closed": true, "open_time": null, "close_time": null },
    "closes_at": null,
    "opens_at": "2026-08-07T09:00:00+04:00",
    "opens_at_time": "09:00",
    "opens_at_day_of_week": 5,
    "message": "Mağaza LQNTP hazırda bağlıdır. Sifarişinizi sabah saat 09:00-dan verə bilərsiniz."
  },
  "city": { "id": 1, "title": "Bakı" },
  "images": []
}
```

> Sifariş tarixçəsində (`orders/show`, `orders/details`) də `availability` gəlir, çünki eyni kanonik
> struktur işlədilir. Orada onu **göstərməyin** — keçmiş sifarişin mağaza statusu ilə əlaqəsi yoxdur.

### 3.2 Məhsul detalı — əlavə olaraq tam qrafik

`GET /products/show/{cpvUuid}` və slug variantlarında `seller` bloku **əlavə olaraq** həftəlik
qrafiki də qaytarır (siyahılarda bu yoxdur — payload böyüməsin deyə):

```json
"seller": {
  "uuid": "...",
  "store_code": "MECCP",
  "label": "Mağaza MECCP",
  "seller_label": "Mağaza MECCP",
  "availability": { "...": "yuxarıdakı struktur" },
  "working_hours": [
    { "day_of_week": 1, "is_closed": false, "open_time": "09:00", "close_time": "17:00" },
    { "day_of_week": 2, "is_closed": false, "open_time": "09:00", "close_time": "17:00" },
    { "day_of_week": 3, "is_closed": false, "open_time": "09:00", "close_time": "17:00" },
    { "day_of_week": 4, "is_closed": false, "open_time": "09:00", "close_time": "17:00" },
    { "day_of_week": 5, "is_closed": false, "open_time": "09:00", "close_time": "17:00" },
    { "day_of_week": 6, "is_closed": true,  "open_time": null,    "close_time": null },
    { "day_of_week": 7, "is_closed": true,  "open_time": null,    "close_time": null }
  ],
  "city": { "...": "..." },
  "images": [],
  "gallery": []
}
```

**`working_hours` haqqında:**

- Massiv `day_of_week` üzrə **artan sırada** gəlir (1 → 7).
- **7 elementin hamısı olmaya bilər.** Satıcı qrafiki doldurmayıbsa massiv **boş** (`[]`) gəlir —
  bu halda `availability.is_open` həmişə `true` olur. UI-da "İş saatları göstərilməyib" yazın və ya bölməni gizlədin.
- `is_closed: true` olan gün üçün `open_time` və `close_time` **həmişə `null`-dır**.

---

## 4. Checkout axını

### 4.1 `GET /orders/checkout-preview?address_id={id}` — yeni sahələr

Cavabın **üst səviyyəsinə** iki yeni sahə əlavə olundu, `sellers[]` sətirlərinə isə ikisi:

```json
{
  "sellers": [
    {
      "company_id": 3,
      "store_code": "LQNTP",

      "is_open": false,
      "availability": { "...": "2-ci bölmədəki struktur" },

      "items": [ { "quantity": 1, "price": 42.5, "product": { "...": "kanonik struktur" } } ],
      "subtotal": 42.5,
      "weight_warning": false,
      "shipping": 4.9,
      "shipping_eta_minutes": 35,
      "shipping_is_estimate": false,
      "is_sedan": false
    }
  ],
  "subtotal": 42.5,
  "total_shipping": 4.9,
  "grand_total": 47.4,

  "can_checkout": false,
  "closed_sellers": [
    {
      "company_id": 3,
      "store_code": "LQNTP",
      "opens_at": "2026-08-07T09:00:00+04:00",
      "message": "Mağaza LQNTP hazırda bağlıdır. Sifarişinizi sabah saat 09:00-dan verə bilərsiniz."
    }
  ],

  "referral": { "...": "dəyişməyib" }
}
```

| Sahə | Tip | İzah |
|---|---|---|
| `can_checkout` | `boolean` | **Bütün mağazalar açıqdırmı.** `false` olanda "Sifarişi tamamla" düyməsini deaktiv edin. |
| `closed_sellers` | `array` | Bağlı mağazaların siyahısı. `can_checkout: true` olanda **boş massiv** (`[]`). |
| `sellers[].is_open` | `boolean` | Həmin satıcı bloku üçün qısa yol. `sellers[].availability.is_open` ilə eynidir. |
| `sellers[].availability` | `object` | Tam struktur (2-ci bölmə). |

**Qiymət hesablamaları dəyişməyib.** `subtotal`, `total_shipping`, `grand_total` bağlı mağazaların
məhsullarını **da** daxil edir — heç nə çıxılmır. Bu qəsdəndir: sifariş ya tamamilə gedir, ya heç getmir.

### 4.2 `POST /orders/checkout` — yeni xəta

Səbətdə **ən azı bir bağlı mağaza** varsa sifariş yaradılmır:

```
HTTP 400
{
  "message": "Mağaza LQNTP hazırda bağlıdır. Sifarişinizi sabah saat 09:00-dan verə bilərsiniz."
}
```

Bir neçə mağaza bağlıdırsa mesaj birləşdirilmiş gəlir:

```
HTTP 400
{
  "message": "Səbətinizdəki bəzi mağazalar hazırda bağlıdır: Mağaza TKZFA, Mağaza RMHYR. Sifarişinizi onların iş saatlarında tamamlaya bilərsiniz."
}
```

**Emal qaydası:** Bu, `basket_empty` və `insufficient_stock_for_product` ilə **eyni formatdır** —
sadəcə `400` + `message`. Artıq mövcud olan xəta emalınız işləyəcək, `message`-i toast/alert kimi göstərin.

**Yoxlama sırası** (backend-də hansı xəta əvvəl atılır):

1. Çatdırılma xidməti sıradan çıxıbsa → `delivery_service_unavailable`
2. Səbət boşdursa → `basket_empty`
3. **Bağlı mağaza varsa → yeni xəta** ← burada
4. Ünvan tapılmasa → `selected_address_not_found`
5. Stok çatmasa / məhsul deaktivdirsə → `insufficient_stock_for_product` / `product_no_longer_available`

Yəni bağlı mağaza xətası **stok yoxlamasından əvvəl** gəlir.

### 4.3 Səbət əməliyyatları bloklanmayıb

Bunların heç biri iş saatına baxmır və dəyişməyib:

- `POST /basket/add/{cpvUuid}`
- `POST /basket/increment/{cpvUuid}` / `decrement`
- `POST /basket/remove/{cpvUuid}`
- `POST /wishlist/add/{cpvUuid}` / `remove`

---

## 5. UI üçün tövsiyələr

### 5.1 Məhsul kartı (siyahılar)

`seller.availability.is_open === false` olanda mağaza adının yanında kiçik nişan:

```
🔴 Bağlı · sabah 09:00-dan
```

Kartı **deaktiv etməyin** — məhsul səbətə əlavə oluna bilər.

### 5.2 Məhsul detalı

- Satıcı blokunda açıq/bağlı badge + `availability.message`.
- Açıqdırsa `closes_at`-dan istifadə edərək "Bu gün 17:00-a qədər açıqdır" göstərmək olar.
- `working_hours` massivini açılan bölmə kimi verin (7 sətir, `day_of_week` → gün adı).
  Massiv boşdursa bölməni göstərməyin.
- "Səbətə at" düyməsi **aktiv qalır**.

### 5.3 Səbət

Bağlı mağazanın sətirlərini vizual olaraq fərqləndirin (solğun fon + kiçik xəbərdarlıq),
amma silməyin və düymələri kilidləməyin.

### 5.4 Checkout səhifəsi

Bu, ən vacib nöqtədir:

1. `checkout-preview` cavabında `can_checkout === false` olanda **"Sifarişi tamamla" düyməsini deaktiv edin.**
2. Səhifənin yuxarısında `closed_sellers[].message` mətnlərini xəbərdarlıq banneri kimi göstərin.
3. Hər bağlı satıcı blokunun üstündə də eyni mesajı təkrarlayın (`sellers[].availability.message`).
4. Yanında "Bu məhsulları səbətdən çıxar" düyməsi qoyun — istifadəçi qalan satıcılarla davam edə bilsin.
5. `POST /orders/checkout`-un `400` cavabını yenə də emal edin: istifadəçi səhifədə uzun müddət
   qalıbsa mağaza aralıqda bağlana bilər (preview 18:59-da alınıb, düymə 19:01-də basılıb).

### 5.5 Sifariş tarixçəsi

`orders/show` və `orders/details` cavabındakı `items[].product.seller.availability`-ni **göstərməyin**.

### 5.6 Ümumi kod nümunəsi

```ts
type Availability = {
  is_open: boolean;
  status: 'open' | 'closed';
  today: { is_closed: boolean; open_time: string | null; close_time: string | null };
  closes_at: string | null;
  opens_at: string | null;
  opens_at_time: string | null;
  opens_at_day_of_week: 1 | 2 | 3 | 4 | 5 | 6 | 7 | null;
  message: string | null;
};

// seller null ola bilər — bilinmirsə bağlı saymayın
const isClosed = (seller?: { availability?: Availability } | null) =>
  seller?.availability?.is_open === false;
```

---

## 6. Test üçün

Lokalda mağazanın qrafikini satıcı panelindən dəyişib bütün halları yoxlaya bilərsiniz:

| Ssenari | Qrafik | Gözlənilən |
|---|---|---|
| Açıqdır | bugünkü gün, indiki saatı əhatə edən interval | `is_open: true`, `message: null`, `closes_at` dolu |
| Bu gün bağlanıb | bugünkü `close_time` keçmişdə | `is_open: false`, `opens_at` sabah |
| Hələ açılmayıb | bugünkü `open_time` gələcəkdə | `is_open: false`, `opens_at` bu gün, mesaj "bu gün ... saatdan" |
| İstirahət günü | bugünkü gün `is_closed: true` | `today.is_closed: true`, `opens_at` növbəti işlək gün |
| İki gün bağlı | bu gün + sabah bağlı | mesajda gün adı çəkilir ("şənbə günü ...") |
| Tam bağlı | 7 günün hamısı `is_closed: true` | `opens_at: null`, mesaj "yenidən cəhd edin" |
| Qrafik yoxdur | heç bir sətir yoxdur | `is_open: true`, `working_hours: []` |

Sərhəd halları: saat tam `open_time` olanda **açıq**, tam `close_time` olanda **bağlı**.

---

## 7. Tərcümələr

Mesaj mətnləri `LangService` açarlarıdır və **admin panelin tərcümə bölməsindən** redaktə olunur.
Backend ilk istifadədə açarları ingiliscə default mətnlə yaradır — **AZ və RU variantlarını
əl ilə doldurmaq lazımdır**, əks halda istifadəçi ingiliscə mətn görəcək.

| Açar | İngiliscə default |
|---|---|
| `store_closed_opens_today` | `@store is closed right now. You can place your order today from @time.` |
| `store_closed_opens_tomorrow` | `@store is closed right now. You can place your order tomorrow from @time.` |
| `store_closed_opens_on_day` | `@store is closed right now. You can place your order on @day from @time.` |
| `store_closed_indefinitely` | `@store is closed right now. Please try again later.` |
| `stores_closed_multiple` | `Some stores in your basket are closed right now: @stores. You can complete your order during their working hours.` |
| `weekday_1` … `weekday_7` | `Monday` … `Sunday` |

Placeholder-lər: `@store` (mağaza adı), `@stores` (vergüllə ayrılmış siyahı), `@time` (`HH:mm`), `@day` (gün adı).
Tərcümədə bu placeholder-ləri **olduğu kimi saxlamaq** lazımdır.

> Bu sənəddəki azərbaycanca nümunə mesajlar tərcümələr doldurulandan **sonrakı** görüntünü əks etdirir.
> Tərcümə edilməyibsə API ingiliscə default mətni qaytaracaq.
