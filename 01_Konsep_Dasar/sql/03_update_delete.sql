-- ============================================
-- 03: UPDATE & DELETE — Ubah & Hapus Data
-- ============================================

-- UPDATE: ganti email user id 1
.print '=== Sebelum update ===';
SELECT * FROM users WHERE id = 1;

UPDATE users SET email = 'yanto_baru@email.com' WHERE id = 1;

.print '=== Sesudah update ===';
SELECT * FROM users WHERE id = 1;

-- DELETE: hapus user id 3
.print '=== Sebelum delete ===';
SELECT * FROM users;

DELETE FROM users WHERE id = 3;

.print '=== Sesudah delete ===';
SELECT * FROM users;

-- ⚠️ HATI-HATI: kalo lupa WHERE, semua data kehapus!
-- Contoh berbahaya (jangan dijalanin):
-- DELETE FROM users;  -- ☠️ ini hapus SEMUA users
