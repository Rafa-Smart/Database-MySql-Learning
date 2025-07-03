
-- tapi ketika kita alter table dan memasukan index, pada suatu table yg sudah banyak datanya
-- maka nanti akan berat, karena harus mengsinkronkan dulu untuk b-treenya
-- jadi matikan dulu aplikasinya baru add indexnya

-- ini untuk visualisasi
https://www.cs.usfca.edu/~galles/visualization/BTree.html

USE toko_online;
-- menampilkan data klom apa yg menggunakan index
SHOW indexes FROM customer;

jadi inituh perkolom indexnya, jadi bukan 1 table

-- dan juga mengoptimasi select dan juga order by
-- Mempercepat pencarian dan filter (WHERE, JOIN, ORDER BY, dsb)


-- jadi satu table itu bisa olomnya bisa ditambhakn index lebih dari satu


misal didalam TABLE customer saya ingin emncari DATA email agar lebih cepat
-- maka kita ibsa menambahkan index pada kolom email tersebut, dan pada kolom yg lainnya juga


-- nah tapi ketika kita mneggunakan index, maka nanti ketika kita insert atua manipulasi datanya akna lambat
-- karena ketika kita tambhakan 1 data, maka pohon nya akan berubah lagi strukturnya
-- makanya lama


-- cara buat index
-- ga bisa, karena index ga bsa ditaro setelah deklarasi tipe data
CREATE TABLE baru(
    id int,
    nama varchar(100) index
) ENGINE = innodb;

USE toko_online;
DESCRIBE baru;

CREATE TABLE baru(
    id int,
    nama varchar(100),
    INDEX nama_index (nama) -- nanit nama indexnya itu adalah nama kolomnya
)ENGINE = innodb;

SHOW indexes from baru;

DROP TABLE baru;

bisa juga gini

ALTER TABLE baru
ADD INDEX (nama);

-- ga bisa, jadi yg di pake itu nama indexnya, bukan nama kolomnya
-- nah untuk ngeliat nama indexnya apa, maka bis pake show indexes from baru
SHOW indexes FROM baru;
ALTER TABLE baru
DROP INDEX (nama);

-- nah jadi ketika dilihat ternyata nama index (mirip naa constraint) nya itu adlah
-- nama yg sama dengna nama tablenya jadi, gini cara hapusnya

ALTER TABLE baru
DROP INDEX nama;

DESCRIBE baru;

-- tpai kalo unique dan primary key, maka itu sudah otomatis emnggunakan index
-- jadi gaperlu


-- atau kalo mau buat kombinasi index
ALTER TABLE baru
ADD COLUMN nama3 varchar(100) NOT NULL;

ALTER TABLE baru
ADD INDEX (nama, nama2, nama3);
-- hasil, jadi ga bsia ita cari nama2, atau nama3 saja, jadi harus pake kombinasi
-- jadi kalo mau tambahkan lagi sendiri untuk yg nama2 dan nama3
id      int             NO      PRI     auto_increment
nama    varchar(100)    YES     MUL     
nama2   varchar(100)    NO          
nama3   varchar(100)    NO          

-- nah kalo begitu, berati kita bisa menggunakan fitur ndex ini pada nama, nama dan nama2, nama, nama2, dan nama3
-- tapi ga bisa kalo hanya nama2, atau nama3 saja, dan ga bisa nama3 dan nama2
-- jadi harus berurutan

ALTER TABLE baru
-- jadi kalo auto_increment itu harus pada primary key atau unique
MODIFY column id int NOT NULL PRIMARY KEY AUTO_INCREMENT;

DESCRIBE baru;
SELECT * FROM baru;

INSERT INTO baru (nama, nama2, nama3)
VALUES ('rafa', 'rafa2', 'rafa3');

ALTER TABLE baru
ADD INDEX (nama2);
ALTER TABLE baru
ADD INDEX (nama3);


| Kolom | Tipe         | Null | Key | Keterangan      |
| ----- | ------------ | ---- | --- | --------------- |
| id    | INT          | NO   | PRI | AUTO\_INCREMENT |
| nama  | VARCHAR(100) | YES  | MUL | Index otomatis  |
| nama2 | VARCHAR(100) | NO   | MUL | Index otomatis  |
| nama3 | VARCHAR(100) | NO   | MUL | Index otomatis  |
-- itu artinya kita hanya membuat index pada masing masing kolom sja, tidka untuk kombinasi
-- kalo mau kombinasi maka kita bisa pake cara

