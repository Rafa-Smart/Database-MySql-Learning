




-- saat kita terlalu banyak melakukan locking, maka bisa kemungkinan terjadi
-- deadlocking

-- jadi user 1 nunggu user 2, dan user 2 nunggu user 1

-- conothnya


1. USER 1 melakukan SELECT FOR UPDATE untuk DATA 001
2. USER 2 melakukan SELECT FOR UPDATE untu DATA 002
3. USER 1 melakukan SELECT FOR udpdate untuk DATA 002,
(diminta menunggu karena sudha di lock oleh USER 2)
4. USER 2 melakukan SELECT FOR udpdate untuk DATA 001,
(diminta menunggu karena sudha di lock oleh USER 1)

5. USER 1 dan 2 saling menunggu dan terjadi deadlock



-- contoh 
USE toko_online;
START TRANSACTION;

SELECT * FROM products WHERE id = 'p0004' FOR UPDATE;

-- disini terminal sudah melakukan ini ;
-- START TRANSACTION;
-- SELECT * FROM products WHERE id = 'p0004' FOR UPDATE;

-- kemuadian si user 1 ini mencoba selct data (yg dilock di terminal)

SELECT * FROM products WHERE id = 'p0005' FOR UPDATE;

-- dan di terminal juga saya kasih perintah
SELECT * FROM products WHERE id = 'p0004' FOR UPDATE;

-- maka terjadi lah 
-- ERROR 1213 (40001): Deadlock found when trying to get lock; try restarting transaction

-- maka JIKA TERJADI DEADLOCK
-- SEMUA TRANSACTIONNYA AKAN DI ROLLBACK




 * 📌 APA ITU DEADLOCK?
 * ---------------------------------------------------------------
 * ➤ Deadlock adalah situasi di mana **dua atau lebih transaksi**
 *    saling menunggu sumber daya (lock) yang dipegang oleh yang lain,
 *    sehingga **tidak ada satupun yang bisa melanjutkan eksekusi**.
 *
 * ➤ Akibatnya: MySQL akan **memilih satu transaksi untuk dibatalkan**
 *    secara otomatis untuk memecahkan kebuntuan.
 *
 * ===============================================================
 * 📦 KENAPA DEADLOCK PERLU DIPAHAMI?
 * ---------------------------------------------------------------
 * ✅ Untuk mencegah error saat sistem digunakan banyak user
 * ✅ Untuk menjaga data tetap konsisten saat banyak transaksi berjalan
 * ✅ Untuk menghindari rollback otomatis yang merusak UX (user experience)
 * ✅ Untuk mendesain sistem transaksi yang stabil dan tahan beban
 */


 * ===============================================================
 * 🧠 BAGAIMANA DEADLOCK TERJADI?
 * ---------------------------------------------------------------
 * 🔁 Deadlock terjadi ketika:
 *
 * 1. Transaksi A mengunci baris/barang X
 * 2. Transaksi B mengunci baris/barang Y
 * 3. Transaksi A butuh kunci Y → menunggu
 * 4. Transaksi B butuh kunci X → menunggu
 * 5. 🔥 Kedua transaksi saling tunggu = DEADLOCK
 */


 * ===============================================================
 * ⚠️ CONTOH DEADLOCK DI MYSQL
 * ---------------------------------------------------------------
 * Dua transaksi berjalan di dua koneksi secara paralel:
 */

// ✅ Koneksi 1
const koneksi1 = `
START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
-- Tunggu...
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
-- DEADLOCK terjadi jika koneksi 2 juga ingin id=1
COMMIT;
`;

