-- ============================================
-- 02-03: Bandingin Sequential vs Index Scan
-- ============================================

-- Bikin database baru biar bersih
-- Jalanin: sqlite3 compare.db < 03_compare_scan.sql

.timer ON

-- Bikin tabel
CREATE TABLE posts_no_index (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    user_id INTEGER,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Insert 50.000 baris data dummy
INSERT INTO posts_no_index (title, user_id)
SELECT 'Artikel ke-' || value, (value % 100) + 1
FROM generate_series(1, 50000);

-- ============================================
-- TEST 1: Sequential Scan (tanpa index di user_id)
-- ============================================
.print '=== TEST 1: Sequential Scan — Cari user_id = 50 ===';
SELECT COUNT(*) FROM posts_no_index WHERE user_id = 50;

-- ============================================
-- BIKIN INDEX
-- ============================================
CREATE INDEX IF NOT EXISTS idx_posts_userid ON posts_no_index(user_id);
.print '✅ Index di user_id berhasil dibuat!';

-- ============================================
-- TEST 2: Index Scan (pake index di user_id)
-- ============================================
.print '=== TEST 2: Index Scan — Cari user_id = 50 ===';
SELECT COUNT(*) FROM posts_no_index WHERE user_id = 50;

-- ============================================
-- TEST 3: Trade-off (nulis lebih lambat)
-- ============================================
.print '=== TEST 3: INSERT dengan vs tanpa index ===';

-- Buat tabel tanpa index
CREATE TABLE IF NOT EXISTS test_no_index (
    id INTEGER PRIMARY KEY,
    value TEXT
);

-- Buat tabel dengan index
CREATE TABLE IF NOT EXISTS test_with_index (
    id INTEGER PRIMARY KEY,
    value TEXT
);
CREATE INDEX IF NOT EXISTS idx_test_value ON test_with_index(value);

-- Insert 1000 baris ke tabel tanpa index
.print 'INSERT 1000 baris ke tabel TANPA index:';
INSERT INTO test_no_index (id, value)
SELECT value, 'data-' || value FROM generate_series(1, 1000);

-- Insert 1000 baris ke tabel dengan index
.print 'INSERT 1000 baris ke tabel DENGAN index:';
INSERT INTO test_with_index (id, value)
SELECT value, 'data-' || value FROM generate_series(1, 1000);

.print '✅ Selesai! Bandingin waktu antara sequential vs index scan.';
.print 'Index scan jauh lebih cepet buat SELECT, tapi INSERT sedikit lebih lambat.';
