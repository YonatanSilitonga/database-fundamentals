-- ============================================
-- 05-01: Tabel JELEK (Unnormalized)
-- ============================================
-- Ini contoh tabel yang BURUK — banyak masalah!

CREATE TABLE IF NOT EXISTS orders_bad (
    id INTEGER PRIMARY KEY,
    customer_name TEXT,
    customer_email TEXT,
    products TEXT,          -- ❌ nyimpen banyak produk dalam 1 kolom! (pake koma)
    quantities TEXT,        -- ❌ sama, nyimpen array pake koma
    total_price REAL,
    order_date TEXT
);

-- Insert data (lihat betapa jeleknya!)
INSERT INTO orders_bad VALUES (1, 'Yanto', 'yanto@email.com', 'Laptop,Mouse', '1,2', 16000, '2026-07-08');
INSERT INTO orders_bad VALUES (2, 'Yanto', 'yanto@email.com', 'Keyboard', '1', 1000, '2026-07-09');
INSERT INTO orders_bad VALUES (3, 'Budi', 'budi@email.com', 'Laptop,Headset', '1,1', 17000, '2026-07-10');

-- ============================================
// Masalah dengan tabel ini:
// ============================================
.print '=== Data Tabel JELEK ===';
SELECT * FROM orders_bad;

.print '';
.print '❌ MASALAH:';
.print '1. Kolom products isinya array dipisah koma — LANGAR 1NF';
.print '2. customer_name dan customer_email diulang-ulang (redundant)';
.print '3. Kalau Yanto ganti email, harus update di SEMUA baris';
.print '4. Sulit nyari produk tertentu (LIKE? bikin lambat)';
.print '5. Gak bisa JOIN dengan tabel lain';
.print '6. Harga produk gak terpisah — susah ngitung total';
