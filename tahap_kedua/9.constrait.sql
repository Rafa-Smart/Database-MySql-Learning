
-- oenting, jadi ada beberapa constriant yg ga bisa tidambhakan menggunkana add constraint
-- dan juga ga bisa di kasih nama

| Jenis Constraint | Bisa Diberi Nama? | Dimasukkan via `ADD CONSTRAINT`? |
| ---------------- | ----------------- | -------------------------------- |
| `PRIMARY KEY`    | ✅ Bisa            | ✅ Ya                             |
| `UNIQUE`         | ✅ Bisa            | ✅ Ya                             |
| `FOREIGN KEY`    | ✅ Bisa            | ✅ Ya                             |
| `CHECK`          | ✅ Bisa            | ✅ Ya                             |

| Fitur            | Apakah Constraint? | Bisa Dinamai? | Ditambahkan via `CONSTRAINT`? |
| ---------------- | ------------------ | ------------- | ----------------------------- |
| `NOT NULL`       | ❌ Bukan            | ❌ Tidak bisa  | ❌ Tidak bisa                  |
| `DEFAULT`        | ❌ Bukan            | ❌ Tidak bisa  | ❌ Tidak bisa                  |
| `AUTO_INCREMENT` | ❌ Bukan            | ❌ Tidak bisa  | ❌ Tidak bisa                  |


--  lihat nih
-- JIKA BERDASARKAN SQL 
| Nama          | Termasuk Constraint? | Bisa Dinamai? |
| ------------- | -------------------- | ------------- |
| `PRIMARY KEY` | ✅ Ya                 | ✅ Bisa        |
| `UNIQUE`      | ✅ Ya                 | ✅ Bisa        |
| `FOREIGN KEY` | ✅ Ya                 | ✅ Bisa        |
| `CHECK`       | ✅ Ya                 | ✅ Bisa        |
| `NOT NULL`    | ✅ Ya                 | ✅ Bisa        |
| `DEFAULT`     | ✅ Ya (secara konsep) | ✅ Bisa        |


-- BERDASARKAN MYSQL
| Bisa Dinamai di MySQL | Constraint       |
| --------------------- | ---------------- |
| ✅                     | `PRIMARY KEY`    |
| ✅                     | `UNIQUE`         |
| ✅                     | `FOREIGN KEY`    |
| ✅ (MySQL 8.0+)        | `CHECK`          |
| ❌                     | `NOT NULL`       |
| ❌                     | `DEFAULT`        |
| ❌                     | `AUTO_INCREMENT` |



jadi CONSTRAINT ini berfngsi uuntuk validasi
misal validasi bahwa kolom ini tidak boleh ganda, berati constraintnya UNIQUE

-- jadi kalo misalkan ada 2 data yg sama di kolom yg sudah kita ocnstrrain bahwa
--kolom itu harus uniq, maka akan error 

use toko_online;

DESCRIBE products;

jadi ketika kita buat tabel maka kita bisa menambahkan constraintnya

CREATE TABLE products (
--     id int PRIMARY KEY AUTO_INCREMENT, -- bisa juga inline seperti ini
    id int AUTO_INCREMENT, 
    email varchar(100) NOT NULL,
    first_name varchar(100) NOT NULL,
    lastname varchar(100) NOT NULL,
    -- nah disini kita akn tambhakan constraint
    CONSTRAINT id_primary PRIMARY key (id),
    CONSTRAINT email_unique UNIQUE  (email)
    -- nah  ketika kita inign membuat sebuah constraint
    -- maka kita harus memberikan nama constriantnya
    -- atau kalo lebih mudahnya itu kita harus memberikan nama oenaganya
    -- jadi nanti kalo ada data yg duplikat (jika pake unique) 
    -- maka nanti ada penjaga namnaya email_unique yg akan menolaknya
)

    -- Jadi nanti ketika ada data yang duplikat (dalam kolom email)
    -- maka "penjaga" yang bernama email_unique akan menolaknya

