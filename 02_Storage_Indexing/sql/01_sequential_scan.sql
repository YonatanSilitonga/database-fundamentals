-- ============================================
-- 02-01: Sequential Scan (Tanpa Index)
-- ============================================
-- Demonstrasi: nyari data tanpa index itu lambat

-- Aktifin timer biar liat lama eksekusi
.timer ON

-- Bikin tabel dengan banyak data
CREATE TABLE IF NOT EXISTS users_no_index (
    id INTEGER PRIMARY KEY,
    name TEXT,
    email TEXT
);

-- Insert 10.000 baris (simulasi data banyak)
INSERT INTO users_no_index (id, name, email)
SELECT value, 'User ' || value, 'user' || value || '@email.com'
FROM generate_series(1, 10000);

-- SELECT tanpa WHERE — full sequential scan
-- Bakal baca semua baris
SELECT COUNT(*) FROM users_no_index;

-- SELECT pake WHERE di kolom NON-index (name)
-- Ini sequential scan — baca satu-satu sampe ketemu
.print '=== Cari user dengan name = User 9999 (TANPA INDEX) ===';
SELECT * FROM users_no_index WHERE name = 'User 9999';

-- Catet waktunya, nanti bandingin sama query pake index di file berikutnya
.timer OFF
