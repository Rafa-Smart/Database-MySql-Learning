



-- jadi sebelumnya kita hanya locking baris saja
-- tapi dngan locking table ini, kita bisa melakukan locking pada satu tabel




-- jadi ini akna beda dengan star transaction dan commit/rollback
use toko_online;

-- jadi kalo inig lock table 
lock tables nama_table read
lock tables nama_table write


--kalo mau unlock
pake cara 
unlock tables;





-- ini dia perbedaan antara read dan juga write
===============================================================
 * 📌 PERBEDAAN DARI SISI YANG MENGUNCI (SESI AKTIF)
 * ---------------------------------------------------------------
 * ✅ READ LOCK:
 *   - Sesi yang mengunci tabel dengan READ LOCK hanya bisa:
 *     ➤ SELECT (membaca data)
 *     ➤ Tidak bisa: INSERT, UPDATE, DELETE
 *
 * ✅ WRITE LOCK:
 *   - Sesi yang mengunci tabel dengan WRITE LOCK bisa:
 *     ➤ SELECT (membaca)
 *     ➤ INSERT, UPDATE, DELETE (menulis atau mengubah data)
 *
 * ===============================================================
 * 📌 PERBEDAAN DARI SISI USER/KONEKSI LAIN
 * ---------------------------------------------------------------
 * ❌ Saat tabel dikunci dengan READ LOCK:
 *   - Koneksi lain hanya bisa:
 *     ➤ SELECT (baca saja)
 *     ➤ ❌ Tidak bisa INSERT, UPDATE, DELETE
 *   - Artinya: semua koneksi bisa membaca, tapi tidak bisa menulis
 *
 * ❌ Saat tabel dikunci dengan WRITE LOCK:
 *   - Koneksi lain tidak bisa melakukan apapun ke tabel tersebut
 *     ➤ ❌ Tidak bisa SELECT (baca)
 *     ➤ ❌ Tidak bisa INSERT, UPDATE, DELETE
 *   - Hanya koneksi yang mengunci yang bisa akses
 *
 * ===============================================================






 * ===============================================================
 * 🔐 PERBEDAAN READ LOCK vs WRITE LOCK DI MYSQL
 * ===============================================================
 *
 * 💡 Keduanya digunakan dalam perintah:
 *    LOCK TABLES nama_tabel READ;
 *    LOCK TABLES nama_tabel WRITE;
 *
 * ===============================================================
 * 📌 PERBEDAAN DARI SISI YANG MENGUNCI (SESI AKTIF)
 * ---------------------------------------------------------------
 * ✅ READ LOCK:
 *   - Sesi yang mengunci tabel dengan READ LOCK hanya bisa:
 *     ➤ SELECT (membaca data)
 *     ➤ Tidak bisa: INSERT, UPDATE, DELETE
 *
 * ✅ WRITE LOCK:
 *   - Sesi yang mengunci tabel dengan WRITE LOCK bisa:
 *     ➤ SELECT (membaca)
 *     ➤ INSERT, UPDATE, DELETE (menulis atau mengubah data)
 *
 * ===============================================================
 * 📌 PERBEDAAN DARI SISI USER/KONEKSI LAIN
 * ---------------------------------------------------------------
 * ❌ Saat tabel dikunci dengan READ LOCK:
 *   - Koneksi lain hanya bisa:
 *     ➤ SELECT (baca saja)
 *     ➤ ❌ Tidak bisa INSERT, UPDATE, DELETE
 *   - Artinya: semua koneksi bisa membaca, tapi tidak bisa menulis
 *
 * ❌ Saat tabel dikunci dengan WRITE LOCK:
 *   - Koneksi lain tidak bisa melakukan apapun ke tabel tersebut
 *     ➤ ❌ Tidak bisa SELECT (baca)
 *     ➤ ❌ Tidak bisa INSERT, UPDATE, DELETE
 *   - Hanya koneksi yang mengunci yang bisa akses
 *
 * ===============================================================
 * 🧪 ILUSTRASI KASUS
 * ---------------------------------------------------------------
 *
 * 🔸 Skenario A: USER_1 → `LOCK TABLES orders READ;`
 *    - USER_1 bisa: `SELECT * FROM orders`
 *    - USER_1 tidak bisa: `INSERT INTO orders ...`
 *    - USER_2 bisa: `SELECT * FROM orders`
 *    - USER_2 tidak bisa: `UPDATE orders SET ...`
 *
 * 🔸 Skenario B: USER_1 → `LOCK TABLES orders WRITE;`
 *    - USER_1 bisa: `SELECT`, `INSERT`, `UPDATE`, `DELETE`
 *    - USER_2 ❌ tidak bisa melakukan operasi apapun sampai `UNLOCK`
 *
 * ===============================================================
 * 📌 PERINTAH DASAR:
 * ---------------------------------------------------------------
 *   LOCK TABLES nama_tabel READ;  → Baca saja (semua koneksi)
 *   LOCK TABLES nama_tabel WRITE; → Koneksi lain akan menunggu
 *   UNLOCK TABLES;                → Melepaskan semua kunci tabel
 *
 * ===============================================================
 * 🎯 KESIMPULAN
 * ---------------------------------------------------------------
 * 🔹 READ LOCK  → Semua koneksi hanya bisa baca
 * 🔹 WRITE LOCK → Hanya koneksi pengunci yang bisa baca/tulis
 * 🔹 Koneksi lain akan ❌ diblokir selama lock aktif
 */




 *
 * 📌 APA ITU TABLE LOCK?
 * ---------------------------------------------------------------
 * ➤ Table locking adalah proses **penguncian seluruh tabel**
 *    dalam database, baik untuk membaca (READ) atau menulis (WRITE),
 *    agar tidak dapat diakses atau dimodifikasi oleh sesi lain
 *    selama sesi yang mengunci masih aktif.
 *
 * ➤ Ini adalah jenis locking yang **manual dan eksplisit**.
 *
 * ===============================================================
 * 🧠 TUJUAN / MANFAAT MENGGUNAKAN TABLE LOCK
 * ---------------------------------------------------------------
 * ✅ Menjaga konsistensi data saat proses sensitif berjalan
 * ✅ Mencegah race condition antar user/koneksi
 * ✅ Menghindari pembacaan/penulisan data yang tidak stabil
 * ✅ Cocok untuk engine yang tidak mendukung transaksi (misal: MyISAM)
 */


 * ===============================================================
 * 🛠️ CARA KERJA TABLE LOCK
 * ---------------------------------------------------------------
 * ➤ MySQL akan **mengunci seluruh tabel** yang ditentukan
 *    agar hanya bisa digunakan sesuai jenis lock yang diberikan:
 *
 * 🔐 Jenis Lock:
 *   - READ LOCK  → hanya boleh membaca data
 *   - WRITE LOCK → hanya koneksi pemilik yang bisa baca/tulis
 *
 * ➤ Perintah:
 *   - `LOCK TABLES nama_tabel READ;`
 *   - `LOCK TABLES nama_tabel WRITE;`
 *   - `UNLOCK TABLES;` → untuk melepas kunci
 *
 * ➤ Selama tabel dikunci:
 *   - Koneksi lain yang ingin akses akan **menunggu**
 *   - Tidak bisa digunakan dalam transaksi `START TRANSACTION` (InnoDB)
 */


 * ===============================================================
 * ✅ CONTOH PENGGUNAAN: WRITE LOCK
 * ---------------------------------------------------------------
 * 🔒 Hanya satu koneksi yang bisa baca/tulis selama terkunci
 */