CREATE INDEX nama_index ON nama_table (nama, nama2, nama3);

-- single
CREATE TABLE baru2 (
    id int PRIMARY KEY AUTO_INCREMENT,
    nama varchar(100),
    nama2 varchar(100),
    nama3 varchar(100),
    INDEX (nama),
    INDEX (nama2),
    INDEX (nama3)
) ENGINE = innodb;

USE toko_online;
SHOW indexes FROM products;
EXPLAIN SELECT * FROM products;


composite
CREATE TABLE baru2 (
    id int PRIMARY KEY AUTO_INCREMENT,
    nama varchar(100),
    nama2 varchar(100),
    nama3 varchar(100),
    INDEX (nama,nama2,nama3)
) ENGINE = innodb;
-- atau bisa juga gini
CREATE INDEX idx_nama_nama2_nama3 ON baru (nama, nama2, nama3);
DROP TABLE baru2;


-- perbedaanya

🔹 SINGLE-COLUMN INDEX
-------------------------------------------
- Setiap index hanya mencakup 1 kolom saja.
- Contoh:
-- atau yg pas buat table di contoh, itu juga salah satu
-- contoh pembuatan index yg single
    CREATE INDEX idx_nama ON users(nama);
    CREATE INDEX idx_nama2 ON users(nama2);
    CREATE INDEX idx_nama3 ON users(nama3);

- Struktur index: 3 index terpisah → satu untuk masing-masing kolom.
- Dipercepat: Query berdasarkan 1 kolom saja (misalnya WHERE nama = 'A').
- Tidak efisien untuk query kombinasi (WHERE nama = 'A' AND nama2 = 'B') karena hanya satu index yang bisa digunakan, sisanya dilakukan sebagai filter biasa.
- Ukuran index lebih kecil.
- Tidak mengikuti prinsip Leftmost Prefix karena memang tidak berurutan antar kolom.

🔹 COMPOSITE INDEX
-------------------------------------------
- Satu index mencakup beberapa kolom dalam urutan tertentu.
- Contoh:
    CREATE INDEX idx_nama_nama2_nama3 ON users(nama, nama2, nama3);

- Struktur index: Gabungan dari kolom nama → nama2 → nama3.
- Dipercepat: Query berdasarkan gabungan kolom (misalnya WHERE nama = 'A' AND nama2 = 'B'), atau hanya kolom dari paling kiri.
- Tidak bisa digunakan jika pencarian hanya dari tengah atau belakang (misalnya WHERE nama2 = 'B').
- Ukuran index lebih besar karena menyimpan kombinasi kolom.
- Harus mengikuti prinsip Leftmost Prefix:
    ✅ WHERE nama = 'A'
    ✅ WHERE nama = 'A' AND nama2 = 'B'
    ❌ WHERE nama2 = 'B' saja (index tidak digunakan)

🔍 TABEL PERBANDINGAN

| Fitur                        | Single-Column Index                                 | Composite Index                                    |
| ----------------------------| --------------------------------------------------- | -------------------------------------------------- |
| Jumlah kolom dalam index     | 1 per index                                         | Beberapa kolom dalam 1 index                       |
| Struktur index               | Terpisah: nama, nama2, nama3                        | Gabungan: nama → nama2 → nama3                     |
| Kecepatan pencarian tunggal  | ✅ Cepat untuk 1 kolom                              | ✅ Cepat untuk kolom paling kiri                   |
| Kecepatan pencarian gabungan | ❌ Tidak efisien, pilih 1 index                     | ✅ Efisien untuk kombinasi kolom (multi filter)     |
| Prinsip leftmost-prefix      | ❌ Tidak berlaku                                    | ✅ Harus urut dari kiri ke kanan kolom index       |
| Ukuran index di disk         | Lebih kecil                                         | Lebih besar                                        |
| Cocok untuk                  | Query per kolom                                     | Query kombinasi kolom (WHERE kolom1 AND kolom2...) |

