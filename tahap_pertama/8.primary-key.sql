-- karena kita sudah membuat tabelny dan trnyata kita lupa untuk menmabuhka fitur primary key
-- maka kita bisa, karena pas juga kita punya kolom id, yg sebenarnya dia sudah uniq
https://chatgpt.com/c/6863a1d6-20d8-8009-a2cc-fef88e4bb25d
-- jadi kita bisa menunjuk 1 kolom yg mau kita jadikan sebagai primary key
-- danprimary key ini juga bisa lebih dari 1 di setiap tabel, tapi idealnya itu 1 primary key 1 table

-- dan ketika ada yg menginptkan data id yg sama dengan data id yg sudah ada sebelumnya
-- maka akan ditolak

use toko_online;
DESCRIBE products;

-- jadi sebenarynya kita itu ketika masukin primary keynya harusnya itu ketika membuat tabelnya
-- api karena lupa kita bisa menggunakan alter table

ALTER TABLE products ADD PRIMARY KEY (id)

SELECT * from products;



🔑 1. PRIMARY KEY
------------------

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







 * PRIMARY KEY adalah sebuah constraint (aturan/kebijakan) dalam database
 * yang digunakan untuk mengidentifikasi setiap baris (row) dalam sebuah tabel
 * secara unik. Ini merupakan bagian penting dalam database relasional.
 *
 *  CIRI-CIRI PRIMARY KEY:
 * 1. TIDAK BOLEH NULL (NOT NULL)
 * 2. NILAI HARUS UNIK (UNIQUE)
 * 3. HANYA BOLEH ADA SATU PRIMARY KEY PER TABEL
 *    (meskipun bisa terdiri dari satu atau lebih kolom: disebut *Composite Key*)
 *
 *  FUNGSI PRIMARY KEY:
 * - Mengidentifikasi setiap baris secara unik
 * - Menjadi acuan dalam relasi antar tabel (misalnya digunakan oleh FOREIGN KEY)
 * - Menjaga integritas data
 * - Mempercepat pencarian data (secara implisit dibuat index oleh MySQL)


-- Contoh 1: Primary key pada satu kolom (umum)
CREATE TABLE pelanggan (
  id INT PRIMARY KEY AUTO_INCREMENT, -- id adalah PRIMARY KEY
  nama VARCHAR(100) NOT NULL,
  email VARCHAR(100)
);

-- Contoh 2: Primary key dengan tipe UUID (tanpa auto increment)
CREATE TABLE produk (
  produk_id CHAR(36) PRIMARY KEY, -- produk_id sebagai PRIMARY KEY
  nama_produk VARCHAR(100),
  harga DECIMAL(10,2)
);

-- Contoh 3: Primary key gabungan (COMPOSITE KEY)
CREATE TABLE nilai_ujian (
  siswa_id INT,
  ujian_id INT,
  nilai DECIMAL(5,2),
  PRIMARY KEY (siswa_id, ujian_id) -- Composite key: gabungan dari dua kolom
);

-- Contoh 4: Menambahkan PRIMARY KEY setelah tabel dibuat
ALTER TABLE pelanggan ADD PRIMARY KEY (id);

-- Contoh 5: Menghapus PRIMARY KEY
ALTER TABLE pelanggan DROP PRIMARY KEY;

-- Contoh 6: Membuat PRIMARY KEY dengan nama sendiri (opsional, untuk manajemen constraint)
CREATE TABLE akun (
  username VARCHAR(50),
  email VARCHAR(100),
  PRIMARY KEY akun_primary_key (username)
);

-- Contoh 7: Membuat FOREIGN KEY yang mengacu ke PRIMARY KEY
CREATE TABLE transaksi (
  transaksi_id INT PRIMARY KEY AUTO_INCREMENT,
  pelanggan_id INT,
  FOREIGN KEY (pelanggan_id) REFERENCES pelanggan(id)
);

 * ================================================
 * CATATAN PENTING TENTANG PRIMARY KEY:
 * ================================================
 * - PRIMARY KEY secara otomatis dibuatkan INDEX oleh MySQL.
 * - Jika menggunakan kolom AUTO_INCREMENT, maka kolom itu wajib jadi PRIMARY KEY atau di-index.
 * - Gunakan kolom yang benar-benar unik dan stabil sebagai PRIMARY KEY.
 * - Hindari penggunaan kolom yang bisa berubah (seperti nama atau email) sebagai PRIMARY KEY.
 * - Composite Key digunakan saat satu kolom tidak cukup untuk menjamin keunikan.
 * - Tidak bisa ada dua baris dengan nilai PRIMARY KEY yang sama.
 * - Jika membuat FOREIGN KEY, kolom yang dirujuk harus PRIMARY KEY (atau UNIQUE).
 *
 * ================================================
 *  BEST PRACTICES:
 * ================================================
 * 1. Gunakan nama kolom `id` sebagai PRIMARY KEY bila cocok.
 * 2. Gunakan AUTO_INCREMENT untuk membuat ID unik otomatis.
 * 3. Jika ingin fleksibilitas lebih, gunakan UUID sebagai PRIMARY KEY.
 * 4. Gunakan Composite Key hanya jika benar-benar dibutuhkan (misalnya tabel relasi many-to-many).
 * 5. Selalu beri indeks pada PRIMARY KEY untuk performa optimal (MySQL sudah otomatis melakukannya).
 *
 * ================================================
 *  PENUTUP:
 * ================================================
 * PRIMARY KEY adalah fondasi penting dalam desain database.
 * Dengan pemahaman dan penggunaan yang benar, PRIMARY KEY akan membantu menjaga konsistensi dan performa data Anda.



 * ==========================================================
 *  PENJELASAN LENGKAP TENTANG COMPOSITE PRIMARY KEY
 * ==========================================================
 *  APA ITU COMPOSITE PRIMARY KEY?
 * Composite Primary Key adalah PRIMARY KEY yang dibentuk dari dua atau lebih kolom.
 * Gabungan nilai dari semua kolom ini harus unik untuk setiap baris data.
 *
 * Artinya: gabungan dari semua kolom pembentuk composite key akan menjadi identitas unik.
 *
 *  KAPAN DIGUNAKAN?
 * Composite key digunakan ketika:
 * - Satu kolom saja tidak cukup menjamin keunikan data
 * - Anda membuat tabel penghubung (junction table) pada relasi many-to-many
 * - Data sangat bergantung pada kombinasi nilai kolom
 *
 *  ATURAN COMPOSITE KEY:
 * - Tidak ada satu pun kolom yang boleh NULL
 * - Gabungan semua kolom harus unik
 * - Hanya bisa ada SATU composite primary key dalam satu tabel
 *
 *  BENTUK UMUM SINTAKS:
 *    PRIMARY KEY (kolom1, kolom2, ..., kolomN)
 *
 * ==========================================================
 *  CONTOH PENGGUNAAN COMPOSITE PRIMARY KEY
 * ==========================================================