CREATE TABLE customer (
    id int AUTO_INCREMENT, 
    email varchar(100) NOT NULL,
    first_name varchar(100) NOT NULL,
    lastname varchar(100) NOT NULL,
    CONSTRAINT id_primary PRIMARY KEY (id),
    CONSTRAINT email_unique UNIQUE (email)
) ENGINE = innodb;

DROP TABLE customer;
-- bisa juga seperti ini
CREATE TABLE customer (
    id int AUTO_INCREMENT PRIMARY key, 
    email varchar(100) NOT NULL,
    first_name varchar(100) NOT NULL,
    lastname varchar(100) NOT NULL,
    UNIQUE KEY (email)
    -- nah kalo kita ga pake nama constraintnya atau penjaganya
    -- maka artinya secara default sudah diberi nama tai terserah si mysqlnya
    
) ENGINE = innodb;

-- atau ketika sudah dibuat maka kita bisa menambhakan constrainnya di alter table

-- dan penamaan penjaga / constraint ini tidak bisa menggunakan string apapun

ALTER TABLE customer
ADD CONSTRAINT email_unique UNIQUE (email);

ALTER TABLE customer
ADD CONSTRAINT id_primary PRIMARY key (id);


-- atua kalo mau menghapus constraint

ALTER TABLE customer
DROP PRIMARY key;

ALTER TABLE customer
DROP CONSTRAINT email_unique;
-- bisa juga gini, kalo yg constraint selain dari primary key
ALTER TABLE customer
DROP INDEX email_unique; -- nama constrainnya
-- atau bisa juga


DESCRIBE customer;


ALTER TABLE customer
ALTER COLUMN first_name SET DEFAULT "nama_awal";

-- atau bisa juga seperti ini

ALTER TABLE customer
MODIFY last_name varchar(200) DEFAULT "nama_akhir";


-- jadi ini ga bisa ya, karnea auto_increment ga bisa dinamai
- jaid cara kita unutk menambhkannya itu menggunkaan ALTER table
ALTER TABLE customer
ADD CONSTRAINT autoIncrementC auto_increment (id);

ALTER TABLE customer
MODIFY COLUMN id int AUTO_INCREMENT NOT null;

-- nah disini coba kita akn insert data

INSERT INTO customer (email, first_name, last_name)
VALUES ('rafaEmail', 'rafa', 'khadafi');

INSERT INTO customer (email, first_name, last_name)
VALUES ('jamalEmail', 'jamal', 'istiqomah'),
       ('sitiEmail', 'siti', 'maimunah');

-- disini coba kita tambahkan dat yg duplikat di emailnya(harusnya ditolak sama si penjaga email_unique)
INSERT INTO customer (email, first_name, last_name)
VALUES ('jamalEmail', 'jamal', 'istiqomah');
--  Duplicate entry 'jamalEmail' for key 'customer.email_unique'

-- dan ketika kita ining menmabhakan lagi
INSERT INTO customer (email, first_name, last_name)
VALUES ('udinEmail', 'udin', 'Sidiq');
-- nah ketika kita menambhakan data ini setelah tadi kita berusaha menambhakan data yg gagal karena duplikat
-- idnya akan tetap nambah, jadi sebenarnya
-- idnya itu akna digenerete dulu, baru ditambahkan
-- nah tapi karena gagal ditambahkan maka idnya tetap ditambahkan
-- jadinya untuk data berikutnya dimulai dengna 5, bukan 4
-- karena 4 itu adalah id yg ggal ditambahkan

-- jika di innodb saja

SELECT * FROM customer;

🔑 1. PRIMARY KEY
------------------

ALTER table customer
DROP lastname;

ALTER TABLE customer
ADD COLUMN last_name varchar(100) AFTER first_name;

✅ Pengertian:
PRIMARY KEY adalah kolom (atau kombinasi beberapa kolom) yang digunakan untuk 
mengidentifikasi setiap baris secara **unik** dalam sebuah tabel.

