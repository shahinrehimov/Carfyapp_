# Carfy API — Multi-Seller Marketplace: Frontend Integration Guide

> **Version:** March 2026
> **Scope:** Complete documentation of all API changes resulting from the multi-seller marketplace refactor. Use this document alongside the Postman collection.

---

## Table of Contents

1. [Architecture Overview](#1-architecture-overview)
2. [Key Concepts](#2-key-concepts)
3. [Breaking Changes Summary](#3-breaking-changes-summary)
4. [Public / App Endpoints — Changes](#4-public--app-endpoints--changes)
   - [Product Variant List (Catalog)](#41-product-variant-list-catalog)
   - [Product Variant Detail Page](#42-product-variant-detail-page)
   - [Other Sellers Endpoint (NEW)](#43-other-sellers-endpoint-new)
   - [Basket Endpoints](#44-basket-endpoints)
   - [Wishlist Endpoints](#45-wishlist-endpoints)
   - [Orders](#46-orders)
5. [Seller Panel Endpoints](#5-seller-panel-endpoints)
   - [Company Product Variants — Seller Listings (NEW)](#51-company-product-variants--seller-listings-new)
   - [Product Variant Catalog Search (NEW)](#52-product-variant-catalog-search-new)
6. [Admin Panel Endpoints](#6-admin-panel-endpoints)
   - [Company Product Variant Approval (NEW)](#61-company-product-variant-approval-new)
7. [Response Structures (Full Reference)](#7-response-structures-full-reference)
8. [Workflow Diagrams](#8-workflow-diagrams)
9. [Field Reference](#9-field-reference)

---

## 1. Architecture Overview

### Before (Old System)
- Each seller created their own `ProductVariant` with price/stock/city
- Same physical product appeared multiple times in the catalog (duplicates)
- `ProductVariant` owned everything: price, stock, discount, city

### After (New System — Multi-Seller)
```
ProductVariant (canonical — one per product configuration)
  └── price: null         ← NO longer stores price
  └── stock: null         ← NO longer stores stock
  └── city_id: null       ← NO longer stores city
  └── oem_code            ← canonical, shared by all sellers
  └── images              ← canonical product images
  └── options             ← engine/year/etc.
  └── companyListings[]   ← seller-specific listings

CompanyProductVariant (seller listing — one per seller per variant)
  └── id / uuid
  └── company_id          ← which seller
  └── product_variant_id  ← which canonical variant
  └── price               ← seller's price (in dollars, e.g. 29.99)
  └── price_final         ← after discount (computed)
  └── stock               ← seller's stock
  └── discount / discount_type / discount_start_at / discount_end_at
  └── city_id             ← seller's city
  └── seller_images[]     ← seller's own additional images
  └── is_active
  └── approval_status     ← pending | approved | rejected
```

**Key rule: A product variant with no active approved seller listing will NOT appear in the catalog.**

---

## 2. Key Concepts

### CPV (CompanyProductVariant)
The seller-specific listing for a canonical `ProductVariant`. Each seller that sells a variant has their own CPV with their own price, stock, discount and city.

### Price Override
When the API returns a `ProductVariant` to the public site, the `price`, `price_final`, `stock`, `discount`, `discount_type` etc. at the **top level** of the response already reflect the **seller's data** (cheapest available seller, or the seller specified by `seller` query param). The raw canonical PV has no price.

### in_wishlist / in_basket
These are now **CPV-level** flags. They indicate whether the specific seller's listing (CPV) is in the wishlist/basket — NOT just the product variant generically. Two different sellers' listings of the same variant count as separate items.

### Seller UUID
When adding to basket/wishlist, you must pass the **CPV's UUID** (not the ProductVariant's UUID). The `seller.uuid` field in variant responses provides this.

---

## 3. Breaking Changes Summary

| Area | What Changed | Action Required |
|------|-------------|-----------------|
| Basket add/remove/increment/decrement | URL param changed from `{productVariant}` to `{companyProductVariant}` | Update all basket URLs to use CPV UUID |
| Wishlist add/remove | URL param changed from `{productVariant}` to `{companyProductVariant}` | Update all wishlist URLs to use CPV UUID |
| Product list response | New `seller` object added; `in_wishlist`/`in_basket` now CPV-level | Use `seller.uuid` for basket/wishlist actions |
| Product detail response | New `seller` object, `other_sellers` array, `sellers_count` | Display seller info; use `seller.uuid` for actions |
| Order items response | New `seller` field in each order item | Display which seller the item was from |
| Basket item response | New `seller` object with city and images | Display seller details in basket |

---

## 4. Public / App Endpoints — Changes

### 4.1 Product Variant List (Catalog)

**Endpoint:** `GET /products/load` (no change)

**Query Params:** (unchanged)
- `page`, `limit`, `search`, `category_id`, `brand_model_id`, `year`, `sort`, `sort_type`, `price_min`, `price_max`, `city_id`

**What Changed in Response:**
- `price`, `price_final`, `stock`, `discount` etc. now reflect the **cheapest approved seller listing**
- New `seller` object added to each item (the cheapest seller's CPV data)
- New `sellers_count` field (total approved active sellers for this variant)
- `in_wishlist` / `in_basket` are now CPV-level (based on the `seller.uuid` of the cheapest listing)

**Response Item (changed fields):**
```json
{
  "id": 1,
  "uuid": "pv-uuid-here",
  "slug": "product-slug",
  "oem_code": "OEM-12345",
  "title": "Product Title",
  "hover_image": "https://...",
  "is_set": false,
  "stock": 15,
  "price": 29.99,
  "price_final": 24.99,
  "has_discount": true,
  "discount_type": "by_percentage",
  "discount_type_title": "By Percentage",
  "discount": 17,
  "in_wishlist": false,
  "in_basket": false,
  "basket_quantity": null,

  "seller": {
    "id": 3,
    "uuid": "cpv-uuid-here",
    "city": {
      "id": 1,
      "title": "Baku"
    }
  },
  "sellers_count": 3,

  "product": { ... }
}
```

> **Important:** To add this item to basket or wishlist, use `seller.uuid` (the CPV UUID), not the variant's `uuid`.

---

### 4.2 Product Variant Detail Page

**Endpoint:** `GET /products/show/{parentCategorySlug}/{subCategorySlug}/{productSlug}` (no change)

**New Query Params:**
| Param | Type | Description |
|-------|------|-------------|
| `seller` | string (UUID) | Optional. Load a specific seller's listing (CPV UUID). If omitted, loads the cheapest available seller. |
| `other_sellers` | boolean | Optional. If `true`, includes `other_sellers` array in response. |

**Response (changed/new fields):**

```json
{
  "id": 1,
  "uuid": "pv-uuid",
  "slug": "product-slug",
  "oem_code": "OEM-12345",
  "title": "Product Title",
  "main_image": "https://...",
  "hover_image": "https://...",
  "images": ["https://...", "https://..."],
  "is_set": false,
  "sets": [],
  "brand_model": { "id": 1, "title": "Toyota Camry" },
  "product": { ... },
  "year": "2020",

  "stock": 15,
  "price": 29.99,
  "price_final": 24.99,
  "has_discount": true,
  "discount_type": "by_percentage",
  "discount_type_title": "By Percentage",
  "discount": 17,

  "in_wishlist": true,
  "in_basket": false,

  "options": [ ... ],
  "ratings": { ... },
  "related_products": [ ... ],

  "seller": {
    "id": 3,
    "uuid": "cpv-uuid-here",
    "city": {
      "id": 1,
      "title": "Baku"
    },
    "images": [
      { "id": 10, "url": "https://..." }
    ]
  },
  "sellers_count": 3,

  "other_sellers": [
    {
      "uuid": "other-cpv-uuid",
      "price": 32.00,
      "price_final": 32.00,
      "stock": 5,
      "has_discount": false,
      "city": { "id": 2, "title": "Ganja" }
    }
  ],
  "other_sellers_total": 2
}
```

**Notes:**
- `price`, `price_final`, `stock`, `discount*` at the top level = the selected seller's values
- `seller.uuid` = the CPV UUID to use for basket/wishlist actions
- `seller.images` = seller's own uploaded images (in addition to canonical `images` at top level)
- `other_sellers` only present if `?other_sellers=true` is passed
- `other_sellers_total` = count of other sellers (excluding the currently shown one)

---

### 4.3 Other Sellers Endpoint (NEW)

**Endpoint:** `GET /products/{productVariant}/other-sellers`

> `{productVariant}` = ProductVariant ID or UUID

**Query Params:**
| Param | Type | Description |
|-------|------|-------------|
| `exclude_seller` | string (UUID) | CPV UUID to exclude from results (e.g., the currently shown seller) |
| `limit` | integer | Pagination limit |
| `page` | integer | Page number |

**Response:** Paginated list of CPVs (other sellers)
```json
{
  "data": [
    {
      "uuid": "cpv-uuid",
      "price": 32.00,
      "price_final": 30.00,
      "stock": 5,
      "has_discount": true,
      "city": { "id": 2, "title": "Ganja" }
    }
  ],
  "meta": { "current_page": 1, "total": 2, ... }
}
```

---

### 4.4 Basket Endpoints

> **BREAKING CHANGE:** All basket URLs now use `{companyProductVariant}` (CPV UUID) instead of `{productVariant}`.

**Base URL:** `/basket`

| Method | Endpoint | Old | New |
|--------|----------|-----|-----|
| POST | Add to basket | `/basket/add/{productVariantUuid}` | `/basket/add/{cpvUuid}` |
| POST | Remove from basket | `/basket/remove/{productVariantUuid}` | `/basket/remove/{cpvUuid}` |
| POST | Increment quantity | `/basket/increment/{productVariantUuid}` | `/basket/increment/{cpvUuid}` |
| POST | Decrement quantity | `/basket/decrement/{productVariantUuid}` | `/basket/decrement/{cpvUuid}` |
| POST | Remove set item | `/basket/remove/{productVariantUuid}/set/{setItem}` | `/basket/remove/{cpvUuid}/set/{setItem}` |
| POST | Increment set item | `/basket/increment/{productVariantUuid}/set/{setItem}` | `/basket/increment/{cpvUuid}/set/{setItem}` |
| POST | Decrement set item | `/basket/decrement/{productVariantUuid}/set/{setItem}` | `/basket/decrement/{cpvUuid}/set/{setItem}` |
| GET | Load basket | `/basket/load` | `/basket/load` (unchanged) |

**Where to get CPV UUID:** Use `seller.uuid` from any product variant response.

**Add to Basket Request Body:**
```json
{
  "quantity": 2
}
```

**Basket Load Response — item (changed fields):**
```json
{
  "id": 1,
  "uuid": "pv-uuid",
  "slug": "product-slug",
  "oem_code": "OEM-12345",
  "title": "Product Title",
  "hover_image": "https://...",
  "is_set": false,
  "stock": 15,
  "price": 29.99,
  "price_final": 24.99,
  "has_discount": true,
  "discount_type": "by_percentage",
  "discount": 17,
  "in_wishlist": false,
  "in_basket": true,
  "basket_quantity": 2,
  "price_in_basket": 59.98,
  "price_final_in_basket": 49.98,

  "seller": {
    "id": 3,
    "uuid": "cpv-uuid-here",
    "city": {
      "id": 1,
      "title": "Baku"
    },
    "images": [
      { "id": 10, "url": "https://..." }
    ]
  },

  "product": { ... },
  "sets": [ ... ]
}
```

**Stock validation:** If you try to add/increment beyond available stock, you'll receive a `400 Bad Request` error.

---

### 4.5 Wishlist Endpoints

> **BREAKING CHANGE:** All wishlist URLs now use `{companyProductVariant}` (CPV UUID) instead of `{productVariant}`.

**Base URL:** `/wishlist`

| Method | Endpoint | Old | New |
|--------|----------|-----|-----|
| POST | Add to wishlist | `/wishlist/add/{productVariantUuid}` | `/wishlist/add/{cpvUuid}` |
| POST | Remove from wishlist | `/wishlist/remove/{productVariantUuid}` | `/wishlist/remove/{cpvUuid}` |
| GET | Load wishlist | `/wishlist/load` | `/wishlist/load` (unchanged) |

**Wishlist is seller-specific:** Adding the same product from two different sellers creates two separate wishlist entries.

**Wishlist Load Response:** Same structure as basket load but without quantity/price_in_basket fields.

---

### 4.6 Orders

**Checkout:** `POST /orders/checkout` — unchanged endpoint, but internally validates stock per seller and decrements atomically.

**Order Item Response (changed — `seller` field added):**
```json
{
  "id": 1,
  "product_variant": { ... },
  "quantity": 2,
  "price": 29.99,
  "price_final": 24.99,
  "total": 49.98,

  "seller": {
    "id": 3,
    "uuid": "cpv-uuid",
    "city": {
      "id": 1,
      "title": "Baku"
    }
  }
}
```

---

## 5. Seller Panel Endpoints

**Base URL prefix:** `/sellers`
**Authentication:** Bearer token (company admin)

### 5.1 Company Product Variants — Seller Listings (NEW)

**Base URL:** `/sellers/company-product-variants`

#### Load Seller's Listings

```
GET /sellers/company-product-variants/load
```

**Query Params:**
| Param | Type | Description |
|-------|------|-------------|
| `limit` | integer (5–100) | Items per page |
| `page` | integer | Page |
| `search` | string | Search by OEM code or product title |
| `product_id` | integer | Filter by product |
| `approval_status` | string | Filter: `pending`, `approved`, `rejected` |

**Response:** Paginated list of `CompanyProductVariantListResource`
```json
{
  "data": [
    {
      "id": 1,
      "uuid": "cpv-uuid",
      "variant": {
        "id": 10,
        "uuid": "pv-uuid",
        "slug": "product-slug",
        "oem_code": "OEM-12345",
        "title": "Product Title",
        "main_image": "https://...",
        "hover_image": "https://...",
        "is_set": false,
        "brand_model": { "id": 1, "title": "Toyota Camry" },
        "year": "2020",
        "product": { "id": 5, "title": "Brake Pad", ... }
      },
      "stock": 15,
      "price": 29.99,
      "price_final": 24.99,
      "discount_type": "by_percentage",
      "discount_type_title": "By Percentage",
      "discount": 17,
      "city": { "id": 1, "title": "Baku" },
      "is_active": true,
      "approval_status": "approved",
      "approval_status_label": "Approved",
      "approval_status_message": null,
      "seller_images": [
        { "id": 10, "url": "https://..." }
      ],
      "created_date": "2026-03-11 10:00:00"
    }
  ],
  "meta": { ... }
}
```

---

#### Show Single Listing

```
GET /sellers/company-product-variants/show/{companyProductVariant}
```

**Response:** Full `CompanyProductVariantResource`
```json
{
  "id": 1,
  "uuid": "cpv-uuid",
  "variant": {
    "id": 10,
    "uuid": "pv-uuid",
    "slug": "product-slug",
    "oem_code": "OEM-12345",
    "main_image": "https://...",
    "hover_image": "https://...",
    "images": { "urls": ["https://..."] },
    "is_set": false,
    "sets": [],
    "groups": [],
    "options": [
      {
        "id": 1,
        "option": { "id": 1, "title": "Engine Type" },
        "item": { "id": 3, "title": "2.0L" }
      }
    ],
    "brand_model": { "id": 1, "title": "Toyota Camry" },
    "year": "2020",
    "product": { ... }
  },
  "stock": 15,
  "price": 29.99,
  "price_final": 24.99,
  "discount_type": "by_percentage",
  "discount_type_title": "By Percentage",
  "discount": 17,
  "discount_start_at": "2026-03-01 00:00:00",
  "discount_end_at": "2026-04-01 00:00:00",
  "city": { "id": 1, "title": "Baku" },
  "is_active": true,
  "approval_status": "approved",
  "approval_status_label": "Approved",
  "approval_status_message": null,
  "seller_images": [
    { "id": 10, "url": "https://..." }
  ],
  "company": {
    "id": 2,
    "uuid": "company-uuid",
    "title": "My Store"
  },
  "created_date": "2026-03-11 10:00:00"
}
```

---

#### Attach (Create Listing for an Existing Variant)

```
POST /sellers/company-product-variants/attach/{productVariant}
```

> `{productVariant}` = canonical ProductVariant ID or UUID

**Request Body (multipart/form-data):**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `price` | decimal | **Yes** | Selling price in dollars (e.g., `29.99`) |
| `stock` | integer | No | Available stock (default: 0) |
| `has_discount` | boolean | **Yes** | `true` or `false` |
| `discount` | decimal | Required if `has_discount=true` | Discount value |
| `discount_type` | string | Required if `has_discount=true` | `by_percentage` or `by_amount` |
| `discount_start_at` | datetime | No | ISO date string |
| `discount_end_at` | datetime | No | ISO date string (must be >= start) |
| `city_id` | integer | No | City ID |
| `images[]` | file (image) | No | Seller-specific images (max 10MB each) |

**Response:** `CompanyProductVariantResource`

**Notes:**
- Creates a new CPV with `approval_status = pending`
- Each seller can only have ONE listing per variant (duplicate attach returns 400)
- When a seller creates a brand-new ProductVariant via the seller panel, a CPV is automatically created

---

#### Update Listing

```
POST /sellers/company-product-variants/update/{companyProductVariant}
```

**Request Body (same fields as Attach, all optional):**
- `price`, `stock`, `has_discount`, `discount`, `discount_type`, `discount_start_at`, `discount_end_at`, `city_id`

**Response:** `CompanyProductVariantResource`

---

#### Detach (Delete Listing)

```
DELETE /sellers/company-product-variants/detach/{companyProductVariant}
```

**Response:** `204 No Content`

---

#### Change Active Status

```
POST /sellers/company-product-variants/change-active-status/{companyProductVariant}
```

**Response:** `204 No Content` (toggles `is_active`)

---

#### Add Images

```
POST /sellers/company-product-variants/images/add/{companyProductVariant}
```

**Request Body (multipart/form-data):**
| Field | Type | Required |
|-------|------|----------|
| `images[]` | file (image, max 10MB) | Yes |

**Response:** `204 No Content`

---

#### Delete Image

```
DELETE /sellers/company-product-variants/images/delete/{companyProductVariant}/{mediaId}
```

**Response:** `204 No Content`

---

#### Approval Status History

```
GET /sellers/company-product-variants/{companyProductVariant}/approval-status/history
```

**Response:** Paginated list of approval status history entries
```json
{
  "data": [
    {
      "id": 1,
      "approval_status": "pending",
      "approval_status_message": null,
      "created_at": "2026-03-11 10:00:00",
      "creatable": { ... }
    }
  ]
}
```

---

#### Resend for Approval

```
POST /sellers/company-product-variants/{companyProductVariant}/approval-status/resend
```

> Only works if current `approval_status = "rejected"`

**Response:** `204 No Content`

---

### 5.2 Product Variant Catalog Search (NEW)

Search across ALL canonical product variants (not just the seller's own).

```
GET /sellers/product-variants/search-catalog
```

**Query Params:**
| Param | Type | Description |
|-------|------|-------------|
| `search` | string | Search by OEM code, product title, brand model |
| `limit` | integer | Pagination limit |
| `page` | integer | Page |

**Use Case:** Before attaching a listing, the seller searches the catalog to find an existing variant to attach to.

---

## 6. Admin Panel Endpoints

**Base URL prefix:** `/control`

### 6.1 Company Product Variant Approval (NEW)

#### Load All Seller Listings

```
GET /control/company-product-variants/load
```

**Query Params:**
| Param | Type | Description |
|-------|------|-------------|
| `limit` | integer | Items per page |
| `page` | integer | Page |
| `search` | string | Search by OEM code or product title |
| `company_id` | integer | Filter by company |
| `approval_status` | string | Filter: `pending`, `approved`, `rejected` |

**Response:** Paginated `CompanyProductVariantListResource` with additional `company` and `creatable` fields.

---

#### Approval Status History

```
GET /control/company-product-variants/{companyProductVariant}/approval-status/history
```

**Response:** Same as seller history endpoint.

---

#### Approve Listing

```
POST /control/company-product-variants/{companyProductVariant}/approval-status/approve
```

**Response:** `204 No Content`

**Notes:**
- Returns `400` if already `approved`
- Changes `approval_status` to `approved`

---

#### Reject Listing

```
POST /control/company-product-variants/{companyProductVariant}/approval-status/reject
```

**Request Body:**
```json
{
  "approval_status_message": "Images are unclear. Please reupload."
}
```

**Response:** `204 No Content`

**Notes:**
- Returns `400` if already `rejected`
- Changes `approval_status` to `rejected`

---

## 7. Response Structures (Full Reference)

### Approval Status Values

| Value | Description |
|-------|-------------|
| `pending` | Awaiting admin review |
| `approved` | Visible in catalog |
| `rejected` | Not visible; seller can resend |

### Discount Type Values

| Value | Description |
|-------|-------------|
| `by_percentage` | `discount` is a percentage (e.g., `17` = 17%) |
| `by_amount` | `discount` is a fixed dollar amount (e.g., `5.00` = $5 off) |

### Price Fields Explanation

| Field | Description |
|-------|-------------|
| `price` | Base price in dollars (e.g., `29.99`) |
| `price_final` | Final price after discount, respecting date range (e.g., `24.99`) |
| `has_discount` | `true` if `price != price_final` |
| `price_in_basket` | `price × basket_quantity` |
| `price_final_in_basket` | `price_final × basket_quantity` |

---

## 8. Workflow Diagrams

### Seller Adds a Listing

```
1. Seller searches catalog:
   GET /sellers/product-variants/search-catalog?search=OEM-12345

2. Seller finds the variant and attaches:
   POST /sellers/company-product-variants/attach/{productVariantId}
   Body: { price, stock, has_discount, discount, discount_type, city_id, images[] }

3. Listing created with approval_status = "pending"

4. Admin reviews and approves:
   POST /control/company-product-variants/{cpvId}/approval-status/approve

5. Listing is now visible in catalog with approval_status = "approved"
```

### Buyer Adds to Basket

```
1. Load product list → receive variants with seller.uuid
   GET /products/load

2. User clicks "Add to Basket":
   POST /basket/add/{seller.uuid}
   Body: { quantity: 1 }

3. Load basket → variant appears with seller info
   GET /basket/load
```

### Buyer Views Product Detail with Seller Choice

```
1. Load product detail (cheapest seller):
   GET /products/show/category/sub-category/product-slug
   → Response includes seller.uuid (cheapest available seller)

2. Load other sellers (optional):
   GET /products/{productVariantId}/other-sellers

3. User picks a specific seller:
   GET /products/show/category/sub-category/product-slug?seller={cpv-uuid}
   → Response includes that seller's price/stock/city/images

4. User adds the selected seller's listing to basket:
   POST /basket/add/{seller.uuid}
```

### Seller Listing Lifecycle

```
created (pending) → admin approves → approved (visible in catalog)
                  ↘ admin rejects → rejected → seller resends → pending → ...
```

---

## 9. Field Reference

### CompanyProductVariant (CPV) — Common Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Internal numeric ID |
| `uuid` | string | UUID (use this for public-facing operations) |
| `stock` | integer | Available units |
| `price` | float | Base price in dollars |
| `price_final` | float | Discounted price (equals `price` if no active discount) |
| `has_discount` | boolean | Whether discount is currently active |
| `discount` | float/integer | Discount value (% or $, see `discount_type`) |
| `discount_type` | string\|null | `by_percentage` or `by_amount` |
| `discount_type_title` | string\|null | Translated label |
| `discount_start_at` | datetime\|null | When discount becomes active |
| `discount_end_at` | datetime\|null | When discount expires |
| `city` | object\|null | `{ id, title }` |
| `is_active` | boolean | Seller toggled active/inactive |
| `approval_status` | string | `pending`, `approved`, `rejected` |
| `approval_status_label` | string | Translated label |
| `approval_status_message` | string\|null | Rejection reason from admin |
| `seller_images` | array | Seller-uploaded images `[{ id, url }]` |
| `created_date` | datetime | When the listing was created |

### ProductVariant — Fields That Now Reflect Seller Data (Public Site)

When the public API returns a `ProductVariant`, these fields are **overridden with the selected seller's CPV values**:

- `price`
- `price_final`
- `stock`
- `discount`
- `discount_type`
- `has_discount`

The canonical PV itself stores no price/stock. The override happens server-side transparently.

---

## Postman Collection

The Postman collection (`postman/Carfy.postman_collection.json`) has been updated with:

- **App > Basket** — all URLs updated to use `companyProductVariant` UUID
- **App > Wishlist** — all URLs updated to use `companyProductVariant` UUID
- **App > Products** — updated to include `seller` param and `other-sellers` endpoint
- **Sellers > Company Product Variants** — new folder with all CPV endpoints
- **Sellers > Product Variants** — added `search-catalog` endpoint
- **Admin > Company Product Variants** — new folder with load/approve/reject

---

*Last updated: March 2026*
