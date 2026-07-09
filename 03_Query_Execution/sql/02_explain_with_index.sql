-- ============================================
-- 03-02: EXPLAIN — Sebelum & Sesudah Index
-- ============================================

.timer ON

-- Bikin tabel besar
CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_name TEXT,
    total REAL,
    status TEXT
);

-- Insert 5000 baris
INSERT INTO orders (customer_name, total, status)
SELECT 
    'Customer ' || value,
    ROUND(RANDOM() * 1000000, 2),
    CASE WHEN value % 3 = 0 THEN 'pending'
         WHEN value % 3 = 1 THEN 'shipped'
         ELSE 'delivered' END
FROM generate_series(1, 5000);

-- ============================================
// SEBELUM INDEX
-- ============================================
.print '\n=== SEBELUM INDEX: Cari customer_name ===';
EXPLAIN QUERY PLAN SELECT * FROM orders WHERE customer_name = 'Customer 2500';

-- Jalanin query (catet waktunya)
SELECT * FROM orders WHERE customer_name = 'Customer 2500';

-- ============================================
// SESUDAH INDEX
-- ============================================
.print '\n=== BIKIN INDEX di customer_name ===';
CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders(customer_name);

.print '\n=== SESUDAH INDEX: Cari customer_name ===';
EXPLAIN QUERY PLAN SELECT * FROM orders WHERE customer_name = 'Customer 2500';

-- Jalanin query yang sama (liat beda waktu)
SELECT * FROM orders WHERE customer_name = 'Customer 2500';

-- Perhatiin:
-- SEBELUM: SCAN (sequential scan — lambat)
-- SESUDAH: SEARCH (index scan — cepet)