-- Contoh 1: Tabel relasi antara siswa dan ujian
CREATE TABLE nilai_ujian (
  siswa_id INT NOT NULL,
  ujian_id INT NOT NULL,
  nilai DECIMAL(5,2),
  PRIMARY KEY (siswa_id, ujian_id) -- Composite key dari siswa_id dan ujian_id
);

-- Contoh 2: Tabel keanggotaan organisasi
CREATE TABLE keanggotaan (
  user_id INT NOT NULL,
  organisasi_id INT NOT NULL,
  tanggal_gabung DATE,
  PRIMARY KEY (user_id, organisasi_id)
);

-- Contoh 3: Composite key pada 3 kolom
CREATE TABLE reservasi_kamar (
  hotel_id INT NOT NULL,
  nomor_kamar INT NOT NULL,
  tanggal DATE NOT NULL,
  nama_pemesan VARCHAR(100),
  PRIMARY KEY (hotel_id, nomor_kamar, tanggal)
);

-- Contoh 4: Menambahkan composite key setelah tabel dibuat
ALTER TABLE nilai_ujian
ADD PRIMARY KEY (siswa_id, ujian_id);

-- Contoh 5: Menghapus composite key
ALTER TABLE nilai_ujian DROP PRIMARY KEY;

-- Contoh 6: FOREIGN KEY ke tabel dengan composite key
CREATE TABLE histori_ujian (
  siswa_id INT,
  ujian_id INT,
  status VARCHAR(50),
  FOREIGN KEY (siswa_id, ujian_id) REFERENCES nilai_ujian(siswa_id, ujian_id)
);


 * ==========================================================
 *  HAL PENTING SEPUTAR COMPOSITE PRIMARY KEY:
 * ==========================================================
 * ✅ Composite Key HARUS diurutkan sesuai dengan urutan kolom pada deklarasi PRIMARY KEY.
 * ✅ Setiap kombinasi nilai dari semua kolom composite key harus unik.
 * ✅ Jika menggunakan AUTO_INCREMENT, hanya boleh diterapkan pada SATU kolom dan HARUS menjadi kolom PERTAMA dalam composite key.
 * ✅ FOREIGN KEY yang mengacu ke composite key juga harus menyertakan SEMUA kolom dalam urutan yang sama.
 * ✅ Composite key secara otomatis juga membuat index di MySQL.

 * ==========================================================
 *  KEUNTUNGAN COMPOSITE PRIMARY KEY:
 * ==========================================================
 * - Menjamin integritas kombinasi data antar kolom
 * - Cocok untuk junction table (many-to-many)
 * - Menghindari penggunaan surrogate key jika memang tidak diperlukan

 * ==========================================================
 *  KEKURANGAN COMPOSITE PRIMARY KEY:
 * ==========================================================
 * - Menambah kompleksitas jika relasi antar tabel banyak
 * - Performa bisa menurun untuk tabel sangat besar
 * - Sulit digunakan jika Anda mengandalkan AUTO_INCREMENT

 * ==========================================================
 *  TIPS DAN BEST PRACTICES:
 * ==========================================================
 * 1. Gunakan composite key jika tidak ada satu kolom yang unik secara sendiri.
 * 2. Jangan gunakan composite key secara berlebihan.
 * 3. Gunakan surrogate key (kolom `id` AUTO_INCREMENT) jika struktur data rumit atau jumlah kolom composite terlalu banyak.
 * 4. Hindari membuat composite key dari kolom yang nilai-nilainya sering berubah.
 * 5. Pastikan data dalam semua kolom composite key tidak NULL dan dijamin valid.


 * Composite Primary Key adalah solusi tepat ketika kombinasi kolom dibutuhkan
 * untuk menjaga keunikan data dan integritas antar tabel.
 * Gunakan dengan hati-hati dan terstruktur agar desain database tetap efisien.








