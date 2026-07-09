-- ============================================
-- 04-03: Isolation Levels
-- ============================================
-- SQLite cuma punya 2 isolation level (paling sederhana):
-- 1. READ UNCOMMITTED (boleh baca data yang belum di-commit)
-- 2. SERIALIZABLE (default — aman)

-- Cek isolation level saat ini
.print '=== Isolation Level Saat Ini ===';
PRAGMA read_uncommitted;

-- SQLite default: SERIALIZABLE
-- Artinya: transaction jalan berurutan, gak saling ganggu

-- ============================================
// SKENARIO: Dirty Read
// ============================================
-- Dirty Read = baca data yang belum di-commit (masih dalam transaction)
-- 
-- User A: BEGIN → UPDATE balance → (belum commit)
-- User B: SELECT balance → dapet data yang BELUM TENTU JADI
-- User A: ROLLBACK
-- User B: pake data palsu! 💀

-- SQLite secara default MENCEGAH dirty read (SERIALIZABLE)
.print '';
.print '✅ SQLite default SERIALIZABLE — aman dari dirty read';
.print '❌ Tapi ini bikin lebih lambat (harus antri)';
.print '';
.print 'Trade-off: Keamanan vs Kecepatan';
.print '- SERIALIZABLE = aman, tapi lebih lambat';
.print '- READ UNCOMMITTED = cepet, tapi resiko baca data palsu';
.print '';
.print 'Pilih sesuai kebutuhan aplikasi lo!';
