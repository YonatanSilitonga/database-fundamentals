-- ============================================
-- 03-03: EXPLAIN — JOIN
-- ============================================

.timer ON

-- Bikin tabel categories
CREATE TABLE IF NOT EXISTS categories (
    id INTEGER PRIMARY KEY,
    name TEXT
);

INSERT INTO categories VALUES (1, 'Elektronik');
INSERT INTO categories VALUES (2, 'Aksesoris');
INSERT INTO categories VALUES (3, 'Furniture');

-- Tambah kolom category_id ke products (dari file sebelumnya)
ALTER TABLE products ADD COLUMN category_id INTEGER DEFAULT 1;
UPDATE products SET category_id = 1 WHERE id IN (1, 4);
UPDATE products SET category_id = 2 WHERE id IN (2, 3, 5);

-- ============================================
// EXPLAIN JOIN tanpa index di category_id
-- ============================================
.print '\n=== JOIN tanpa index di category_id ===';
EXPLAIN QUERY PLAN
SELECT products.name, categories.name AS category
FROM products
INNER JOIN categories ON products.category_id = categories.id;

-- ============================================
// EXPLAIN JOIN dengan index
-- ============================================
.print '\n=== BIKIN INDEX di category_id ===';
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category_id);

.print '\n=== JOIN dengan index di category_id ===';
EXPLAIN QUERY PLAN
SELECT products.name, categories.name AS category
FROM products
INNER JOIN categories ON products.category_id = categories.id;

-- Perhatiin: 
-- Tanpa index: SCAN kedua tabel (sequential) — lambat
-- Dengan index: SEARCH pake index — cepet
