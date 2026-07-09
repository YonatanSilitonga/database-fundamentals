-- ============================================
-- 04-02: Simulasi Masalah Concurrent
-- ============================================
-- Buka 2 terminal SQLite, jalankan query ini di masing-masing
--
-- Terminal 1: sqlite3 learn.db < 02_concurrent_issue.sql
-- Terminal 2: sqlite3 learn.db < 02_concurrent_issue.sql
--
-- Ini simulasi 2 user ngakses database BERSAMAAN

-- Bikin tabel counter
CREATE TABLE IF NOT EXISTS counter (
    id INTEGER PRIMARY KEY,
    value INTEGER
);

INSERT INTO counter VALUES (1, 0);

-- ============================================
// SKENARIO: 2 user nambahin counter bersamaan
// ============================================

-- Tanpa transaction
-- User A baca, User B baca di waktu yang sama
-- Keduanya dapet value = 0
-- Keduanya nambah 1 → nulis value = 1
-- Harusnya jadi 2, tapi jadi 1 😱

.print '=== Simulasi Race Condition ===';
.print 'Buka 2 terminal SQLite dan jalanin:';
.print '';
.print 'Terminal 1:';
.print '  BEGIN TRANSACTION;';
.print '  SELECT value FROM counter WHERE id = 1;';
.print '  UPDATE counter SET value = value + 1 WHERE id = 1;';
.print '  COMMIT;';
.print '';
.print 'Terminal 2: jalanin bersamaan!';
.print '';
.print 'Lihat hasil akhir:';
SELECT * FROM counter;

-- 
-- 🔥 BENER PAKE TRANSACTION:
-- Terminal 1: BEGIN → baca → update → COMMIT
-- Terminal 2: nunggu sampe Terminal 1 selesai
-- Hasil akhir: value = 2 ✅
--