// ✅ Koneksi 2 (berjalan bersamaan dengan koneksi 1)
const koneksi2 = `
START TRANSACTION;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
-- Tunggu...
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
-- DEADLOCK!
COMMIT;
`;


 * 🔍 Penjelasan:
 * - Koneksi 1 kunci `id=1`, lalu butuh `id=2`
 * - Koneksi 2 kunci `id=2`, lalu butuh `id=1`
 * - Keduanya saling tunggu → MySQL deteksi deadlock → salah satu rollback
 */

 * ===============================================================
 * ❗ AKIBAT DEADLOCK
 * ---------------------------------------------------------------
 * - Salah satu transaksi akan **gagal otomatis**
 * - MySQL akan kirim error: `ERROR 1213 (40001): Deadlock found`
 * - Data bisa saja tidak berubah jika rollback terjadi
 * - Perlu strategi retry dari sisi aplikasi
 */


 * ===============================================================
 * 🔍 CARA MELIHAT DEADLOCK DI MYSQL
 * ---------------------------------------------------------------
 * ➤ Gunakan:
 *   SHOW ENGINE INNODB STATUS\G
 *
 * ➤ Bagian `LATEST DETECTED DEADLOCK` akan tampil detail:
 *   - Transaksi mana yang terlibat
 *   - Tabel dan baris yang dikunci
 *   - Query penyebab deadlock
 */


 * ===============================================================
 * 🛡️ CARA MENCEGAH DEADLOCK
 * ---------------------------------------------------------------
 * ✅ 1. **Selalu akses tabel/baris dalam urutan yang sama**
 *    → Misal: selalu update `id=1` sebelum `id=2`
 *
 * ✅ 2. **Jangan simpan transaksi terlalu lama**
 *    → Buat transaksi sesingkat dan secepat mungkin
 *
 * ✅ 3. **Gunakan indeks**
 *    → Tanpa index, MySQL bisa mengunci banyak baris = risiko lebih besar
 *
 * ✅ 4. **Gunakan LOCK IN SHARE MODE jika tidak butuh ubah data**
 *
 * ✅ 5. **Handle retry di aplikasi**
 *    → Jika terjadi deadlock, tangkap error dan retry transaksi
 *
 * ✅ 6. **Gunakan row-level locking, hindari table lock untuk transaksi besar**
 */


 * ===============================================================
 * 💡 TIPS BEST PRACTICES MENGHINDARI DEADLOCK
 * ---------------------------------------------------------------
 * 🔸 Gunakan `SELECT ... FOR UPDATE` hanya saat benar-benar perlu
 * 🔸 Gunakan `ISOLATION LEVEL` yang sesuai: REPEATABLE READ adalah default
 * 🔸 Simulasikan transaksi dengan user banyak sebelum live
 * 🔸 Gunakan transaksi atomic, singkat, dan prediktif
 * 🔸 Hindari mixed-order update (misal: kadang update A lalu B, kadang sebaliknya)
 */


 * ===============================================================
 * CONTOH PENCEGAHAN DEADLOCK: URUTAN YANG SAMA
 * ---------------------------------------------------------------
 */
const antiDeadlock = `
START TRANSACTION;

-- Akses lebih dulu akun dengan ID lebih kecil
SELECT * FROM accounts WHERE id = 1 FOR UPDATE;
SELECT * FROM accounts WHERE id = 2 FOR UPDATE;

-- Lanjutkan logika transaksi
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

COMMIT;
`;

/
 * 🔍 Semua transaksi disusun agar akses ID selalu dari kecil → besar
 *     sehingga tidak terjadi persilangan kunci antar koneksi
 */


 * ===============================================================
 * KESIMPULAN
 * ===============================================================
 * 🔹 Deadlock = situasi dua transaksi saling menunggu
 * 🔹 Hanya satu transaksi akan dibatalkan oleh MySQL
 * 🔹 Terjadi karena urutan akses sumber daya yang tidak konsisten
 * 🔹 Solusi: urutkan akses data, gunakan index, jaga transaksi singkat
 * 🔹 Gunakan SHOW ENGINE INNODB STATUS untuk debugging
 * 🔹 Tangani rollback dan retry di aplikasi
 */











