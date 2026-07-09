// ============================================
// 04: Simulasi Transaction (Atomicity)
// ============================================
// Simulasi gimana transaction memastikan ATOMICITY:
// semua berhasil ATAU semua gagal.

const Database = require('better-sqlite3');
const db = new Database('learn.db');

// Bikin tabel rekening
db.exec(`
    CREATE TABLE IF NOT EXISTS simulate_accounts (
        id INTEGER PRIMARY KEY,
        name TEXT,
        balance REAL
    )
`);

// Hapus data lama, insert baru
db.exec('DELETE FROM simulate_accounts');
db.prepare('INSERT INTO simulate_accounts VALUES (?, ?, ?)').run(1, 'Yanto', 100000);
db.prepare('INSERT INTO simulate_accounts VALUES (?, ?, ?)').run(2, 'Budi', 50000);

console.log('=== Simulasi Transaction (Atomicity) ===\n');
console.log('Saldo awal:');
console.log('  Yanto: Rp100.000');
console.log('  Budi:  Rp50.000\n');

// ============================================
// TEST 1: Transaction Berhasil (COMMIT)
// ============================================
console.log('--- TEST 1: Transfer Rp25.000 (BERHASIL) ---');

const transfer = db.transaction((fromId, toId, amount) => {
    const from = db.prepare('SELECT balance FROM simulate_accounts WHERE id = ?').get(fromId);
    const to = db.prepare('SELECT balance FROM simulate_accounts WHERE id = ?').get(toId);

    console.log(`  Saldo Yanto sebelum: Rp${from.balance}`);
    console.log(`  Saldo Budi sebelum: Rp${to.balance}`);
    console.log(`  Transfer: Rp${amount}`);

    db.prepare('UPDATE simulate_accounts SET balance = balance - ? WHERE id = ?').run(amount, fromId);
    db.prepare('UPDATE simulate_accounts SET balance = balance + ? WHERE id = ?').run(amount, toId);
});

try {
    transfer(1, 2, 25000);
    console.log('  ✅ BERHASIL! Semua update di-commit.\n');
} catch (err) {
    console.log('  ❌ GAGAL! Semua di-rollback.\n');
}

console.log('Saldo setelah transfer:');
const saldo = db.prepare('SELECT * FROM simulate_accounts').all();
saldo.forEach(a => console.log(`  ${a.name}: Rp${a.balance}`));

// ============================================
// TEST 2: Transaction Gagal (ROLLBACK)
// ============================================
console.log('\n--- TEST 2: Transfer Rp1.000.000 (GAGAL - saldo gak cukup) ---');

const transferSafe = db.transaction((fromId, toId, amount) => {
    const from = db.prepare('SELECT balance FROM simulate_accounts WHERE id = ?').get(fromId);

    console.log(`  Saldo Yanto: Rp${from.balance}`);
    console.log(`  Mau transfer: Rp${amount}`);

    if (from.balance < amount) {
        throw new Error('Saldo tidak mencukupi!');
    }

    db.prepare('UPDATE simulate_accounts SET balance = balance - ? WHERE id = ?').run(amount, fromId);
    db.prepare('UPDATE simulate_accounts SET balance = balance + ? WHERE id = ?').run(amount, toId);
});

try {
    transferSafe(1, 2, 1000000);
    console.log('  ✅ BERHASIL!');
} catch (err) {
    console.log(`  ❌ GAGAL: ${err.message}`);
    console.log('  🔄 Semua perubahan di-rollback (gak ada yang berubah)');
}

console.log('\nSaldo akhir (harusnya sama kayak setelah test 1):');
const saldoAkhir = db.prepare('SELECT * FROM simulate_accounts').all();
saldoAkhir.forEach(a => console.log(`  ${a.name}: Rp${a.balance}`));

console.log('\n✅ KESIMPULAN: Transaction menjamin ATOMICITY.');
console.log('   Kalau ada satu aja yang gagal, SEMUA dibatalin.');

db.close();
