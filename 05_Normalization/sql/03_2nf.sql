-- ============================================
-- 05-03: Perbaikan ke 2NF
-- ============================================
-- Aturan 2NF: udah 1NF + kolom NON-key harus bergantung penuh ke PRIMARY KEY

-- Solusi: pisahin data customer ke tabel terpisah
-- Karena customer_name dan email bergantung ke customer_id, bukan ke order

-- Tabel customers
CREATE TABLE IF NOT EXISTS customers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);

INSERT INTO customers VALUES (1, 'Yanto', 'yanto@email.com');
INSERT INTO customers VALUES (2, 'Budi', 'budi@email.com');

-- Tabel orders (sekarang pake customer_id, bukan name/email)
CREATE TABLE IF NOT EXISTS orders_2nf (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    order_date TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

INSERT INTO orders_2nf (customer_id, order_date) VALUES (1, '2026-07-08');
INSERT INTO orders_2nf (customer_id, order_date) VALUES (1, '2026-07-09');
INSERT INTO orders_2nf (customer_id, order_date) VALUES (2, '2026-07-10');

-- Tabel order_items (nyambungin order ke produk)
CREATE TABLE IF NOT EXISTS order_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    product TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    price_per_item REAL NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders_2nf(id)
);

INSERT INTO order_items (order_id, product, quantity, price_per_item) VALUES (1, 'Laptop', 1, 15000);
INSERT INTO order_items (order_id, product, quantity, price_per_item) VALUES (1, 'Mouse', 2, 500);
INSERT INTO order_items (order_id, product, quantity, price_per_item) VALUES (2, 'Keyboard', 1, 1000);
INSERT INTO order_items (order_id, product, quantity, price_per_item) VALUES (3, 'Laptop', 1, 15000);
INSERT INTO order_items (order_id, product, quantity, price_per_item) VALUES (3, 'Headset', 1, 2000);

.print '=== Data setelah 2NF ===';
.print '--- Customers ---';
SELECT * FROM customers;

.print '--- Orders ---';
SELECT * FROM orders_2nf;

.print '--- Order Items ---';
SELECT * FROM order_items;

-- JOIN semua tabel
.print '--- Full Order Detail ---';
SELECT 
    o.id AS order_id,
    c.name AS customer,
    oi.product,
    oi.quantity,
    oi.price_per_item,
    oi.quantity * oi.price_per_item AS subtotal
FROM orders_2nf o
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN order_items oi ON oi.order_id = o.id;

.print '';
.print '✅ 2NF terpenuhi:';
.print '   - Data customer terpisah (gak redundant)';
.print '   - Ganti nama/email customer cukup di 1 tempat';
.print '❌ TAPI masih ada: price_per_item diulang (Laptop 15000 di 2 baris)';
.print '   — ini masalah 3NF';
