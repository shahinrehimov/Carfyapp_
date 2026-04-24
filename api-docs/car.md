# User Cars — App / Site API

Base URL: `{{url}}/{provider}/profile/cars`

- `{provider}` — `site` (veb sayt) və ya `app` (mobil)
- Auth: Bearer `{{login_token_site}}` + Header `Token: {{app_site_token}}`
- Bütün endpoint-lər **authentication tələb edir** (`auth:user`)

---

## Endpoints

### Load — maşın siyahısı
```
GET /{provider}/profile/cars/load
```

Query params: `limit` (default: 10)

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "photo": "https://...",
      "brand": { "id": 1, "title": "Audi" },
      "brand_model": { "id": 3, "title": "R8" },
      "car_type": { "id": 2, "title": "Kupe" },
      "engine_volume": {
        "id": 1,
        "title": "3.2L (3,200 sm³)",
        "value_liters": "3.2",
        "value_cc": 3200
      },
      "fuel_type": { "id": 1, "title": "Premium benzin" },
      "transmission_type": { "id": 2, "title": "Avtomatik" },
      "year": 2022,
      "engine_number": "ABC1234567",
      "vin_number": "WF0AXXWPMARZ34516",
      "created_at": "2026-03-14 10:00:00"
    }
  ],
  "meta": { "current_page": 1, "last_page": 1, "total": 1 }
}
```

> `engine_volume`, `fuel_type`, `transmission_type` optional — seçilməyibsə `null` qaytarır.

---

### Show — tək maşın
```
GET /{provider}/profile/cars/show/{id}
```

**Response:** eyni struktur (tək object).

> Başqa userin maşınına müraciət `403 Forbidden` qaytarır.

---

### Add — maşın əlavə et
```
POST /{provider}/profile/cars/add
Content-Type: multipart/form-data
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `brand_model_id` | integer | **Yes** | BrandModel ID |
| `car_type_id` | integer | **Yes** | CarType ID |
| `year` | integer | **Yes** | İstehsal ili (1900 – cari il+1) |
| `engine_volume_id` | integer | No | EngineVolume ID |
| `fuel_type_id` | integer | No | FuelType ID |
| `transmission_type_id` | integer | No | TransmissionType ID |
| `engine_number` | string | No | Mühərrik nömrəsi (max 100) |
| `vin_number` | string | No | VIN / Şəssi nömrəsi (max 100) |
| `photo` | file (image) | No | Avtomobil şəkli (max 10MB) |

**Response:**
```json
{
  "data": {
    "message": "Car added successfully!",
    "data": { ...UserCarResource }
  }
}
```

---

### Update — maşın yenilə
```
POST /{provider}/profile/cars/update/{id}
Content-Type: multipart/form-data
```

Eyni sahələr Add ilə. Yeni şəkil göndərildikdə köhnə avtomatik silinir.

> Başqa userin maşınını yeniləmək `403 Forbidden` qaytarır.

---

### Delete — maşın sil
```
DELETE /{provider}/profile/cars/delete/{id}
```

**Response:**
```json
{
  "data": {
    "message": "Car deleted successfully!"
  }
}
```

---

### Delete Photo — şəkil sil
```
DELETE /{provider}/profile/cars/delete-photo/{id}
```

**Response:**
```json
{
  "data": {
    "message": "Photo deleted successfully!"
  }
}
```

---

## Dropdown məlumatları — Car Libraries

Bütün endpointlər **public**-dir (auth tələb etmir). Base prefix: `/{provider}/car-libraries/`

### Brands — marka siyahısı
```
GET /{provider}/car-libraries/brands
GET /{provider}/car-libraries/brands?with_models=yes
```

`with_models=yes` göndərildikdə hər brandin modelləri də daxildir:
```json
{
  "data": [
    {
      "id": 1,
      "uuid": "abc-123",
      "slug": "audi",
      "title": "Audi",
      "image": "https://...",
      "brand_models": [
        { "id": 3, "title": "R8" },
        { "id": 4, "title": "A4" }
      ]
    }
  ]
}
```

`with_models` olmadan `brand_models` qaytarılmır.

### Brand Models — model siyahısı (brand üzrə)
```
GET /{provider}/car-libraries/brands/{brandId}/models
```

```json
{
  "data": [
    { "id": 3, "title": "R8" },
    { "id": 4, "title": "A4" }
  ]
}
```

### Yanacaq növü
```
GET /{provider}/car-libraries/fuel-types
```
```json
{ "data": [ { "id": 1, "title": "Premium benzin" } ] }
```

### Ötürücü qutusu
```
GET /{provider}/car-libraries/transmission-types
```
```json
{ "data": [ { "id": 2, "title": "Avtomatik" } ] }
```

### Avtomobil tipi
```
GET /{provider}/car-libraries/car-types
```
```json
{ "data": [ { "id": 2, "title": "Kupe" } ] }
```

### Mühərrik həcmi
```
GET /{provider}/car-libraries/engine-volumes
```
```json
{ "data": [ { "id": 1, "title": "2.0L (1,998 sm³)", "value_liters": "2.0", "value_cc": 1998 } ] }
```

> **Product filters** (`GET /{provider}/products/filters`) endpointindəki `brands` sahəsi də artıq modellər daxil olmaqla qaytarır.

---

## Qeydlər

- `user_id` avtomatik — auth tokenindən götürülür, göndərilməsin.
- `brand_model_id` göndərildikdə frontend həm marka, həm model seçimini idarə edir (önce brand seçilir → həmin brandın modelləri yüklənir).
- Şəkil `user_car_photos` media kolleksiyasında saxlanır, `single file` rejimindədir.
- Filter üçün `engine_volume_id` istifadə edilir (string yox, FK). Axtarış zamanı `value_liters` / `value_cc` üzrə range filter tətbiq edilə bilər.