👉 Hanya **satu PRIMARY KEY** yang diperbolehkan dalam satu tabel.

✅ Ciri-ciri PRIMARY KEY:
| Fitur                 | Penjelasan                                                                 |
|-----------------------|----------------------------------------------------------------------------|
| Unik                  | Nilai tidak boleh duplikat                                                |
| Tidak Boleh NULL      | Wajib memiliki nilai (NOT NULL)                                           |
| Hanya Satu per Tabel  | Tidak bisa memiliki lebih dari satu PRIMARY KEY                           |
| Index Otomatis        | Secara otomatis membuat index clustered (utama)                           |
| Digunakan untuk relasi| Sering dipakai sebagai acuan FOREIGN KEY di tabel lain                    |

✅ Contoh Penggunaan:
CREATE TABLE users (
    id INT PRIMARY KEY,
    username VARCHAR(100),
    email VARCHAR(100)
);


🔐 2. UNIQUE
-------------

✅ Pengertian:
UNIQUE digunakan untuk memastikan bahwa nilai dalam kolom (atau kombinasi kolom)
tetap unik, **namun bukan sebagai kunci utama (primary)**.

👉 Satu tabel bisa memiliki **lebih dari satu UNIQUE constraint.**

✅ Ciri-ciri UNIQUE:
| Fitur                 | Penjelasan                                                                 |
|-----------------------|----------------------------------------------------------------------------|
| Unik                  | Nilai tidak boleh duplikat                                                |
| Boleh NULL            | Nilai boleh NULL (bahkan bisa beberapa NULL tergantung versi MySQL)       |
| Bisa Lebih dari Satu  | Bisa menambahkan beberapa UNIQUE constraint di satu tabel                 |
| Validasi Data         | Sering dipakai untuk menjaga agar data penting tidak ganda (email, NIK, dsb)|

✅ Contoh Penggunaan:
CREATE TABLE users (
    id INT PRIMARY KEY,
    username VARCHAR(100) UNIQUE,
    email VARCHAR(100) UNIQUE
);


📌 Perbandingan PRIMARY KEY vs UNIQUE:

| Aspek                  | PRIMARY KEY                          | UNIQUE                                 |
|------------------------|---------------------------------------|----------------------------------------|
| Tujuan                 | Identifikasi unik baris               | Validasi nilai unik                    |
| Jumlah per tabel       | Hanya satu                            | Bisa lebih dari satu                   |
| NULL                   | Tidak boleh NULL                      | Boleh NULL (tergantung versi)          |
| Index Otomatis         | Ya (clustered index)                  | Ya (non-clustered index)               |
| Relasi antar tabel     | Ya, digunakan dalam FOREIGN KEY       | Jarang digunakan untuk relasi tabel    |

🛠️ Studi Kasus Nyata:
- `id` → PRIMARY KEY (karena digunakan untuk identifikasi unik baris)
- `email`, `username` → UNIQUE (karena tidak boleh ganda meskipun bukan kunci utama)

Contoh kombinasi:
CREATE TABLE accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE,
    username VARCHAR(100) UNIQUE,
    password VARCHAR(255) NOT NULL
);


💡 Composite Unique:
Digunakan saat dua kolom atau lebih harus unik **dalam kombinasi**, misalnya:

CREATE TABLE orders (
    user_id INT,
    product_id INT,
    quantity INT,
    UNIQUE (user_id, product_id)
);

