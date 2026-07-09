-- ============================================
-- 05-04: Perbaikan ke 3NF
-- ============================================
-- Aturan 3NF: udah 2NF + kolom NON-key gak boleh bergantung ke kolom NON-key lain

-- Masalah di 2NF: price_per_item bergantung ke product, bukan ke order
-- Solusi: pisahin produk ke tabel terpisah

-- Tabel products
CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    price REAL NOT NULL,
    category TEXT
);

INSERT INTO products VALUES (1, 'Laptop', 15000, 'Elektronik');
INSERT INTO products VALUES (2, 'Mouse', 500, 'Aksesoris');
INSERT INTO products VALUES (3, 'Keyboard', 1000, 'Aksesoris');
INSERT INTO products VALUES (4, 'Headset', 2000, 'Aksesoris');

-- Tabel orders_3nf (sama kayak 2nf)
CREATE TABLE IF NOT EXISTS orders_3nf (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    order_date TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

INSERT INTO orders_3nf (customer_id, order_date) VALUES (1, '2026-07-08');
INSERT INTO orders_3nf (customer_id, order_date) VALUES (1, '2026-07-09');
INSERT INTO orders_3nf (customer_id, order_date) VALUES (2, '2026-07-10');

-- Tabel order_items_3nf (pake product_id, bukan nama produk)
CREATE TABLE IF NOT EXISTS order_items_3nf (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders_3nf(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO order_items_3nf (order_id, product_id, quantity) VALUES (1, 1, 1);  -- Laptop
INSERT INTO order_items_3nf (order_id, product_id, quantity) VALUES (1, 2, 2);  -- Mouse
INSERT INTO order_items_3nf (order_id, product_id, quantity) VALUES (2, 3, 1);  -- Keyboard
INSERT INTO order_items_3nf (order_id, product_id, quantity) VALUES (3, 1, 1);  -- Laptop
INSERT INTO order_items_3nf (order_id, product_id, quantity) VALUES (3, 4, 1);  -- Headset

-- Sekarang JOIN 4 tabel
.print '=== Data 3NF — Full Order Detail ===';
SELECT 
    o.id AS order_id,
    c.name AS customer,
    p.name AS product,
    p.category,
    oi.quantity,
    p.price,
    oi.quantity * p.price AS total
FROM orders_3nf o
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN order_items_3nf oi ON oi.order_id = o.id
INNER JOIN products p ON oi.product_id = p.id;

.print '';
.print '✅ 3NF terpenuhi!';
.print '   - Setiap data cuma disimpan di SATU tempat';
.print '   - Ganti harga Laptop? Cukup update 1 baris di tabel products';
.print '   - Ganti kategori produk? Cukup update 1 baris';
.print '   - Data konsisten, gak redundant';
.print '';
.print '🔥 NORMALISASI SELESAI!';
.print '---';
.print 'Tabel yang dihasilkan:';
.print '- customers (id, name, email)';
.print '- products (id, name, price, category)';
.print '- orders (id, customer_id, order_date)';
.print '- order_items (id, order_id, product_id, quantity)';
