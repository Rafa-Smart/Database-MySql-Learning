


-- tolong baca seluruh penjelasan dibawah ini


1.SELECT FOR UPDATE
-- melakukan locking setelah select


-- jadi selain melakukan locking otomatis menggunkan transaction
-- kita juga bsia melakukan locking secara manual
-- jadi kadang ketika saat kita membuat aplikasi, kita juga sering melakukan select
-- query terlebih dahulu sebelum melakukan update data

-- jika kita ingin melakukan locking sebuah data secara manual, maka kita bisa
-- tambahkan perintah for update dibelakang perintah select

-- jadi saat kita lock record yang kita select, maka jika ada proses lain yang akan melakukan
-- proses update, delete, atau select for update lagi, maka proses lainnya ini
-- akan diminta menunggu sampai kita selesai melakukan commit atau rollback


-- jadi gini simplenya
-- ketika kita mneggunakan select for update, artinya saya mau elect data ini
-- dan tolong lock data ini jangan sampai ada user lain
-- yang mengubah data didalamnya, karena saya inign update data didalamnya

-- jadi ketika ada user lain yang inign select juga maka akan nunggu
-- karena ketika user 1 select maka dia lihat data id 1 quantitynya 10
-- lalu user satu ini mengubah data quantitynya menjadi 0 karena beli 10 barnag

-- nah kalo ga di lock, maka nanti user lain etika select datanya, itu masih ada 10 quantitynya
-- padahal di sisi lain, sudah ada user 1 yang mengurangi quantitynya
-- makanya ini adalah masalah yang sbia di hilangkan dnegna lock manual




USE toko_online;

START TRANSACTION;
SELECT * FROM products;


-- nah disini kita gunakan seelct for update
-- jai ketika kita sudah select ini
-- maka harapannya tidak ada yang boleh select lagi data ini

SELECT * FROM products WHERE id = 'p0002' FOR update;

-- disini bisa langusng berhasil yang user lain jika kita commit(meskipun belum update) atau 
-- commit setelah update

mysql> SELECT * FROM products WHERE id = 'p0002' FOR update;
1 row in set (18.18 sec)

COMMIT;

-- disini kita ubah quantitynya yg id p0002 menjadi 0
UPDATE products
SET quantity = quantity - 10
WHERE id = 'p0002';

COMMIT;

-- nah lihat datanya, berhasil select tapi setelah saya commit

mysql> SELECT * FROM products WHERE id = 'p0002' FOR update;
1 row in set (18.18 sec)










 * 📌 APA ITU MANUAL LOCKING?
 * ---------------------------------------------------------------
 * ➤ Manual Locking adalah mekanisme penguncian data **secara eksplisit**
 *    (manual) oleh user menggunakan perintah SQL seperti:
 *    - `LOCK TABLES`
 *    - `UNLOCK TABLES`
 *    - `SELECT ... FOR UPDATE`
 *    - `SELECT ... LOCK IN SHARE MODE`
 *
 * ➤ Manual Locking memberikan **kendali penuh** kepada developer
 *    untuk menentukan kapan dan bagaimana data dikunci agar
 *    **tidak terjadi konflik dalam transaksi**.
 *
 * ===============================================================
 * 📦 KENAPA HARUS PAKAI MANUAL LOCKING?
 * ---------------------------------------------------------------
 * ✅ Untuk mencegah konflik antar transaksi
 * ✅ Untuk menjamin satu-satunya proses yang boleh ubah data adalah milik kita
 * ✅ Untuk melindungi data yang akan diproses secara bertahap
 * ✅ Untuk aplikasi dengan **transaksi sensitif** (misal: keuangan, inventory)
 * ✅ Saat **locking otomatis** tidak cukup (misal: ingin kunci lebih awal)
 *
 * ===============================================================
 * 🔑 JENIS-JENIS MANUAL LOCKING DI MYSQL
 * ---------------------------------------------------------------
 * 1. `LOCK TABLES` / `UNLOCK TABLES`
 * 2. `SELECT ... FOR UPDATE`
 * 3. `SELECT ... LOCK IN SHARE MODE`
 *
 * Semua ini bersifat manual, artinya kita sendiri yang
 * memerintahkan MySQL untuk mengunci.
 */


 * ===============================================================
 * 🔒 1. `LOCK TABLES` dan `UNLOCK TABLES`
 * ---------------------------------------------------------------
 * ➤ Mengunci seluruh tabel (table-level lock)
 * ➤ Dua mode utama:
 *   - READ  → hanya bisa dibaca (oleh koneksi lain juga)
 *   - WRITE → hanya koneksi ini yang bisa baca/tulis
 *
 * 📌 SYNTAX:
 *   LOCK TABLES nama_tabel READ;
 *   LOCK TABLES nama_tabel WRITE;
 *   UNLOCK TABLES;
 *
 * 📌 CONTOH:
 */
const lockTableExample = `
LOCK TABLES accounts WRITE;

-- baris berikut hanya bisa dijalankan oleh koneksi yang mengunci
UPDATE accounts SET balance = balance - 100 WHERE id = 1;

UNLOCK TABLES;
`;


 * 🔍 CATATAN:
 * - Saat WRITE lock aktif, koneksi lain akan **terblokir** jika mencoba akses
 * - Harus manual dilepas dengan `UNLOCK TABLES`
 * - Tidak butuh `START TRANSACTION` → karena bekerja di luar transaksi
 *
 * ❗ KETERBATASAN:
 * - Tidak bisa digunakan bersamaan dengan transaksi (InnoDB)
 * - Biasanya digunakan untuk MyISAM / MEMORY engine
 */

