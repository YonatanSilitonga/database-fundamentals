-- ============================================
-- 03-01: EXPLAIN — Liat Rencana Eksekusi Query
-- ============================================
-- Pake database yang udah ada dari 02_Storage_Indexing

-- Aktifin timer
.timer ON

-- Bikin tabel kecil
CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY,
    name TEXT,
    price REAL
);

-- Insert data
INSERT INTO products VALUES (1, 'Laptop', 15000);
INSERT INTO products VALUES (2, 'Mouse', 500);
INSERT INTO products VALUES (3, 'Keyboard', 1000);
INSERT INTO products VALUES (4, 'Monitor', 8000);
INSERT INTO products VALUES (5, 'Headset', 2000);

-- ============================================
-- EXPLAIN QUERY PLAN
-- ============================================
-- Ini nunjukin gimana SQLite ngejalanin query

.print '=== 1. SELECT tanpa WHERE (full scan) ===';
EXPLAIN QUERY PLAN SELECT * FROM products;

.print '\n=== 2. SELECT dengan WHERE di kolom NON-index ===';
EXPLAIN QUERY PLAN SELECT * FROM products WHERE name = 'Laptop';

.print '\n=== 3. SELECT dengan WHERE di PRIMARY KEY ===';
EXPLAIN QUERY PLAN SELECT * FROM products WHERE id = 3;

-- Perhatiin perbedaan:
-- Query 1: SCAN (sequential scan)
-- Query 2: SCAN (sequential scan — gak ada index di name)
-- Query 3: SEARCH (index scan — pake PRIMARY KEY index)
