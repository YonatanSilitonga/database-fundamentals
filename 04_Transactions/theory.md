# 04 — Transactions & ACID

---

## Kenapa Transaction Penting?

Bayangin lo transfer uang 100rb dari rekening A ke B.

Yang terjadi di database:
1. Kurangi saldo A: `A.saldo = A.saldo - 100000`
2. Tambah saldo B: `B.saldo = B.saldo + 100000`

**Apa yang terjadi kalau step 1 berhasil, tapi step 2 gagal?**
- Uang lo ilang 100rb
- Saldo A berkurang, tapi saldo B gak nambah

**Transaction** memastikan **semua step berhasil ATAU semua gagal**. Gak ada setengah-setengah.

---

## ACID

Ini 4 properti yang bikin database bisa dipercaya:

### Atomicity
Semua operasi dalam transaction dianggap **satu kesatuan**. Berhasil semua atau gagal semua.

Gak ada kata "setengah berhasil". Kalau ada error di tengah, semua di-**rollback** ke keadaan semula.

### Consistency
Data selalu **valid** sebelum dan sesudah transaction. Semua aturan (constraint, foreign key, tipe data) tetap terpenuhi.

Kalau lo bilang `email TEXT NOT NULL`, habis transaction juga email gak boleh jadi NULL.

### Isolation
Transaction yang berjalan **bersamaan** gak saling ganggu.

Kayak antrian bank: teller 1 layani nasabah A, teller 2 layani nasabah B. Mereka gak saling ambil data yang lagi diproses.

### Durability
Kalau transaction udah **commit** (berhasil), datanya **aman** — bahkan kalau listrik mati 1 detik kemudian.

Data udah tersimpan di disk, bukan cuma di RAM.

---

## Locking

Cara database ngatur biar 2 transaction gak saling tabrakan.

| Jenis Lock | Arti |
|---|---|
| **Shared Lock** | Banyak orang bisa BACA bareng-bareng |
| **Exclusive Lock** | Cuma SATU orang yang bisa NULIS |
| **Deadlock** | 2 transaction saling nunggu — database biasanya otomatis abort salah satu |

---

## Apa yang Akan Lo Praktekkan:

1. **BEGIN, COMMIT, ROLLBACK** — transaction manual
2. **Simulasi race condition** — apa jadinya kalo gak pake transaction
3. **Isolation levels** — beda tingkat keamanan vs kecepatan
4. **Simulasi transaction pake JS** — paham konsep atomicity
