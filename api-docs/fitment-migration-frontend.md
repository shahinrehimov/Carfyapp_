# Uyğunluq (fitment) yeniləməsi — frontend & mobil

**Tarix:** 2026-07-28
**Kimə:** Frontend (web + mobil)
**Status:** Backend-də tamamlandı, deploy gözləyir

---

## 1. Qısa xülasə

> **Breaking change YOXDUR.** Mövcud sahələr və filtr parametrləri eyni adla işləməyə davam edir.
> Kodunuzda heç nə dəyişməsə də tətbiq işləyəcək. Aşağıdakılar könüllü yeniləmələrdir.

İki yeni imkan əlavə olundu:

1. **Universal məhsullar** — dəsmal, yağ, aksesuar kimi bütün avtomobillərə uyğun gələn məhsullar.
   Əvvəl bunları ifadə etmək mümkün deyildi, satıcı məcburən uydurma marka seçirdi.
2. **İl aralığı** — "2012-2017 arası modellərə uyğundur". Əvvəl yalnız tək il yazıla bilirdi.

Bunun üçün marka/model/il məlumatı **fitment** adlı vahid struktura köçürüldü.

**Diqqət tələb edən yeganə davranış dəyişikliyi:** universal məhsullar artıq **hər** marka və model
axtarışında çıxır. Bölmə 4-ə baxın — UI-da nişan göstərilməsi tövsiyə olunur.

---

## 2. Fitment nədir

Bir fitment sətri "bu maşına uyğun gəlir" deməkdir. **`null` = "hamısı"**:

| Sətir | Mənası |
|---|---|
| `{brand: null, brand_model: null, year_from: null, year_to: null}` | Bütün avtomobillərə (universal) |
| `{brand: BMW, brand_model: null, ...}` | Bütün BMW modellərinə |
| `{brand: BMW, brand_model: X5, year_from: 2012, year_to: 2017}` | BMW X5, 2012-2017 |
| `{brand: BMW, brand_model: X5, year_from: 2018, year_to: null}` | BMW X5, 2018 və sonrası |

Bir məhsulun bir neçə fitment sətri ola bilər — məsələn həm BMW X5 2012-2017-yə, həm də
Mercedes GLE 2015-2020-yə uyğun gələn hissə iki sətirlə ifadə olunur. Bu, əvvəl mümkün deyildi.

---

## 3. Cavabdakı yeni sahələr

`products/show`, `products/load` və bütün variant obyektlərində:

```jsonc
{
  // ── KÖHNƏ SAHƏLƏR — silinməyib, işləməyə davam edir ──
  "year": 2012,                    // deprecated → year_from
  "brand_models": [                // deprecated → fitments
    { "id": 219, "title": "Pathfinder" }
  ],

  // ── YENİ SAHƏLƏR ──
  "year_from": 2012,               // null = alt sərhəd yoxdur
  "year_to": 2017,                 // null = üst sərhəd yoxdur
  "is_universal": false,           // true = bütün avtomobillərə uyğundur
  "fitments": [
    {
      "brand":       { "id": 24, "title": "BMW" },   // null = bütün markalar
      "brand_model": { "id": 705, "title": "330" },  // null = markanın bütün modelləri
      "year_from": 2012,
      "year_to": 2017
    }
  ]
}
```

### Köhnə sahələr necə hesablanır

| Sahə | Qayda |
|---|---|
| `year` | `year_from` ilə eynidir |
| `year_from` | Bütün fitmentlərin ən kiçik `year_from`-u. **Hər hansı sətir açıqdırsa → `null`** |
| `year_to` | Bütün fitmentlərin ən böyük `year_to`-su. **Hər hansı sətir açıqdırsa → `null`** |
| `brand_models` | Fitmentlərdə **adı çəkilən** modellər. Universal və "bütün modellər" sətirləri model adlandırmadığı üçün buraya düşmür → universal məhsulda `brand_models: []` |

> Universal məhsulda `year`, `year_from`, `year_to` hamısı `null`, `brand_models` isə boş massivdir.
> Əgər hazırda `year`-ı şərtsiz göstərirsinizsə, `null` halını yoxlayın.

### Göstərmə tövsiyəsi

