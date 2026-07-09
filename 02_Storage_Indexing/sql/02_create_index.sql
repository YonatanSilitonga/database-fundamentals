-- ============================================
-- 02-02: Create Index — Bikin Index
-- ============================================

.timer ON

-- Bikin index di kolom name
CREATE INDEX IF NOT EXISTS idx_users_name ON users_no_index(name);

-- Sekarang coba SELECT yang sama
.print '=== Cari user dengan name = User 9999 (PAKE INDEX) ===';
SELECT * FROM users_no_index WHERE name = 'User 9999';

-- Bandingin waktu nya sama query sebelumnya!
-- Harusnya jauh lebih cepet.

-- Index juga bantu ORDER BY
.print '=== ORDER BY name (terbantu index) ===';
SELECT id, name FROM users_no_index ORDER BY name LIMIT 10;

-- Index komposit (lebih dari 1 kolom)
CREATE INDEX IF NOT EXISTS idx_users_name_email ON users_no_index(name, email);

.timer OFF
