

-- jadi check constraint adalh

-- jaid disini kit akan tambah kolom baru
-- dan kita akn buat validasi untuk insert datanya atau ketika perubahan data / update


-- ini kalo kit ingin menambhakna constraint langsung ketika dibuat tablenya
CREATE TABLE customer (
    id int AUTO_INCREMENT, 
    email varchar(100) NOT NULL,
    first_name varchar(100) NOT NULL,
    lastname varchar(100) NOT NULL,
    uang int NOT NULL,
    CONSTRAINT id_primary PRIMARY KEY (id),
    CONSTRAINT email_unique UNIQUE (email)
    CONSTRAINT lebih_dari_15 CHECK (uang > 15000)
) ENGINE = innodb;

USE toko_online;

SELECT * FROM customer;
DESCRIBE customer;

ALTER TABLE customer
ADD COLUMN uang int NOT NULL DEFAULT 0;

ALTER TABLE customer
ADD CONSTRAINT uang_hrs_Besar check(uang > 15000);


-- enapa ga bisa karena ada yg dilanggal, karena ketika kita menambhakan peraturan bahwa uang harus lbeih dari 
15000, tapi ternyata sebelumnya kita telah mengset, bahwa nilai dari uang itu defaultnya adalah 0
-- mkaa ini menlanggar, jadi tidak bisa

ALTER TABLE customer
DROP uang;

ALTER TABLE customer
add uang int NOT null DEFAULT 16000;


-- nah disini ita tes kalo kita masukan data uang yg kurang dari 15000

INSERT INTO customer (email, first_name, last_name, uang)
VALUES ('johnEmail', 'jhon', 'cena', 14000);
-- ditolak : SQL Error [3819] [HY000]: Check constraint 'uang_hrs_Besar' is violated.

SELECT * FROM customer;
INSERT INTO customer (email, first_name, last_name, uang)
VALUES ('johnEmail', 'jhon', 'cena', 20000);

INSERT INTO customer (email, first_name, last_name, uang)
VALUES ('johnEmail2', 'jhon2', 'cena2', 20000);


-- PNETING
-- jadi ketika kita alter table constraint check
-- maka kita harus pastikan dulu bahwa data sebelumya sudha memenuhi aturan check yg inign kita buat


 * 🔍 APA ITU CHECK CONSTRAINT?
 * -------------------------------
 * CHECK CONSTRAINT adalah sebuah aturan (constraint) dalam SQL yang digunakan untuk
 * membatasi nilai-nilai yang bisa dimasukkan ke dalam kolom (field) tertentu.
 *
 * Fungsinya mirip seperti validasi di sisi database. Ini memastikan bahwa data yang dimasukkan
 * ke kolom tertentu sesuai dengan aturan logis atau syarat tertentu yang ditentukan.
 *
 * 🔧 CONTOH NYATA:
 * - Umur tidak boleh negatif.
 * - Gaji harus lebih besar dari 0.
 * - Persentase harus antara 0 hingga 100.
 *
 * --------------------------------
 * 📌 SYNTAX DASAR CHECK CONSTRAINT
 * --------------------------------
 * Saat membuat tabel:
 *
 *   CREATE TABLE nama_tabel (
 *     kolom1 TipeData,
 *     kolom2 TipeData,
 *     ...
 *     CONSTRAINT nama_check CHECK (syarat)
 *   );
 *
 * Atau langsung di dalam definisi kolom:
 *
 *   kolom1 INT CHECK (kolom1 > 0)
 *
 * Menambahkan ke tabel yang sudah ada:
 *
 *   ALTER TABLE nama_tabel
 *   ADD CONSTRAINT nama_check CHECK (syarat);
 *
 * -------------------------------
 * 🛠 CONTOH PENGGUNAAN LENGKAP
 * -------------------------------
 */