```
is_universal                        → "Bütün avtomobillərə uyğundur"
year_from && year_to && bərabər     → "2015"
year_from && year_to                → "2012–2017"
yalnız year_from                    → "2018+"
yalnız year_to                      → "–2017"
ikisi də null                       → il göstərmə
```

---

## 4. ⚠️ Filtr davranışı dəyişdi

**Parametrlər eynidir** — `brands[]`, `models[]`, `min_year`, `max_year`, `user_car_id`.
Dəyişən odur ki, **universal məhsullar artıq hər nəticədə çıxır**.

Nümunə: `GET /products/load?brands[]=bmw`

```
əvvəl:  yalnız BMW hissələri
indi:   BMW hissələri + universal məhsullar (dəsmal, yağ, ...)
```

Bu, düzgün davranışdır — dəsmal həqiqətən BMW-yə də uyğun gəlir. **Amma istifadəçi BMW axtarışında
dəsmal görəndə çaşa bilər**, ona görə siyahıda universal məhsulların yanında nişan göstərmək tövsiyə
olunur:

```jsx
{item.is_universal && <Badge>Bütün avtomobillər</Badge>}
```

### `min_year` / `max_year` semantikası

Əvvəl tək il ilə müqayisə edilirdi, indi **aralıqların kəsişməsi** yoxlanılır. Yəni
`min_year=2015&max_year=2015` sorğusu 2012-2017 aralığına satılan hissəni **tapır** (əvvəl tapmırdı).

### `user_car_id` artıq maşının ilini də nəzərə alır

Əvvəl yalnız model yoxlanılırdı və istifadəçiyə öz maşınının ilinə uyğun gəlməyən hissələr də
göstərilirdi. İndi model **və** il birlikdə yoxlanılır, üstəlik universal məhsullar da daxil edilir.
Nəticələr azala bilər — bu, dəqiqliyin artmasıdır.

### `/products/filters` → `year_range`

Struktur dəyişməyib (`{min, max}`), amma dəyərlər artıq fitment aralıqlarından hesablanır.

---

## 5. Satıcı paneli API-si (yalnız seller panel üçün)

> Bu bölmə app/site komandasına aid deyil. Seller panel React layihəsində artıq tətbiq olunub.

Məhsul/variant yaratma və yeniləmə request-i dəyişdi:

**Əvvəl:**
```
brand_id=24
brand_model_ids[0]=705&brand_model_ids[1]=706
year=2015
```

**İndi:**
```
is_universal=1                          # qısa forma — universal məhsul üçün
   VƏ YA
fitments[0][brand_id]=24
fitments[0][brand_model_id]=705         # buraxılsa: markanın bütün modelləri
fitments[0][year_from]=2012             # buraxılsa: alt sərhəd yoxdur
fitments[0][year_to]=2017               # buraxılsa: üst sərhəd yoxdur
fitments[1][brand_id]=12
fitments[1][brand_model_id]=219
```

Validasiya qaydaları:
- `is_universal` yoxdursa ən azı bir `fitments` sətri məcburidir
- `brand_model_id` verilibsə `brand_id` də məcburidir və model həmin markaya aid olmalıdır
- `year_to >= year_from`
- eyni sətir təkrarlana bilməz
- illər `1900`..`cari il + 1` aralığında

`products.brand_id` sahəsi **tamamilə silindi** — marka artıq variant fitmentlərindədir.

---

## 6. Deprecation qrafiki

`year` və `brand_models` sahələri **ən azı 2026-12-31-ə qədər** qalacaq. Silinməzdən əvvəl ayrıca
xəbərdarlıq ediləcək. Yeni ekranlarda birbaşa `fitments` / `year_from` / `year_to` istifadə edin.

---

## 7. Yoxlama siyahısı

- [ ] `year`-ı göstərən yerlərdə `null` halı işlənib (universal məhsul)
- [ ] Siyahılarda `is_universal` üçün nişan əlavə olunub
- [ ] Məhsul detalında il aralığı `2012–2017` formatında göstərilir
- [ ] `brand_models` əvəzinə `fitments` istifadə olunur (marka adı da orada var)
- [ ] Qaraj (`user_car_id`) axtarışında nəticələrin azalması gözlənilir — bu normaldır