👉 Artinya: Satu user hanya boleh memesan produk yang sama **satu kali**.







 * ---------------------------------------------------------------
 * Constraint adalah aturan yang ditetapkan pada kolom (field) dalam tabel
 * untuk membatasi atau memvalidasi jenis data yang bisa masuk.
 *
 * Tujuannya adalah:
 * ✅ Menjaga integritas data (data tetap valid dan konsisten)
 * ✅ Mencegah kesalahan input
 * ✅ Mengontrol hubungan antar tabel
 *
 * ================================================================
 *             1. DAFTAR JENIS CONSTRAINT DI MYSQL
 * ================================================================
 *
 * ✅ NOT NULL         → Melarang kolom bernilai NULL
 * ✅ UNIQUE           → Menjamin nilai di kolom harus unik (tidak duplikat)
 * ✅ PRIMARY KEY      → Gabungan NOT NULL + UNIQUE + penanda baris utama
 * ✅ FOREIGN KEY      → Hubungkan kolom dengan kolom di tabel lain
 * ✅ CHECK            → Validasi nilai kolom berdasarkan ekspresi logika
 * ✅ DEFAULT          → Memberikan nilai default otomatis jika tidak diisi
 *
Aspek           Fungsi
NOT NULL        Menjamin bahwa setiap baris memiliki nilai kunci yang valid
UNIQUE          Menjamin bahwa tidak ada duplikat dalam kolom kunci
Penanda         Bertindak sebagai identitas utama untuk baris (digunakan dalam relasi dan index)
 * ================================================================
 *        2. CARA PENULISAN CONSTRAINT DI CREATE TABLE
 * ================================================================
 *
 * ➤ Ada dua cara:
 * - Inline constraint (di dalam definisi kolom)
 * - Table-level constraint (setelah semua kolom dideklarasikan)
 *
 * Contoh:
 * CREATE TABLE pelanggan (
 *   id INT PRIMARY KEY AUTO_INCREMENT,        -- PRIMARY KEY inline
 *   nama VARCHAR(100) NOT NULL,               -- NOT NULL
 *   email VARCHAR(100) UNIQUE,                -- UNIQUE
 *   usia INT CHECK (usia >= 17),              -- CHECK usia valid
 *   status ENUM('aktif', 'tidak aktif') DEFAULT 'aktif'  -- DEFAULT value
 * );
 *
 * ================================================================
 *            3. CONTOH TABEL DENGAN FOREIGN KEY
 * ================================================================
 * CREATE TABLE kota (
 *   id INT PRIMARY KEY AUTO_INCREMENT,
 *   nama VARCHAR(100) NOT NULL
 * );
 *
 * CREATE TABLE pelanggan (
 *   id INT PRIMARY KEY AUTO_INCREMENT,
 *   nama VARCHAR(100) NOT NULL,
 *   kota_id INT,
 *   CONSTRAINT fk_kota FOREIGN KEY (kota_id) REFERENCES kota(id)
 * );
 *
 * ✅ FOREIGN KEY menjaga agar kota_id hanya bisa berisi nilai dari kolom kota.id
 *
 * ================================================================
 *        4. PENJELASAN MASING-MASING CONSTRAINT SECARA RINCI
 * ================================================================
 *
 * 1 NOT NULL
 *    ➤ Melarang nilai NULL
 *    ➤ SELECT dan INSERT wajib isi kolom ini
 *    ➤ Menjamin bahwa data selalu ada
 *
 * 2 UNIQUE
 *    ➤ Tidak boleh ada duplikat
 *    ➤ Bisa diterapkan di kolom mana saja
 *    ➤ Berbeda dari PRIMARY KEY karena boleh NULL
 *
 * 3 pRIMARY KEY
 *    ➤ Hanya boleh satu per tabel
 *    ➤ Kombinasi dari NOT NULL + UNIQUE
 *    ➤ Wajib jadi identitas unik dari tiap baris
 *
 * 4 FOREIGN KEY
 *    ➤ Hubungkan antar tabel (relasional)
 *    ➤ Harus mengacu ke kolom yang sudah UNIQUE/PRIMARY KEY
 *    ➤ Menjaga referensi data tetap valid
 *
 * 5 CHECK
 *    ➤ Membatasi nilai dengan kondisi logika
 *    ➤ Contoh: usia >= 17, gaji >= 0
 *    ➤ Tidak semua versi MySQL mendukung penuh (mulai 8.0)
 *
 * 6 DEFAULT
 *    ➤ Memberi nilai awal otomatis jika tidak diisi saat INSERT
 *    ➤ Contoh: status DEFAULT 'aktif'
 *
 * ================================================================
 *           5. CONSTRAINT COMPOSITE (MULTI KOLOM)
 * ================================================================
 * ➤ Bisa gabungkan lebih dari satu kolom dalam satu constraint
 *
 * Contoh:
 * CREATE TABLE nilai (
 *   siswa_id INT,
 *   mapel_id INT,
 *   nilai INT,
 *   CONSTRAINT pk_nilai PRIMARY KEY (siswa_id, mapel_id)  -- composite key
 * );
 *
 * ✅ Kombinasi siswa & mapel harus unik, tidak boleh dobel
 *
 * ================================================================
 *           6. MENGHAPUS CONSTRAINT (ALTER TABLE)
 * ================================================================
 * ➤ Hapus PRIMARY KEY:
 *   ALTER TABLE pelanggan DROP PRIMARY KEY;
 *
 * ➤ Hapus CONSTRAINT nama tertentu:
 *   ALTER TABLE pelanggan DROP FOREIGN KEY fk_kota;
 *
 * ➤ Hapus UNIQUE:
 *   ALTER TABLE pelanggan DROP INDEX nama;
 *


