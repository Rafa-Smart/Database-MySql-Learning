




-- jadi ketika kita ingin merollback perintah / mengembalikan ke data sebelumnya 
-- jadi misal kalo kita punya 2 perintah
-- sebelum : start transaction
-- pertama kurangi quantity barang
-- kedua kurangi saldo

-- nah jika pada tahap kedua gagal, maka seluruh perintah sampai start transacion akan
-- digagalkan
--tapi jika berhasil, maka kita bisa commit jadi perintah tersebut akna permanen ada di databasenya


-- atau jika kita sudah transaction lalu ktia melakukan 5 perintah
-- tapi pada perintah ke 5 itu gagal
-- maka kita bisa rollback
-- jadi 4 perintah sebelumnya akan digagalkan juga
-- jadi tidak akan ada kerusakan data


-- jadi setiap kali kita memulai proses transaksi maka ktia harus menjalankan perintah
-- START TRANSACTION;
-- lalu seluruh perintah setelah transsaksi ini akna menjadi transaksi sampai
-- diakhirnya itu rollback (jika ada yg gagal)
-- aatu commit (jika yakin sudh benar)


USE toko_online;
START TRANSACTION;
-- nah setelah kita mulai transaksi, misal kita inigninsert data ke tabel guestbook
INSERT INTO guestbook (email, title, content)
VALUES ('kayla@gmail.com','contoh','contoh'),
       ('kayla@gmail.com','contoh','contoh'),
       ('kayla@gmail.com','contoh','contoh');

SELECT * FROM guestbook;
-- jadi ketika kita atau pada worckbenh ini yang tadi melakukan transaksi
-- kita bisa langsung elihat hasil insertnya ketika select

-- tapi misal ornag lain (user 2) yang select maka datanya belum ada
-- misal kita bukan lagi mysql di terminal
-- dan coba select * from guestbook, maka datayang baru
-- kita insert ini belum tampil
-- SAMPAI KITA MELAKUKAN COMMIT


COMMIT;
-- nah setelah commit maka ketika pihak lain atau user lain
-- mencoba untuk select * from guestbook
-- maka data barunya akan tampil

-- nah tapi kalo truncate itu gabisa, jadi tetep akan kehapus
-- kecuali delete

START TRANSACTION;
truncate guestbook;
SELECT * FROM guestbook;

DELETE FROM guestbook;
SELECT * FROM guestbook;

-- nah kao user ini yang liat select maka datanya sudah terhapus
-- tapi kalo user lain yang liat maka masih ada datanya
-- sampai kita rollback, untuk membatalkan perintahnya


ROLLBACK;

-- perintah perintah yang tidak bisa pake transaksi
-- jadi yang dml -> mengubah struktur table
 * ➤ Perintah seperti:
 *    - CREATE TABLE
 *    - DROP TABLE
 *    - ALTER TABLE
 *    - TRUNCATE
 *    - RENAME
 * ➤ Akan menyebabkan **COMMIT otomatis**
 *    → transaksi yang aktif langsung disimpan permanen


 
 

 * PENJELASAN: PENGECUALIAN TERHADAP TRANSAKSI DI MYSQL


 * ⚠️ Walaupun transaksi di MySQL sangat berguna untuk menjaga 
 * integritas data (ACID), TIDAK SEMUA operasi bisa dilindungi 
 * oleh transaksi.
 *
 * Berikut adalah kasus-kasus yang menjadi **pengecualian**
 * atau **tidak bisa dibatalkan dengan ROLLBACK**.
 */


 * ===============================================================
 * ❌ 1. ENGINE NON-TRANSAKSIONAL (contoh: MyISAM)
 * ---------------------------------------------------------------
 * ➤ Transaksi hanya didukung oleh ENGINE `InnoDB`
 * ➤ Jika tabel menggunakan `MyISAM`, maka:
 *    - `START TRANSACTION` → tidak akan punya efek
 *    - Semua perintah langsung disimpan ke database
 *
 * 📌 CONTOH:
 */
