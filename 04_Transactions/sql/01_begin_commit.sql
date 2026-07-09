-- ============================================
-- 04-01: BEGIN, COMMIT, ROLLBACK
-- ============================================

.timer ON

-- Bikin tabel rekening
CREATE TABLE IF NOT EXISTS accounts (
    id INTEGER PRIMARY KEY,
    name TEXT,
    balance REAL
);

INSERT INTO accounts VALUES (1, 'Yanto', 100000);
INSERT INTO accounts VALUES (2, 'Budi', 50000);

.print '=== Saldo Awal ===';
SELECT * FROM accounts;

-- ============================================
// TRANSACTION BERHASIL (COMMIT)
-- ============================================
.print '\n=== Transfer 25000 dari Yanto ke Budi ===';

BEGIN TRANSACTION;

    UPDATE accounts SET balance = balance - 25000 WHERE id = 1;
    UPDATE accounts SET balance = balance + 25000 WHERE id = 2;

COMMIT;

.print '✅ Transfer berhasil! Saldo setelah transfer:';
SELECT * FROM accounts;

-- ============================================
// TRANSACTION GAGAL (ROLLBACK)
-- ============================================
.print '\n=== Coba transfer 1000000 (saldo gak cukup) ===';

BEGIN TRANSACTION;

    UPDATE accounts SET balance = balance - 1000000 WHERE id = 1;
    
    -- Oops, saldo Yanto gak cukup! Tapi kita udah kurangin...
    -- Kita rollback aja sebelum terlambat
    ROLLBACK;

.print '🔄 Rollback! Saldo kembali ke keadaan semula:';
SELECT * FROM accounts;

-- ============================================
// PAHAMI INI
-- ============================================
.print '\n=== INTINYA ===';
.print '- BEGIN: mulai transaction';
.print '- COMMIT: simpan perubahan (berhasil semua)';
.print '- ROLLBACK: batalkan perubahan (gagal semua)';
.print '- Atomicity: gak ada setengah berhasil!';
