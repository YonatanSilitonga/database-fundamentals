-- ============================================
-- 05-02: Perbaikan ke 1NF
-- ============================================
-- Aturan 1NF: setiap kolom berisi 1 nilai (gak boleh array)

-- Bikin tabel baru yang 1NF
CREATE TABLE IF NOT EXISTS orders_1nf (
    id INTEGER,
    customer_name TEXT,
    customer_email TEXT,
    product TEXT,            -- ✅ 1 baris = 1 produk
    quantity INTEGER,
    price_per_item REAL,
    order_date TEXT,
    PRIMARY KEY (id, product)
);

-- Insert data — setiap produk jadi baris TERPISAH
INSERT INTO orders_1nf VALUES (1, 'Yanto', 'yanto@email.com', 'Laptop', 1, 15000, '2026-07-08');
INSERT INTO orders_1nf VALUES (1, 'Yanto', 'yanto@email.com', 'Mouse', 2, 500, '2026-07-08');
INSERT INTO orders_1nf VALUES (2, 'Yanto', 'yanto@email.com', 'Keyboard', 1, 1000, '2026-07-09');
INSERT INTO orders_1nf VALUES (3, 'Budi', 'budi@email.com', 'Laptop', 1, 15000, '2026-07-10');
INSERT INTO orders_1nf VALUES (3, 'Budi', 'budi@email.com', 'Headset', 1, 2000, '2026-07-10');

.print '=== Data setelah 1NF ===';
SELECT * FROM orders_1nf;

.print '';
.print '✅ 1NF terpenuhi: Setiap kolom berisi 1 nilai.';
.print '❌ TAPI masih ada masalah:';
.print '   - customer_name dan email diulang-ulang (redundant)';
.print '   - price_per_item tergantung produk, bukan order';
.print '   - Kalau ganti Yanto → Yanto Baru, harus update banyak baris';