const contohWriteLock = `
LOCK TABLES products WRITE;

UPDATE products SET stock = stock - 1 WHERE id = 10;

UNLOCK TABLES;
`;


 * 🔍 Penjelasan:
 * - Sesi ini mengunci tabel `products` dengan WRITE lock
 * - Sesi lain tidak bisa SELECT/INSERT/UPDATE ke tabel ini
 */


 * ===============================================================
 * ✅ CONTOH PENGGUNAAN: READ LOCK
 * ---------------------------------------------------------------
 * 🔒 Hanya bisa membaca, tidak bisa mengubah data
 * 🔒 Koneksi lain tetap bisa READ, tapi tidak bisa WRITE
 */
const contohReadLock = `
LOCK TABLES orders READ;

SELECT * FROM orders WHERE status = 'pending';

UNLOCK TABLES;
`;

 * 🔍 Penjelasan:
 * - Koneksi ini bisa baca data
 * - Koneksi lain juga bisa baca
 * - Tapi semua koneksi (termasuk ini) tidak bisa INSERT/UPDATE/DELETE
 */


 * ===============================================================
 * ⚠️ KETERBATASAN TABLE LOCK
 * ---------------------------------------------------------------
 * ❌ Tidak bisa digunakan bersamaan dengan TRANSACTIONS (InnoDB)
 * ❌ Tidak efisien untuk sistem dengan banyak user (karena mengunci penuh)
 * ❌ Bisa menyebabkan bottleneck/perlambatan
 * ❌ Harus dilepas secara manual (UNLOCK TABLES)
 */