const contoh1 = `
CREATE TABLE log (
  id INT,
  pesan TEXT
) ENGINE = MyISAM;

START TRANSACTION;
INSERT INTO log VALUES (1, 'Tes MyISAM');
ROLLBACK; -- ❌ Tidak berfungsi, data tetap masuk
`;

 * ✅ SOLUSI:
 * Gunakan ENGINE InnoDB
 */


 * ===============================================================
 * ❌ 2. STATEMENT DDL (Data Definition Language)
 * ---------------------------------------------------------------
 * ➤ Perintah seperti:
 *    - CREATE TABLE
 *    - DROP TABLE
 *    - ALTER TABLE
 *    - TRUNCATE
 *    - RENAME
 * ➤ Akan menyebabkan **COMMIT otomatis**
 *    → transaksi yang aktif langsung disimpan permanen
 *
 * 📌 CONTOH:
 */
const contoh2 = `
START TRANSACTION;
DROP TABLE users;
ROLLBACK; -- ❌ Tidak berlaku, tabel tetap terhapus
`;

 * ✅ SOLUSI:
 * Jangan masukkan DDL ke dalam transaksi.
 */


 * ===============================================================
 * ❌ 3. PERINTAH YANG MENYEBABKAN IMPLICIT COMMIT
 * ---------------------------------------------------------------
 * ➤ Beberapa perintah tertentu memaksa transaksi untuk 
 *    melakukan COMMIT otomatis, di antaranya:
 *
 *    - SET AUTOCOMMIT = 1;
 *    - LOCK TABLES / UNLOCK TABLES;
 *    - CREATE INDEX
 *    - ANALYZE TABLE, CHECK TABLE, OPTIMIZE TABLE, REPAIR TABLE
 *
 * 📌 CONTOH:
 */
const contoh3 = `
START TRANSACTION;
INSERT INTO orders VALUES (100, 'tes');
SET AUTOCOMMIT = 1; -- 🔥 COMMIT OTOMATIS!
ROLLBACK; -- ❌ Tidak membatalkan
`;

 * ✅ SOLUSI:
 * Jangan ubah AUTOCOMMIT atau lock table di tengah transaksi.
 */


 * ===============================================================
 * ❌ 4. PERUBAHAN TERHADAP VARIABLE GLOBAL/SESSION
 * ---------------------------------------------------------------
 * ➤ Perubahan seperti:
 *    - SET GLOBAL ...
 *    - SET SESSION ...
 *    - SET NAMES ...
 * ➤ TIDAK termasuk dalam transaksi, tidak bisa dibatalkan
 *
 * 📌 CONTOH:
 */
const contoh4 = `
START TRANSACTION;
SET @user_id = 1;
ROLLBACK; -- ❌ @user_id tetap diset
`;

 * ✅ CATATAN:
 * Variabel bukan bagian dari data di tabel, jadi tidak dilindungi oleh transaksi.
 */

 * ===============================================================
 * ❌ 5. OPERASI EKSTERNAL (FILE SYSTEM / NETWORK / LOG)
 * ---------------------------------------------------------------
 * ➤ Fungsi-fungsi yang menulis ke luar MySQL (misal: file)
 *    tidak bisa di-rollback.
 *
 * 📌 CONTOH:
 *   - SELECT ... INTO OUTFILE
 *   - LOAD DATA INFILE
 *   - Logging ke sistem luar
 *
 * 📌 CONTOH:
 */