* ===============================================================
 * 🔒 2. `SELECT ... FOR UPDATE`
 * ---------------------------------------------------------------
 * ➤ Mengunci **baris** yang dipilih agar tidak bisa diubah oleh transaksi lain
 * ➤ Hanya berlaku pada engine InnoDB dan dalam `START TRANSACTION`
 * ➤ Baris akan dikunci sampai transaksi `COMMIT` atau `ROLLBACK`
 *
 * 📌 SYNTAX:
 *   SELECT * FROM tabel WHERE ... FOR UPDATE;
 *
 * 📌 CONTOH:
 */
const forUpdateExample = `
START TRANSACTION;

SELECT * FROM accounts
WHERE id = 1
FOR UPDATE;

-- Baris dengan id = 1 terkunci eksklusif

UPDATE accounts SET balance = balance - 500 WHERE id = 1;

COMMIT;
`;


 * 🔍 CATATAN:
 * - FOR UPDATE mengunci baris untuk **baca + tulis**
 * - Koneksi lain yang mencoba UPDATE/DELETE baris tersebut akan menunggu
 * - Aman untuk sistem keuangan, pembelian stok, dll
 */

/
 * ===============================================================
 * 🔒 3. `SELECT ... LOCK IN SHARE MODE`
 * ---------------------------------------------------------------
 * ➤ Mengunci baris yang dibaca dalam mode **shared**
 * ➤ Transaksi lain boleh membaca, tapi tidak boleh mengubah
 *
 * 📌 Gunanya: untuk memastikan data **tidak berubah** saat sedang dibaca
 *
 * 📌 CONTOH:
 */
const lockInShareModeExample = `
START TRANSACTION;

SELECT * FROM products
WHERE stock > 0
LOCK IN SHARE MODE;

-- proses baca data...

COMMIT;
`;


 * 🔍 CATATAN:
 * - LOCK IN SHARE MODE cocok untuk sistem yang hanya butuh proteksi terhadap perubahan (bukan eksklusif)
 * - Tidak memblok SELECT lain, hanya UPDATE/DELETE
 */


 * ===============================================================
 * ⚠️ PERBEDAAN UTAMA: FOR UPDATE vs LOCK IN SHARE MODE
 * ---------------------------------------------------------------
 *
 * | Fitur                     | FOR UPDATE            | LOCK IN SHARE MODE     |
 * |---------------------------|------------------------|------------------------|
 * | Jenis lock                | Eksklusif (write lock) | Shared (read lock)     |
 * | Mencegah UPDATE/DELETE    | ✅ Ya                  | ✅ Ya                  |
 * | Mencegah SELECT           | ❌ Tidak               | ❌ Tidak               |
 * | Cocok untuk               | Ubah data             | Baca aman tanpa ubah   |
 *
 * ❗ Keduanya hanya bisa digunakan dalam transaksi (START TRANSACTION)
 */


 * ===============================================================
 * 🔁 CONTOH REAL-WORLD: SISTEM TRANSFER SALDO DENGAN FOR UPDATE
 * ---------------------------------------------------------------
 */
const transferSaldo = `
START TRANSACTION;

SELECT * FROM accounts WHERE id = 1 FOR UPDATE;
SELECT * FROM accounts WHERE id = 2 FOR UPDATE;

UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

COMMIT;
`;


 * 🔍 Fungsi FOR UPDATE di atas:
 * - Kunci baris id=1 dan id=2 supaya saldo tidak berubah oleh transaksi lain
 * - Hindari race condition
 */


 * ===============================================================
 * 🧠 KAPAN PAKAI MANUAL LOCKING?
 * ---------------------------------------------------------------
 * ✅ Saat kamu butuh kontrol penuh atas data yang sedang diproses
 * ✅ Saat ingin membaca + memastikan tidak berubah (FOR UPDATE)
 * ✅ Saat ingin mencegah konflik data karena proses bersamaan
 * ✅ Saat update harus akurat (misal pengurangan stok barang)
 * ✅ Saat update dilakukan melalui banyak langkah (validasi, proses, simpan)
 */

 * ===============================================================
 * 🧩 KELEBIHAN & KEKURANGAN MANUAL LOCKING
 * ---------------------------------------------------------------
 *
 * ✅ Kelebihan:
 * - Kontrol penuh atas konsistensi data
 * - Cegah konflik dan kesalahan dalam transaksi
 *
 * ❌ Kekurangan:
 * - Bisa menyebabkan deadlock jika tidak hati-hati
 * - Membuat transaksi lebih kompleks
 * - Tidak cocok jika digunakan sembarangan atau berlebihan
 */


 * ===============================================================
 * BEST PRACTICES UNTUK MANUAL LOCKING
 * ---------------------------------------------------------------
 * ✅ Gunakan transaksi sesingkat mungkin → segera COMMIT/ROLLBACK
 * ✅ Akses baris dalam urutan konsisten → hindari DEADLOCK
 * ✅ Gunakan indeks → hindari locking berlebih
 * ✅ Hindari `LOCK TABLES` jika pakai InnoDB + transaksi
 * ✅ Selalu uji sistem untuk race condition atau konflik data
 */


 * ===============================================================
 * KESIMPULAN
 * ===============================================================
 * 🔹 Manual locking memungkinkan kamu mengontrol proses penguncian data
 * 🔹 Berguna untuk sistem yang membutuhkan keakuratan tinggi
 * 🔹 Dapat dilakukan dengan LOCK TABLES, FOR UPDATE, atau LOCK IN SHARE MODE
 * 🔹 Cocok untuk sistem keuangan, stok, transaksi ganda
 * 🔹 Harus digunakan dengan hati-hati agar tidak menyebabkan deadlock
 */