🧠 Tips:
- Gunakan Single-Column Index jika kamu hanya sering mencari berdasarkan satu kolom.
- Gunakan Composite Index jika kamu sering mencari berdasarkan kombinasi kolom (dengan urutan yang konsisten).
- Jangan terlalu banyak index → dapat memperlambat INSERT/UPDATE karena overhead maintenance index.



 *
 * 🔍 APA ITU COMPOSITE INDEX?
 * ------------------------------
 * Composite Index adalah index yang terdiri dari **lebih dari satu kolom**
 * dalam satu struktur index.
 *
 * Artinya, database akan menyusun dan menyimpan kombinasi beberapa kolom
 * untuk mempercepat pencarian, filter, atau pengurutan (ORDER BY)
 * berdasarkan kombinasi tersebut.
 *
 * 📌 Bentuk dasar:
 *    CREATE INDEX index_nama ON tabel (kolom1, kolom2, kolom3);
 *
 * ✅ Composite Index bisa mempercepat query yang memfilter berdasarkan:
 *    - kolom1
 *    - kolom1 + kolom2
 *    - kolom1 + kolom2 + kolom3
 *
 * ❌ Tapi tidak akan berguna jika query hanya menggunakan kolom2 atau kolom3 saja!
 *
 * 📢 Ini disebut prinsip **leftmost prefix**.
 *
 * ------------------------------------------------
 * 🔧 CONTOH PRAKTIS & PENJELASAN DETAIL
 * ------------------------------------------------
 */

/// SQL: Membuat tabel dengan composite index
/*
CREATE TABLE orders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  status ENUM('pending', 'paid', 'shipped'),
  created_at DATETIME,

  -- Index gabungan: customer_id dan status
  INDEX idx_cust_status (customer_id, status)
);
*/

/// Penjelasan:
/// - Index ini menyimpan kombinasi (customer_id, status)
/// - Data disusun secara urut berdasarkan customer_id lalu status

/**
 * -------------------------------------------
 * 🧠 BAGAIMANA CARA KERJA COMPOSITE INDEX?
 * -------------------------------------------
 *
 * ➕ Jika kita buat:
 *    INDEX (A, B, C)
 *
 * Maka MySQL membuat struktur pohon (B-Tree) urut berdasarkan A → B → C.
 * Setiap node menyimpan nilai A, lalu dalam A diurutkan B, lalu C.
 *
 * 💡 Maka query yang optimal adalah:
 * - WHERE A
 * - WHERE A AND B
 * - WHERE A AND B AND C
 *
 * ❌ Tapi jika hanya WHERE B → index **tidak akan digunakan secara optimal**
 * ❌ Juga jika hanya WHERE C → akan full scan
 *
 * ➕ ORDER BY juga akan dioptimalkan kalau kolom dalam ORDER BY sesuai urutan index
 *
 * -------------------------------------------
 * 📈 CONTOH PENGGUNAAN COMPOSITE INDEX
 * -------------------------------------------
 */

/// Data contoh:
/// | id | customer_id | status   | created_at          |
/// |----|-------------|----------|---------------------|
/// | 1  | 1           | pending  | 2024-01-01 08:00:00 |
/// | 2  | 1           | shipped  | 2024-01-02 08:00:00 |
/// | 3  | 2           | paid     | 2024-01-03 08:00:00 |

/// Contoh 1 (Menggunakan Index):
/*
SELECT * FROM orders
WHERE customer_id = 1;
-- ✅ Menggunakan index (karena sesuai kolom pertama)
*/

/// Contoh 2 (Menggunakan Index):
/*
SELECT * FROM orders
WHERE customer_id = 1 AND status = 'shipped';
-- ✅ Menggunakan index (karena sesuai kolom pertama dan kedua)
*/

/// Contoh 3 (Menggunakan Index):
/*
SELECT * FROM orders
WHERE customer_id = 1 AND status = 'paid'
ORDER BY created_at DESC;
-- ✅ Bisa efisien jika ada composite index tambahan (customer_id, status, created_at)
*/

/// Contoh 4 (TIDAK menggunakan index):
/*
SELECT * FROM orders
WHERE status = 'paid';
-- ❌ Index idx_cust_status tidak digunakan karena kolom pertama (customer_id) tidak disebut
*/

/// Contoh 5 (TIDAK menggunakan index):
/*
SELECT * FROM orders
WHERE status = 'shipped' AND customer_id = 1;
-- ✅ Tetap bisa pakai index, karena WHERE masih menyertakan kolom pertama
-- urutan WHERE tidak masalah, yang penting struktur index tetap dari kolom pertama
*/

/**
 * --------------------------------------
 * 🎯 PRINSIP PENTING: LEFTMOST PREFIX
 * --------------------------------------
 * INDEX (A, B, C)
 *
 * Query yang optimal:
 * ✅ WHERE A
 * ✅ WHERE A AND B
 * ✅ WHERE A AND B AND C
 *
 * ❌ WHERE B
 * ❌ WHERE C
 * ❌ WHERE B AND C
 *
 * ❗ Karena Index akan mulai dari kiri (leftmost)
 */