const contoh5 = `
START TRANSACTION;
SELECT * FROM users INTO OUTFILE '/tmp/users.csv';
ROLLBACK; -- ❌ File tetap ditulis ke disk
`;


 * ✅ CATATAN:
 * Segala sesuatu yang menyentuh luar database tidak bisa dibatalkan oleh transaksi.
 */

 * ===============================================================
 * KESIMPULAN
 * ===============================================================
 * 🔥 TIDAK SEMUA QUERY DI MYSQL BISA DILINDUNGI OLEH TRANSAKSI
 *
 * | Pengecualian               | Dapat di-Rollback? | Catatan                         |
 * |----------------------------|--------------------|----------------------------------|
 * | MyISAM / Non-InnoDB Engine | ❌ Tidak           | Semua query langsung permanen   |
 * | DDL (CREATE, DROP, ALTER)  | ❌ Tidak           | COMMIT otomatis                 |
 * | SET AUTOCOMMIT, LOCK       | ❌ Tidak           | Mengganggu transaksi aktif      |
 * | Variabel / SET SESSION     | ❌ Tidak           | Bukan bagian transaksi tabel    |
 * | Output file / Eksternal    | ❌ Tidak           | Operasi ke luar DB              |
 *
 * ✅ PASTIKAN kamu hanya menggunakan transaksi untuk operasi:
 *   - INSERT, UPDATE, DELETE
 *   - Pada tabel ENGINE = InnoDB
 *   - Tidak mencampur dengan DDL atau operasi luar sistem
 */





 * ➤ Transaction adalah **sekelompok operasi SQL (INSERT, UPDATE, DELETE)**
 *    yang dieksekusi **sebagai satu kesatuan**.
 * ➤ Jika semua operasi sukses, maka data akan **disimpan permanen (COMMIT)**
 * ➤ Jika salah satu gagal, maka semua akan **dibatalkan (ROLLBACK)**
 * ➤ Transaksi memastikan integritas data tetap terjaga.
 *
 * ===============================================================
 * 🧠 KONSEP DASAR: ACID
 * ---------------------------------------------------------------
 * Transaction mengikuti prinsip **ACID**, yaitu:
 * 
 * 1. **Atomicity**     → Semua atau tidak sama sekali
 * 2. **Consistency**   → Data tetap valid setelah transaksi
 * 3. **Isolation**     → Transaksi tidak saling mengganggu
 * 4. **Durability**    → Jika berhasil, data disimpan permanen
 *
 * ===============================================================
 * 📌 CARA KERJA TRANSACTION
 * ---------------------------------------------------------------
 * ➤ Transaction dibuka, kemudian beberapa operasi dilakukan.
 * ➤ Jika semua operasi berjalan lancar → COMMIT
 * ➤ Jika ada error → ROLLBACK untuk membatalkan semuanya
 *
 * ===============================================================
 * 📌 KENAPA HARUS PAKAI TRANSACTION?
 * ---------------------------------------------------------------
 * ✅ Untuk mencegah data rusak akibat error di tengah proses
 * ✅ Untuk menjaga data tetap konsisten dalam banyak operasi
 * ✅ Untuk sistem perbankan, inventory, pemesanan, dll
 * ✅ Untuk menghindari sebagian data tersimpan separuh (corrupt)
 *
 * ===============================================================
 * 📌 SYARAT: Tabel harus menggunakan engine InnoDB (bukan MyISAM)
 * ---------------------------------------------------------------
 * Gunakan ini untuk mengecek:
 * SHOW TABLE STATUS WHERE Name = 'nama_tabel';
 *
 * ===============================================================
 * 📌 STRUKTUR DASAR TRANSAKSI
 * ---------------------------------------------------------------
 * START TRANSACTION;
 *   ...query1...
 *   ...query2...
 *   ...query3...
 * COMMIT;          -- Simpan semua perubahan
 *
 * -- atau jika gagal:
 * ROLLBACK;        -- Batalkan semua perubahan
 */


 * ===============================================================
 * 📌 CONTOH PRAKTIS: TRANSFER UANG ANTAR AKUN
 * ===============================================================
 *
 * Tabel: accounts
 * +----+--------+--------+
 * | id | name   | balance|
 * +----+--------+--------+
 * | 1  | Alice  | 1000   |
 * | 2  | Bob    | 800    |
 * +----+--------+--------+
 *
 * Kasus: Alice transfer ke Bob sebesar 200
 */