/// SQL: Membuat tabel dengan CHECK
/*
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  umur INT,
  gaji DECIMAL(10,2),

  -- Umur minimal 17 tahun
  CONSTRAINT check_umur CHECK (umur >= 17),

  -- Gaji minimal 1000.00
  CONSTRAINT check_gaji CHECK (gaji >= 1000.00)
);
*/

/// SQL: Menambahkan CHECK ke tabel yang sudah ada
/*
ALTER TABLE users
ADD CONSTRAINT check_nama_not_empty CHECK (nama != '');
*/

/// SQL: INSERT valid
/*
INSERT INTO users (nama, umur, gaji)
VALUES ('Rafa', 25, 5000.00);  -- ✅ Berhasil
*/

/// SQL: INSERT tidak valid
/*
INSERT INTO users (nama, umur, gaji)
VALUES ('Budi', 15, 500.00);   -- ❌ ERROR: Melanggar check_umur dan check_gaji
*/

/// SQL: DROP constraint (menghapus CHECK)
/*
ALTER TABLE users
DROP CHECK check_umur;
*/

/**
 * 💡 CATATAN PENTING!
 * ----------------------
 * ✅ Sejak MySQL 8.0.16, CHECK CONSTRAINT didukung secara **aktif**.
 *    - Di versi sebelumnya, MySQL mengabaikan CHECK (tidak error, tapi tidak dijalankan).
 *
 * ✅ CHECK bisa digunakan untuk:
 *    - Pembatasan nilai (range, kondisi logika)
 *    - Validasi kombinasi kolom
 *
 * ❌ Keterbatasan:
 *    - CHECK tidak bisa akses data baris lain (tidak bisa banding antar baris)
 *    - Tidak mendukung subquery di dalam CHECK
 *
 * -----------------------------------
 * 🚀 KENAPA HARUS PAKAI CHECK CONSTRAINT?
 * -----------------------------------
 * 1. **Validasi Data di Level Database**:
 *    Mencegah data tidak valid masuk ke database meskipun dari backend ada bug.
 *
 * 2. **Meningkatkan Keamanan dan Konsistensi**:
 *    Aturan berlaku universal, tidak tergantung aplikasi (Node.js, Python, dsb).
 *
 * 3. **Mengurangi Beban Validasi di Kode Aplikasi**:
 *    Cukup validasi satu kali di database, tidak perlu ditulis ulang di semua aplikasi.
 *
 * 4. **Membantu Dokumentasi Struktur Data**:
 *    Developer lain akan langsung tahu syarat tiap kolom hanya dengan melihat struktur tabel.
 *
 * ----------------------------------------
 * 🏗 STUDI KASUS NYATA DI INDUSTRI
 * ----------------------------------------
 * Misal kamu membangun sistem HR (Human Resources), dan ada tabel `karyawan`.
 * Kamu ingin memastikan:
 * - Umur minimal 18 tahun
 * - Gaji minimal Rp1.000.000
 * - Status hanya boleh “Tetap”, “Kontrak”, atau “Magang”
 *
 * Maka kamu bisa menambahkan:
 *
 * CREATE TABLE karyawan (
 *   id INT PRIMARY KEY AUTO_INCREMENT,
 *   nama VARCHAR(100) NOT NULL,
 *   umur INT CHECK (umur >= 18),
 *   gaji DECIMAL(10,2) CHECK (gaji >= 1000000),
 *   status ENUM('Tetap', 'Kontrak', 'Magang') CHECK (status IN ('Tetap', 'Kontrak', 'Magang'))
 * );
 *
 * Ini memastikan bahwa semua data yang masuk sudah tervalidasi dari sisi database.
 */

/**
 * ✅ KESIMPULAN:
 * -------------------------------
 * CHECK CONSTRAINT sangat penting untuk memastikan kualitas dan integritas data.
 * Jangan hanya andalkan validasi dari sisi aplikasi. Gunakan juga validasi dari sisi database.
 * Di MySQL versi modern (>= 8.0.16), fitur ini sudah sangat stabil dan layak digunakan di produksi.
 */