import mysql from "mysql2/promise";

(async () => {
  const conn = await mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "contoh_db"
  });

  // Buat tabel kota
  await conn.execute(`
    CREATE TABLE IF NOT EXISTS kota (
      id INT PRIMARY KEY AUTO_INCREMENT,
      nama VARCHAR(100) NOT NULL UNIQUE
    )
  `);

  // Buat tabel pelanggan dengan berbagai constraint
  await conn.execute(`
    CREATE TABLE IF NOT EXISTS pelanggan (
      id INT PRIMARY KEY AUTO_INCREMENT,
      nama VARCHAR(100) NOT NULL,
      email VARCHAR(100) UNIQUE,
      usia INT CHECK (usia >= 17),
      status ENUM('aktif', 'tidak aktif') DEFAULT 'aktif',
      kota_id INT,
      CONSTRAINT fk_kota FOREIGN KEY (kota_id) REFERENCES kota(id)
    )
  `);

  await conn.end();
})();


 * ================================================================
 *                  8. KEGUNAAN CONSTRAINT DALAM INDUSTRI
 * ================================================================
 * ✅ Menjaga kualitas data (tidak NULL, tidak dobel, valid)
 * ✅ Menjamin hubungan antar tabel tetap sah
 * ✅ Mencegah data sampah (gaji negatif, usia < 0)
 * ✅ Mempermudah debugging dan validasi otomatis
 * ✅ Memastikan sistem tetap konsisten walau user salah input
 *
 * ================================================================
 *              9. BEST PRACTICE DALAM PENGGUNAAN
 * ================================================================
 * ✅ Selalu pakai PRIMARY KEY untuk identitas baris
 * ✅ Gunakan FOREIGN KEY untuk hubungan antar tabel
 * ✅ Batasi NULL dengan NOT NULL jika memang wajib diisi
 * ✅ Gunakan DEFAULT untuk nilai yang sering digunakan
 * ✅ Gunakan CHECK untuk validasi logika sederhana
 * ✅ Selalu beri nama pada constraint (lebih mudah dihapus)
 *
 * ================================================================
 *              10. KESIMPULAN SINGKAT
 * ================================================================
 * CONSTRAINT adalah "penjaga integritas" database.
 * Mereka mencegah data invalid, menjaga hubungan, dan
 * menjamin bahwa data yang tersimpan di database bisa dipercaya.
 *
 * Tanpa constraint, data bisa:
 * ❌ duplikat
 * ❌ null sembarangan
 * ❌ tidak terhubung ke tabel lain
 * ❌ tidak valid (usia -99, gaji negatif, status kosong)
 *
 * Maka dari itu: ✅ WAJIB dipahami dan digunakan dengan baik!








