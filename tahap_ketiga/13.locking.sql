

-- tolong baca seluruh penjelasan ini


-- Locking (penguncian) adalah mekanisme untuk **mengontrol akses
-- ke data** saat sedang dibaca atau dimodifikasi.
-- Tujuannya: agar **tidak terjadi konflik atau inkonsistensi**
-- bketika beberapa user/client melakukan operasi secara bersamaan.

-- karena pada kenyataannya didunia kerja
-- aplikasi yang kita buat past akna digunakan oleh banyak pengguna, dan banyaknya pengugna tersebut bisa saja 
-- akan mnegakses data yang sama secara bersamaan, jika tidak ada proses locking
-- maka bisa dipastikan akn terjadi race condition, yaitu proses balapan ketika mengubah data yang sama

-- contoh saja, ketika kita belanja di toko online, kita akn balapan membeli barang yang sama , jika
-- data yang dibeli tidak dijaga, maka bisa saja user 1 sudah mengubah data quantitynya menjadi 0 
-- yang seharusnya sudah tidak bsia lagi dibeli
-- tapi secar bersamaan ada user 2 yang juga mengurangi quanitynya untuk belanja
-- maka ini masalah 


1. locking record / otomatis lock
-- jadi saat kita melakukan transaction, lalu kita melakukan proses perubahan data, maka data
-- yang ktia ubah itu secar otomatis di lock
-- jadi ga bisa di ubah ubah oleh user lain

-- jadi ketika kita (user 1) melakukan transaksi, ketika ada user lain yang melakukan perubahan data 
-- pada data yang sama, maka akn di suruh tunggu / blok
-- sampai proses transaksi yang dilakukan oleh user 1 selesai

SELECT * FROM guestbook;

USE toko_online;
START TRANSACTION;

DELETE FROM guestbook
WHERE id = 1;

ROLLBACK;
-- nah jadi ketika ada user yang mencoba mengunubah
-- data yg sama maka akn disuruh nunggu
-- sampai kia melakukan commit atau rollback


ini ketika saya ingin DELETE di terminal
jadi berhasil setelah 31.79 detik
-- mysql> delete from guestbook
--     -> where id = 1;
-- Query OK, 1 row affected (31.79 sec)
-- 
-- mysql>

-- jadi proses penghapusan data yg idnya satu dan 2 sudah bsia dilakukan
-- oleh user 2 di terminal
-- sekrang data dgn id 1 dan 2 berhasil terhapus


-- nah dengna ini , kita bsia mengatur jadi tidak rebutan
-- ketika ingin mengubah data yang sama
-- jadi harus gantian

















 * ➤ Locking (penguncian) adalah mekanisme untuk **mengontrol akses
 *    ke data** saat sedang dibaca atau dimodifikasi.
 * ➤ Tujuannya: agar **tidak terjadi konflik atau inkonsistensi**
 *    ketika beberapa user/client melakukan operasi secara bersamaan.
 *
 * ===============================================================
 * 📦 KENAPA HARUS MENGGUNAKAN LOCKING?
 * ---------------------------------------------------------------
 * ✅ Menjaga konsistensi data dalam transaksi multi-user
 * ✅ Mencegah dua transaksi mengubah data yang sama secara bersamaan
 * ✅ Mencegah lost updates, dirty reads, phantom reads
 * ✅ Meningkatkan kontrol terhadap urutan eksekusi transaksi
 *
 * ===============================================================
 * 🧠 CARA KERJA LOCKING DI MYSQL
 * ---------------------------------------------------------------
 * ➤ MySQL akan melakukan **locking otomatis** saat transaksi berjalan.
 * ➤ Tipe penguncian tergantung jenis query dan storage engine.
 *
 * Ada dua jenis utama:
 * 1. **Implicit Lock (Otomatis)**  → dilakukan oleh MySQL sendiri
 * 2. **Explicit Lock (Manual)**    → kamu bisa kunci data secara langsung
 */


 * ===============================================================
 * 🔐 JENIS-JENIS LOCKING DI MYSQL
 * ===============================================================
 *
 * 🔸 TABLE-LEVEL LOCKING (Kunci Seluruh Tabel)
 *   - Menutup akses seluruh tabel untuk baca/tulis
 *   - Digunakan oleh engine seperti MyISAM
 *
 * 🔸 ROW-LEVEL LOCKING (Kunci Baris)
 *   - Mengunci hanya baris tertentu
 *   - Digunakan oleh engine InnoDB
 *
 * 🔸 PAGE-LEVEL LOCKING (jarang di MySQL)
 *   - Mengunci sekumpulan baris (halaman disk)
 *
 * ➤ MySQL (InnoDB) umumnya menggunakan **row-level locking**
 */


 * ===============================================================
 * 🔒 TABLE LOCK (KUNCI TABEL MANUAL)
 * ---------------------------------------------------------------
 * ➤ LOCK TABLE digunakan untuk mengunci tabel secara manual
 * ➤ Dua mode:
 *   - READ → hanya bisa baca (user lain juga bisa baca)
 *   - WRITE → hanya 1 user bisa baca/tulis (eksklusif)
 *
 * 📌 CONTOH:
 */