const transaksiKeuangan = `
START TRANSACTION;

  -- 1. Kurangi saldo Alice
  UPDATE accounts
  SET balance = balance - 200
  WHERE name = 'Alice';

  -- 2. Tambah saldo Bob
  UPDATE accounts
  SET balance = balance + 200
  WHERE name = 'Bob';

COMMIT;
`;


 * 🔍 PENJELASAN:
 * - Jika kedua `UPDATE` berhasil → COMMIT akan simpan hasil
 * - Jika satu gagal (misalnya ID salah) → gunakan `ROLLBACK` untuk batalkan
 */


 * ===============================================================
 * 📌 CONTOH DENGAN ROLLBACK (Jika saldo tidak cukup)
 * ===============================================================
 */

const transaksiDenganCek = `
START TRANSACTION;

  -- Cek dulu saldo Alice
  SELECT balance INTO @saldo FROM accounts WHERE name = 'Alice';

  -- Jika saldo cukup
  -- Asumsikan pengecekan dilakukan di aplikasi atau stored procedure

  UPDATE accounts
  SET balance = balance - 500
  WHERE name = 'Alice';

  UPDATE accounts
  SET balance = balance + 500
  WHERE name = 'Bob';

COMMIT;

-- Jika pengecekan gagal:
-- ROLLBACK;
`;
 * 🔍 Di aplikasi, kamu akan cek apakah @saldo >= 500
 *    kalau tidak, maka panggil `ROLLBACK` sebelum `COMMIT`
 */


 * ===============================================================
 * 📌 TRANSACTION OTOMATIS VS MANUAL
 * ===============================================================
 * Secara default, MySQL menjalankan setiap query sebagai transaksi sendiri
 * (AUTO COMMIT = ON)
 *
 * ➤ Untuk mode manual:
 * SET autocommit = 0;
 * START TRANSACTION;
 * ...
 * COMMIT;
 *
 * ➤ Untuk mengaktifkan lagi:
 * SET autocommit = 1;
 */


 * ===============================================================
 * 📌 TRANSAKSI DALAM APLIKASI NODE.JS (SEKILAS)
 * ===============================================================
 * Gunakan driver seperti `mysql2/promise` atau ORM seperti `Sequelize`
 *
 * Contoh dengan mysql2:
 *
 * const connection = await pool.getConnection();
 * try {
 *   await connection.beginTransaction();
 *   await connection.query("UPDATE ...");
 *   await connection.query("UPDATE ...");
 *   await connection.commit();
 * } catch (err) {
 *   await connection.rollback();
 * }
 * connection.release();
 */

============================================================
 * ⚠️ PERHATIAN DAN BEST PRACTICES
 * ===============================================================
 * ✅ Pastikan semua query menggunakan engine InnoDB
 * ✅ Jangan lupa COMMIT, atau data tidak akan tersimpan
 * ✅ Gunakan ROLLBACK untuk menghindari data rusak
 * ✅ Tangani error dengan baik jika pakai dari aplikasi
 * ✅ Hindari menyimpan transaksi terlalu lama (lock database)
 */


 * ===============================================================
 * 📌 CONTOH LAIN: PENGHAPUSAN BERGANTUNG
 * ===============================================================
 * Hapus order dan semua item-nya dalam satu transaksi
 */

const hapusPesanan = `
START TRANSACTION;

  DELETE FROM order_items WHERE order_id = 100;
  DELETE FROM orders WHERE id = 100;

COMMIT;
`;


 * Jika penghapusan order_items gagal → batalkan penghapusan orders
 */

 * ===============================================================
 * KESIMPULAN
 * ===============================================================
 * 🔹 Transaction menjaga keutuhan dan keamanan data saat melakukan operasi kompleks
 * 🔹 Gunakan saat kamu punya lebih dari 1 query kritikal yang harus sukses semuanya
 * 🔹 Gunakan COMMIT untuk menyimpan, ROLLBACK untuk batalkan
 * 🔹 Transaksi sangat penting untuk sistem keuangan, e-commerce, banking, dll
 */



