*
 * ===============================================================
 * 🧩 PERBEDAAN TABLE LOCK vs ROW LOCK
 * ---------------------------------------------------------------
 *
 * | Fitur                 | TABLE LOCK          | ROW LOCK (InnoDB)        |
 * |-----------------------|---------------------|---------------------------|
 * | Lingkup penguncian    | Seluruh tabel       | Baris spesifik            |
 * | Efisiensi             | Kurang efisien      | Lebih efisien             |
 * | Cocok untuk           | MyISAM, MEMORY      | InnoDB (default modern)   |
 * | Multi-user system     | Tidak cocok         | Sangat cocok              |
 * | Digunakan dengan Tx   | ❌ Tidak bisa        | ✅ Bisa (START TRANSACTION)|
 * | Manual                | ✅ Ya               | ✅ Juga bisa (FOR UPDATE)  |
 */

 * ===============================================================
 * 🛡️ KAPAN HARUS MENGGUNAKAN TABLE LOCK?
 * ---------------------------------------------------------------
 * ✅ Saat menggunakan storage engine MyISAM (non-transactional)
 * ✅ Saat melakukan batch INSERT/UPDATE besar dan ingin kunci penuh
 * ✅ Saat butuh baca data tanpa perubahan selama proses
 * ✅ Saat menulis script maintenance (misal backup, sync)
 * ✅ Saat engine tidak mendukung transaksi (contoh MEMORY table)
 */


 * ===============================================================
 * 🔄 CONTOH: SINKRONISASI DATA
 * ---------------------------------------------------------------
 */
const contohSinkronisasi = `
LOCK TABLES customers WRITE, orders WRITE;

-- sinkronisasi data antar tabel
UPDATE customers SET total_orders = (
    SELECT COUNT(*) FROM orders WHERE orders.customer_id = customers.id
);

UNLOCK TABLES;
`;


 * 🔍 Penjelasan:
 * - Mengunci kedua tabel agar tidak berubah saat sinkronisasi
 */


 * ===============================================================
 * 💡 TIPS & BEST PRACTICE TABLE LOCKING
 * ---------------------------------------------------------------
 * ✅ Pastikan segera UNLOCK TABLES setelah selesai
 * ✅ Gunakan untuk proses yang cepat dan kritis
 * ✅ Hindari table locking untuk aplikasi web bersamaan (lebih baik pakai row lock)
 * ✅ Gunakan untuk engine non-transactional saja
 * ✅ Periksa apakah aplikasi butuh transaksi atau hanya sekadar penguncian sementara
 */


 * ===============================================================
 * 👀 MONITOR LOCK AKTIF
 * ---------------------------------------------------------------
 * ➤ Cek proses dan lock aktif:
 *     SHOW FULL PROCESSLIST;
 *
 * ➤ Hentikan proses yang terkunci:
 *     KILL [id_koneksi];
 */

 * ===============================================================
 * KESIMPULAN
 * ===============================================================
 * 🔹 Table Lock adalah penguncian seluruh tabel untuk mencegah konflik data
 * 🔹 Cocok untuk proses sederhana, maintenance, atau MyISAM
 * 🔹 Tidak cocok untuk sistem transaksi padat dan kompleks
 * 🔹 Lebih baik gunakan ROW LOCKING (InnoDB) untuk sistem modern
 * 🔹 Harus dilepas manual dengan UNLOCK TABLES
 * 🔹 Gunakan secara bijak agar tidak menyebabkan bottleneck
 */