const tableLockExample = `
LOCK TABLES accounts WRITE;

-- lakukan perubahan
UPDATE accounts SET balance = balance - 100 WHERE id = 1;

UNLOCK TABLES;
`;


 * 🔍 Penjelasan:
 * - Saat LOCK WRITE, hanya koneksi ini yang bisa akses tabel `accounts`
 * - Koneksi lain akan menunggu sampai UNLOCK dilakukan
 */


 * ===============================================================
 * 🔒 ROW LOCK (KUNCI BARIS - OTOMATIS)
 * ---------------------------------------------------------------
 * ➤ InnoDB secara otomatis mengunci baris saat query UPDATE/DELETE
 * ➤ Lock hanya berlaku untuk baris yang relevan
 *
 * 📌 CONTOH:
 */
const rowLockExample = `
START TRANSACTION;

UPDATE accounts
SET balance = balance - 100
WHERE id = 1;

-- baris dengan id=1 dikunci sampai COMMIT atau ROLLBACK

COMMIT;
`;


 * 🔍 Penjelasan:
 * - Transaksi lain yang ingin mengakses baris `id=1` akan menunggu
 * - Sangat efisien karena tidak mengunci seluruh tabel
 */


 * ===============================================================
 * ⚠️ DEADLOCK — MASALAH UMUM LOCKING
 * ---------------------------------------------------------------
 * Deadlock terjadi saat dua transaksi saling menunggu lock
 * yang dipegang oleh transaksi lain, sehingga keduanya tidak bisa lanjut.
 *
 * 📌 CONTOH:
 * Transaksi A: lock baris 1, tunggu baris 2
 * Transaksi B: lock baris 2, tunggu baris 1 → DEADLOCK
 *
 * ✅ MySQL akan mendeteksi dan membatalkan salah satu transaksi
 *
 * 📌 TIPS MENGHINDARI DEADLOCK:
 * - Akses tabel dan baris dalam urutan yang sama
 * - Buat transaksi sependek mungkin
 * - Gunakan indeks untuk mencegah lock luas
 */


 * ===============================================================
 * 🔁 LOCKING DENGAN SELECT ... FOR UPDATE
 * ---------------------------------------------------------------
 * ➤ `SELECT ... FOR UPDATE` akan mengunci baris yang dibaca
 *    agar transaksi lain tidak bisa mengubahnya
 * ➤ Hanya berlaku di dalam transaksi (InnoDB)
 *
 * 📌 CONTOH:
 */
const forUpdateExample = `
START TRANSACTION;

SELECT * FROM accounts
WHERE id = 1
FOR UPDATE;

-- sekarang baris dengan id=1 terkunci sampai COMMIT

UPDATE accounts SET balance = balance - 100 WHERE id = 1;

COMMIT;
`;


 * 🔍 Penjelasan:
 * - `FOR UPDATE` sangat cocok untuk sistem keuangan, inventory, dll
 * - Hanya berlaku untuk SELECT dalam transaksi
 */


 * ===============================================================
 * 🔍 PERBANDINGAN: TABLE LOCK VS ROW LOCK
 * ===============================================================
 *
 * | Fitur               | Table Lock         | Row Lock (InnoDB)     |
 * |---------------------|--------------------|------------------------|
 * | Ruang lingkup       | Seluruh tabel      | Hanya baris tertentu   |
 * | Efisiensi           | Kurang efisien     | Lebih efisien          |
 * | Risiko blocking     | Tinggi             | Lebih rendah           |
 * | Engine              | MyISAM, MEMORY     | InnoDB (default MySQL) |
 * | Lock otomatis       | Tidak              | Ya                     |
 * | Kontrol manual      | Ya (LOCK TABLES)   | Ya (FOR UPDATE)        |
 */


 * ===============================================================
 * 🧠 BEST PRACTICES UNTUK LOCKING
 * ===============================================================
 * ✅ Gunakan transaksi pendek (cepat COMMIT)
 * ✅ Gunakan `SELECT ... FOR UPDATE` hanya jika perlu
 * ✅ Gunakan index agar query tidak mengunci terlalu banyak baris
 * ✅ Hindari mixing table-level lock dan row-level lock
 * ✅ Periksa deadlock dengan SHOW ENGINE INNODB STATUS
 * ✅ Gunakan LOCK hanya saat dibutuhkan (default MySQL sudah cukup aman)
 */


 * ===============================================================
 * KESIMPULAN
 * ===============================================================
 * 🔹 Locking adalah sistem pengamanan data saat diakses oleh banyak user
 * 🔹 Mencegah konflik dan menjaga integritas transaksi
 * 🔹 Terdapat implicit lock (otomatis) dan explicit lock (manual)
 * 🔹 Locking sangat penting untuk sistem sensitif seperti banking, e-commerce
 * 🔹 Waspadai DEADLOCK dan selalu buat transaksi seefisien mungkin
 */















-- test
-- test
-- test
-- test
-- test
-- test