/**
 * -----------------------------------------
 * 🛠 BEST PRACTICE COMPOSITE INDEX DI INDUSTRI
 * -----------------------------------------
 * ✅ Gunakan composite index jika:
 *   - Query kamu sering menggunakan kombinasi kolom tertentu di WHERE/JOIN/ORDER BY
 *   - Kombinasi kolom itu selalu berurutan dari kolom kiri
 *
 * ✅ Untuk pencarian umum:
 *   - INDEX (email, status)
 *
 * ✅ Untuk pengurutan dan filter:
 *   - INDEX (customer_id, created_at)
 *
 * ✅ Untuk analisis waktu:
 *   - INDEX (status, created_at)
 *
 * ❌ Hindari index seperti INDEX (A, B) jika kamu hanya sering query WHERE B saja.
 *
 * ----------------------------------------
 * 📍 CEK APAKAH QUERY GUNAKAN INDEX?
 * ----------------------------------------
 * Gunakan:
 *   EXPLAIN SELECT ...
 * Lihat kolom `key` dan `Extra` apakah pakai "Using index"
 */

/**
 * ✅ KESIMPULAN AKHIR
 * -------------------------------
 * 🔹 Composite index adalah index dengan lebih dari 1 kolom.
 * 🔹 Digunakan untuk mempercepat query yang menyaring/menyortir berdasarkan kombinasi kolom.
 * 🔹 Ikuti prinsip **leftmost prefix**: index hanya efektif jika query menggunakan kolom dari kiri ke kanan.
 * 🔹 Gunakan EXPLAIN untuk memastikan query kamu benar-benar menggunakan index.
 * 🔹 Composite index sangat berguna dalam pengembangan sistem skala besar.
 */



 *
 * 🔍 APA ITU INDEX?
 * ------------------
 * INDEX (indeks) adalah struktur data khusus dalam database yang digunakan untuk
 * **mempercepat proses pencarian (query)** terhadap kolom tertentu pada tabel.
 *
 * Cara kerjanya mirip seperti indeks di buku — kamu bisa langsung menuju halaman
 * yang berisi kata tertentu, tanpa membaca dari halaman 1.
 *
 * ➕ Tanpa index = pencarian dilakukan secara **full scan** (baris demi baris).
 * ✅ Dengan index = pencarian lebih cepat, karena DBMS tahu di mana lokasi datanya.
 *
 * -------------------------------
 * 📌 MENGAPA KITA PERLU INDEX?
 * -------------------------------
 * ✅ Mempercepat pencarian dan filter (WHERE, JOIN, ORDER BY, dsb).
 * ✅ Menurunkan beban server saat query terhadap tabel besar.
 * ✅ Meningkatkan performa SELECT, terutama di tabel dengan ribuan bahkan jutaan baris.
 *
 * ❗TAPI...
 * ❌ Index bisa memperlambat proses INSERT, UPDATE, dan DELETE.
 * ❌ Index memakan ruang disk tambahan (bisa signifikan).
 * ❗ Maka, gunakan index dengan BIJAK dan sesuai kebutuhan.
 *
 * -------------------------------
 * ⚙️ CARA KERJA INDEX SECARA TEKNIS
 * -------------------------------
 * MySQL (InnoDB) biasanya menggunakan **B-Tree Index**.
 * - B-Tree menyimpan data secara urut dan memungkinkan pencarian secara logaritmik.
 * - Index menyimpan **nilai kolom tertentu + pointer** ke lokasi baris lengkap di tabel.
 *
 * 🎯 Misalnya: Kamu punya kolom `email`, dan sering melakukan:
 *    SELECT * FROM users WHERE email = 'abc@email.com';
 * Maka, membuat index pada kolom `email` akan sangat membantu.
 *
 * ----------------------------------------
 * 🧱 TIPE-TIPE INDEX DI MySQL (PENTING!)
 * ----------------------------------------
 * 1. ✅ PRIMARY KEY
 *    - Index unik utama untuk tabel.
 *    - Tidak boleh NULL dan harus unik.
 *    - Hanya boleh SATU per tabel.
 *
 * 2. ✅ UNIQUE INDEX
 *    - Index yang menjamin nilai kolom tidak duplikat.
 *    - Boleh ada lebih dari satu dalam satu tabel.
 *
 * 3. ✅ INDEX / NORMAL INDEX
 *    - Index biasa tanpa syarat keunikan.
 *    - Digunakan untuk percepat pencarian/filter/sort.
 *
 * 4. ✅ COMPOSITE INDEX
 *    - Index gabungan dari beberapa kolom sekaligus.
 *    - Efektif untuk pencarian kombinasi kolom (misal: `WHERE email AND status`)
 *
 * 5. ✅ FULLTEXT INDEX
 *    - Untuk pencarian teks bebas (MATCH AGAINST)
 *    - Cocok untuk artikel, berita, deskripsi panjang.
 *    - Hanya didukung untuk tipe teks: CHAR, VARCHAR, TEXT.
 *
 * 6. ✅ SPATIAL INDEX
 *    - Digunakan untuk kolom bertipe geometri (GIS), misalnya `POINT`, `LINESTRING`.
 *
 * -------------------------------
 * 🔧 CONTOH PENGGUNAAN INDEX
 * -------------------------------
 */

