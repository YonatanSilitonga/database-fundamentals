// ============================================
// 02: Simulasi B-Tree Sederhana
// ============================================
// Jalanin: node btree_simulation.js
//
// B-Tree itu struktur data yang dipake database buat index.
// Bedanya sama binary tree: setiap node bisa punya lebih dari 2 anak.
// Makin sedikit level-nya, makin cepet pencarian.
//
// Di sini kita simulasi pake array biasa biar gampang dipahami.

// === Sequential Search (O(n)) ===
// Nyari data dengan baca satu-satu dari depan
function sequentialSearch(data, target) {
    for (let i = 0; i < data.length; i++) {
        if (data[i] === target) {
            return i;
        }
    }
    return -1;
}

// === Index Search (O(1)) ===
// Pake Map sebagai simulasi index (sebenarnya hash map, bukan B-Tree,
// tapi konsepnya sama: pake struktur data terpisah buat cepetin pencarian)
function indexedSearch(index, target) {
    return index.get(target) ?? -1;
}

// === Binary Search (O(log n)) ===
// Ini simulasi gimana B-Tree nyari data (logarithmic)
function binarySearch(data, target) {
    let left = 0;
    let right = data.length - 1;

    while (left <= right) {
        const mid = Math.floor((left + right) / 2);

        if (data[mid] === target) return mid;
        if (data[mid] < target) left = mid + 1;
        else right = mid - 1;
    }
    return -1;
}

// ============================================
// TEST
// ============================================

console.log('=== Simulasi Sequential Scan vs Index Scan ===\n');

// Bikin data 100.000 angka
const DATA_SIZE = 100000;
const data = Array.from({ length: DATA_SIZE }, (_, i) => i);

// Bikin index (Map)
console.log(`Membuat ${DATA_SIZE} data + index...`);
const index = new Map();
for (let i = 0; i < data.length; i++) {
    index.set(data[i], i);
}
console.log('✅ Selesai!\n');

// Cari angka yang paling akhir (worst case)
const target = DATA_SIZE - 1;

// TEST 1: Sequential Search
console.time('  1. Sequential Search (O(n))');
const result1 = sequentialSearch(data, target);
console.timeEnd('  1. Sequential Search (O(n))');

// TEST 2: Indexed Search (Map)
console.time('  2. Index Search (O(1) - Map)');
const result2 = indexedSearch(index, target);
console.timeEnd('  2. Index Search (O(1) - Map)');

// TEST 3: Binary Search (O(log n))
const sortedData = [...data].sort((a, b) => a - b);
console.time('  3. Binary Search (O(log n))');
const result3 = binarySearch(sortedData, target);
console.timeEnd('  3. Binary Search (O(log n))');

console.log('\n=== Hasil Pencarian ===');
console.log(`  Sequential: ditemukan di index ${result1}`);
console.log(`  Index:      ditemukan di index ${result2}`);
console.log(`  Binary:     ditemukan di index ${result3}`);

console.log('\n=== KESIMPULAN ===');
console.log('Semakin besar data, semakin terasa bedanya:');
console.log('- Sequential Scan: 100.000 data butuh 100.000 langkah');
console.log('- B-Tree/Index: 100.000 data cuma butuh ~17 langkah (log₂ 100.000)');
console.log('- Ini kenapa INDEX itu penting di database!');
