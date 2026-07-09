# 05 — Normalization

---

## Apa Itu Normalization?

Normalization = **proses mendesain tabel** biar data gak redundant (ganda), gak inkonsisten, dan gampang dipelihara.

Bayangin lo punya data pesanan kayak gini:

| id | customer | product | category | price |
|---|---|---|---|---|
| 1 | Yanto | Laptop | Elektronik | 15000 |
| 2 | Yanto | Mouse | Aksesoris | 500 |
| 3 | Budi | Laptop | Elektronik | 15000 |

**Masalah:**
- Nama "Elektronik" ditulis berulang-ulang (redundant)
- Kalau ganti harga Laptop, harus ganti di SEMUA baris
- Kalau salah nulis "Elektronic" di satu baris, data jadi inkonsisten

Normalisasi nyelesain masalah ini dengan **memecah tabel besar** jadi **tabel-tabel kecil** yang saling berelasi.

---

## 1NF (First Normal Form)

**Aturan:** Setiap kolom harus berisi **1 nilai** (atomic), gak boleh ada array/list.

❌ **Salah:**
| id | customer | products |
|---|---|---|
| 1 | Yanto | Laptop, Mouse |

✅ **Bener:**
| id | customer | product |
|---|---|---|
| 1 | Yanto | Laptop |
| 2 | Yanto | Mouse |

---

## 2NF (Second Normal Form)

**Aturan:** Udah 1NF + **Semua kolom NON-key harus bergantung penuh ke PRIMARY KEY** (bukan cuma sebagian).

❌ **Salah:**
| order_id | product_id | customer_name | product_name |
|---|---|---|---|
| 1 | 101 | Yanto | Laptop |

`customer_name` cuma bergantung ke `order_id`, tapi `product_name` cuma bergantung ke `product_id`. Harusnya dipisah.

✅ **Bener:**
- Tabel `orders`: order_id, customer_name
- Tabel `order_items`: order_id, product_id
- Tabel `products`: product_id, product_name

---

## 3NF (Third Normal Form)

**Aturan:** Udah 2NF + **Kolom NON-key gak boleh bergantung ke kolom NON-key lain**.

❌ **Salah:**
| id | product | category_id | category_name |
|---|---|---|---|
| 1 | Laptop | 1 | Elektronik |

`category_name` bergantung ke `category_id` (bukan ke `id`). Kalau ganti category_name, harus ganti di banyak baris.

✅ **Bener:**
- Tabel `products`: id, product, category_id
- Tabel `categories`: id, category_name

---

## Relationships

| Jenis | Contoh |
|---|---|
| **One-to-One** | 1 user punya 1 profil (users → profiles) |
| **One-to-Many** | 1 user punya banyak posts (users → posts) |
| **Many-to-Many** | 1 post punya banyak tags, 1 tag dipake banyak posts (posts ↔ tags) |

---

## Apa yang Akan Lo Praktekkan:

1. Bikin tabel jelek (unnormalized)
2. Perbaiki step-by-step: 1NF → 2NF → 3NF
3. Bikin relasi antar tabel
4. Bandingin: sebelum vs sesudah normalisasi