/// Membuat tabel dengan INDEX
/*
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nama VARCHAR(100),
  email VARCHAR(100),
  status ENUM('aktif', 'nonaktif'),
  created_at DATETIME,

  -- Index biasa di kolom email
  INDEX idx_email (email),

  -- Index unik agar email tidak boleh sama
  UNIQUE INDEX unq_email (email),

  -- Index gabungan
  INDEX idx_email_status (email, status)
);
*/

/// Menambahkan index ke tabel yang sudah ada
/*
ALTER TABLE users
ADD INDEX idx_created (created_at);
*/

/// Menghapus index dari tabel
/*
ALTER TABLE users
DROP INDEX idx_created;
*/

/// Melihat semua index di tabel
/*
SHOW INDEXES FROM users;
*/

/// Query yang akan menggunakan index
/*
SELECT * FROM users WHERE email = 'abc@email.com';
SELECT * FROM users WHERE email = 'a' AND status = 'aktif';
SELECT * FROM users ORDER BY created_at DESC;
*/

/// ⚠ Performa query sebelum dan sesudah index bisa diuji dengan:
/// EXPLAIN SELECT ... (lihat apakah pakai "Using index")

/**
 * -----------------------------------------
 * 🚨 KAPAN JANGAN MENGGUNAKAN INDEX?
 * -----------------------------------------
 * ❌ Kolom dengan jumlah nilai yang sangat sedikit (low cardinality), misalnya:
 *    kolom `jenis_kelamin` dengan hanya dua nilai (L/P) — index jadi tidak efektif.
 *
 * ❌ Kolom yang sangat sering diupdate (akan memberatkan karena index harus ikut update).
 *
 * ❌ Jika ukuran tabel kecil (< 100 baris), index tidak terlalu terasa manfaatnya.
 *
 * -----------------------------------------
 * 🔍 CATATAN TENTANG COMPOSITE INDEX
 * -----------------------------------------
 * Jika kamu membuat index:
 *    INDEX (email, status)
 *
 * Maka:
 * ✅ Akan dipakai untuk query:
 *    WHERE email = 'abc' AND status = 'aktif'
 * ✅ Akan dipakai untuk query:
 *    WHERE email = 'abc'
 * ❌ TIDAK efektif untuk query:
 *    WHERE status = 'aktif'
 *
 * Urutan dalam index composite SANGAT penting!
 *
 * --------------------------------------------
 * 🛠 BEST PRACTICES INDEX DALAM INDUSTRI
 * --------------------------------------------
 * ✅ Index kolom yang sering dipakai di:
 *    - WHERE
 *    - JOIN ON
 *    - ORDER BY
 *    - GROUP BY
 *
 * ✅ Gunakan EXPLAIN untuk memantau apakah query menggunakan index.
 *
 * ✅ Selalu beri nama index yang bermakna: `idx_nama`, `unq_email`, dsb.
 *
 * ✅ Hindari terlalu banyak index — karena akan memperlambat INSERT/UPDATE dan membebani disk.
 *
 * ✅ Hindari index pada kolom BLOB atau TEXT, kecuali menggunakan FULLTEXT.
 */

/**
 * ✅ KESIMPULAN
 * -------------------------------
 * INDEX adalah alat krusial untuk optimasi performa query di MySQL.
 * Tapi harus digunakan dengan bijak:
 * - Gunakan saat memang butuh kecepatan pencarian/filter.
 * - Hindari over-indexing.
 * - Gunakan tipe index yang tepat sesuai kebutuhan: PRIMARY, UNIQUE, COMPOSITE, FULLTEXT, dll.
 *
 * Pahami struktur data dan pola query-mu agar bisa memanfaatkan index secara optimal.
 */





