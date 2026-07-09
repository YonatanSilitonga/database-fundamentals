// ============================================
// 03: Simulasi Query Planner
// ============================================
// Query Planner = otak database yang mutusin gimana cara
// ngejalanin query lo seefisien mungkin.
//
// Di sini kita simulasi cara dia mikir.

// Data contoh: 10.000 user
const users = Array.from({ length: 10000 }, (_, i) => ({
    id: i + 1,
    name: `User ${i + 1}`,
    email: `user${i + 1}@email.com`,
    status: i % 2 === 0 ? 'active' : 'inactive'
}));

// Index simulasi pake Map
const indexById = new Map(users.map(u => [u.id, u]));
const indexByName = new Map(users.map(u => [u.name, u]));

// ============================================
// Query Planner Simulation
// ============================================

function queryPlanner(query) {
    console.log(`📝 Query Planner menganalisis: "${query.description}"`);
    console.log(`   Kondisi: ${query.condition}`);
    console.log(`   Index tersedia: ${query.availableIndexes.join(', ') || 'tidak ada'}`);

    // Estimasi cost sequential scan
    const sequentialCost = query.tableSize;
    
    // Estimasi cost index scan
    let indexCost = Infinity;
    let selectedIndex = null;

    for (const idx of query.availableIndexes) {
        if (query.condition.includes(idx.column)) {
            // Index scan: cari di B-Tree (log n) + ambil data (1 langkah)
            const cost = Math.log2(query.tableSize) + 1;
            if (cost < indexCost) {
                indexCost = cost;
                selectedIndex = idx.name;
            }
        }
    }

    console.log(`   📊 Estimasi cost sequential scan: ${sequentialCost} langkah`);
    
    if (selectedIndex) {
        console.log(`   📊 Estimasi cost index scan (${selectedIndex}): ${indexCost} langkah`);
        console.log(`   ✅ Query Planner memilih: INDEX SCAN (pake ${selectedIndex})`);
        return 'index_scan';
    } else {
        console.log(`   ❌ Tidak ada index yang cocok`);
        console.log(`   ✅ Query Planner memilih: SEQUENTIAL SCAN`);
        return 'sequential_scan';
    }
}

// ============================================
// TEST
// ============================================

console.log('=== Simulasi Query Planner ===\n');

// Query 1: Cari berdasarkan ID (ada index PRIMARY KEY)
const query1 = {
    description: 'Cari user berdasarkan ID',
    condition: 'WHERE id = 5000',
    tableSize: 10000,
    availableIndexes: [
        { name: 'PRIMARY KEY (id)', column: 'id' }
    ]
};
queryPlanner(query1);

console.log('');

// Query 2: Cari berdasarkan email (GAK ada index)
const query2 = {
    description: 'Cari user berdasarkan email',
    condition: 'WHERE email = "user5000@email.com"',
    tableSize: 10000,
    availableIndexes: [
        { name: 'PRIMARY KEY (id)', column: 'id' }
    ]
};
queryPlanner(query2);

console.log('');

// Query 3: Cari berdasarkan name (ADA index)
const query3 = {
    description: 'Cari user berdasarkan name',
    condition: 'WHERE name = "User 5000"',
    tableSize: 10000,
    availableIndexes: [
        { name: 'PRIMARY KEY (id)', column: 'id' },
        { name: 'idx_users_name (name)', column: 'name' }
    ]
};
queryPlanner(query3);

console.log('\n=== KESIMPULAN ===');
console.log('- Query Planner selalu milih cara termurah');
console.log('- Index scan murah buat nyari sedikit data');
console.log('- Sequential scan lebih murah kalo harus baca > 30% data');
console.log('- Makanya EXPLAIN penting — liat apakah planner udah milih yang bener');
