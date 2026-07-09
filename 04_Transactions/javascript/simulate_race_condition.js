// ============================================
// 04: Simulasi Race Condition (Concurrency)
// ============================================
// Demonstrasi: apa jadinya kalo 2 user akses database
// BERSAMAAN tanpa transaction / locking.

const Database = require('better-sqlite3');

// Bikin 2 database terpisah (simulasi 2 user)
const db1 = new Database('learn.db');
const db2 = new Database('learn.db');

// Bikin tabel
db1.exec(`
    CREATE TABLE IF NOT EXISTS race_counter (
        id INTEGER PRIMARY KEY,
        value INTEGER
    )
`);
db1.exec('DELETE FROM race_counter');
db1.prepare('INSERT INTO race_counter VALUES (1, 0)').run();

console.log('=== Simulasi Race Condition ===\n');
console.log('2 user nambahin counter BERSAMAAN tanpa transaction\n');

// ============================================
// SKENARIO: Tanpa Transaction
// ============================================
console.log('--- Skenario Tanpa Transaction ---');

// User A baca
const valA = db1.prepare('SELECT value FROM race_counter WHERE id = 1').get();
console.log(`  User A baca: value = ${valA.value}`);

// User B baca di WAKTU YANG SAMA
const valB = db2.prepare('SELECT value FROM race_counter WHERE id = 1').get();
console.log(`  User B baca: value = ${valB.value}`);

// User A nambah 1
const newValA = valA.value + 1;
console.log(`  User A nulis: value = ${newValA}`);
db1.prepare('UPDATE race_counter SET value = ? WHERE id = 1').run(newValA);

// User B nambah 1 (pake data basi!)
const newValB = valB.value + 1;
console.log(`  User B nulis: value = ${newValB} (pake data basi! 😱)`);
db2.prepare('UPDATE race_counter SET value = ? WHERE id = 1').run(newValB);

// Cek hasil akhir
const result = db1.prepare('SELECT value FROM race_counter WHERE id = 1').get();
console.log(`\n  Hasil akhir: value = ${result.value}`);
console.log(`  Harusnya: value = 2 (karena 2 user nambah)`);
console.log(`  Tapi jadi: value = 1 karena race condition! 💀`);

// ============================================
// SKENARIO: Dengan Transaction (pake locking)
// ============================================
console.log('\n--- Skenario Dengan Transaction (Locking) ---');

// Reset counter
db1.exec('DELETE FROM race_counter');
db1.prepare('INSERT INTO race_counter VALUES (1, 0)').run();

// User A pake transaction (dia yang duluan)
console.log('  User A mulai transaction...');
const transactionA = db1.transaction(() => {
    const currentA = db1.prepare('SELECT value FROM race_counter WHERE id = 1').get();
    const newA = currentA.value + 1;
    console.log(`  User A: baca ${currentA.value} → nulis ${newA}`);
    db1.prepare('UPDATE race_counter SET value = ? WHERE id = 1').run(newA);
});

// User B pake transaction
const transactionB = db2.transaction(() => {
    const currentB = db2.prepare('SELECT value FROM race_counter WHERE id = 1').get();
    const newB = currentB.value + 1;
    console.log(`  User B: baca ${currentB.value} → nulis ${newB}`);
    db2.prepare('UPDATE race_counter SET value = ? WHERE id = 1').run(newB);
});

// Jalanin berurutan (simulasi locking — SQLite serializes)
transactionA();
console.log('  ✅ User A selesai (commit)');
transactionB();
console.log('  ✅ User B selesai (commit)');

const resultAkhir = db1.prepare('SELECT value FROM race_counter WHERE id = 1').get();
console.log(`\n  Hasil akhir: value = ${resultAkhir.value} ✅`);
console.log(`  (Bener 2, karena transaction diproses bergantian)`);

console.log('\n✅ KESIMPULAN:');
console.log('- Tanpa transaction: data bisa corrupted (race condition)');
console.log('- Dengan transaction: data aman (diproses bergantian)');
console.log('- SQLite otomatis pake locking di level database');

db1.close();
db2.close();
