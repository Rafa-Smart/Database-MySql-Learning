
-- SAYA MENAMBHAKAN DATA DATA KE ARTIKEL DI PALING BAWAH

-- jadi kenapa kita harus menggunkaan full text search
-- karena jika melakukan pencarian kata pada table menggunkan like
-- maka akna ssangat lambat, karena operator like ini akan mnescaning seluruh data dari table
-- dari data pertama sampai data terakhir, jadi akna sangat lama
-- dan like ini juga tidka menggunakan index, jadi ga dad hubungannya dnegan menambahkan index


-- dan mysql ini jga bukan untuk database search engine, jadi fitur ini masih basic saja
-- kalo mau yg lebih proper lagi maaka gunakan database yg khusus menjadi search engine

-- jadi ini itu snagat berguna jika kita ingin melakkan pencarian yg tidak hanya
--sekedar mencari berdasarkan operator = atau !=, tapi ini pencarian string
-- yang lebih advance lagi 

-- jadi ocnothnya jika kita inign mencari rafa, maka nanti akan keluar semua datanya
-- misal rafa khadafi, rafa jamal, rafa siti, muhammad rafa jamal, dll

-- SYARAT SYARAT
Tabel harus menggunakan engine MyISAM atau InnoDB (MySQL 5.6+ untuk InnoDB)
Kolom yang akan diindeks harus bertipe CHAR, VARCHAR, atau TEXT

-- conoth

USE toko_online;

CREATE TABLE artikel (
  id INT AUTO_INCREMENT PRIMARY KEY,
  judul TEXT,
  isi TEXT,
  FULLTEXT(judul, isi) -- inilah fulltext index
) ENGINE=InnoDB;

-- atau bisa juga seperti ini
ALTER TABLE nama_tabel ADD FULLTEXT(nama_kolom);

-- atau bisa juga ketika kita menamhbhkan nama untuk si fulltextnya
-- jadi nanti ketika di drop pakenya drop index nama_fultextnya
-- jadi ga perlu pake nama kolom

DESCRIBE artikel;
SHOW CREATE TABLE artikel;
ALTER TABLE artikel 
ADD fulltext(judul, isi);

SHOW indexes FROM artikel;

-- kalo mau hapus, kita bisa hapus indexnya saja
ALTER TABLE artikel
DROP INDEX judul;
ALTER TABLE artikel
DROP INDEX isi;

-- jadi kita menambhakan fitur fulltext search pada kolom judul dan isi


SELECT * FROM artikel;


-- perbedaan index reguler dan index full text search

 *
 * ⛳ LATAR BELAKANG
 * ------------------------------------------------------
 * Di MySQL, terdapat beberapa jenis index, dua yang utama:
 *    1. Regular Index (B-TREE)
 *    2. Full-Text Index (FTS)
 *
 * Meskipun sama-sama digunakan untuk mempercepat pencarian,
 * keduanya memiliki tujuan dan cara kerja yang sangat berbeda.
 *
 *
 * 🔍 REGULAR INDEX (B-TREE)
 * ------------------------------------------------------
 * ✅ Digunakan untuk pencarian nilai exact dan sorting.
 * ✅ Efektif untuk operasi WHERE seperti:
 *      - WHERE kolom = 'abc'
 *      - WHERE kolom > 10
 *      - WHERE kolom LIKE 'abc%' (prefix only)
 * ✅ Dapat digunakan di PRIMARY KEY, UNIQUE, atau INDEX biasa.
 *
 *
 * 🔍 FULL-TEXT INDEX (FTS)
 * ------------------------------------------------------
 * ✅ Digunakan khusus untuk pencarian teks dalam kolom besar,
 *    seperti artikel, deskripsi, komentar, dll.
 * ✅ Mendukung operasi pencarian teks canggih via:
 *      - MATCH(kolom) AGAINST('keyword')
 * ✅ Cocok untuk analisis kata dan pencarian dengan relevansi.
 *
 *
 * ======================================
 *         TABEL PERBANDINGAN INTI
 * ======================================
 *
 * | Karakteristik          | Full-Text Index            | Regular Index (B-tree)         |
 * |------------------------|----------------------------|--------------------------------|
 * | Tujuan utama           | Pencarian teks penuh       | Pencarian exact atau sorting   |
 * | Fungsi utama           | MATCH() AGAINST()          | =, <, >, LIKE 'abc%'           |
 * | Cocok untuk            | Teks panjang (deskripsi)   | Angka, ID, kode, kolom pendek  |
 * | LIKE support           | Tidak membantu LIKE        | Membantu LIKE dengan prefix    |
 * | Performa teks panjang  | Cepat dan relevan          | Sangat lambat (scan seluruh)   |
 * | Relevansi hasil        | Ya (dihitung otomatis)     | Tidak ada                      |
 * | Boolean operator       | Ya (+term, -term)          | Tidak                          |
 * | Ukuran index           | Lebih besar                | Lebih ringan                   |
 * | Engine support         | MyISAM, InnoDB (5.6+)      | Semua engine                   |
 *
 *
 * ======================================
 *        FUNGSI ADD FULLTEXT()
 * ======================================
 *
 * Digunakan untuk menambahkan indeks pencarian teks penuh.
 *
 * SQL:
 *   ALTER TABLE artikel ADD FULLTEXT(judul, isi);
 *
 * 📌 Kegunaan:
 * - Mengaktifkan pencarian kata/frasa di teks panjang
 * - Mendukung pencarian bahasa alami (natural language)
 * - Optimalkan performa pencarian teks
 *
 *
 * ======================================
 *        CONTOH QUERY PERBANDINGAN
 * ======================================
 */

// 🔸 Query menggunakan LIKE (tanpa full-text index)

SELECT * FROM artikel
WHERE judul LIKE '%database%' OR isi LIKE '%database%';
*/

// 🔸 Query menggunakan Full-Text Index (MATCH...AGAINST)

SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('database' IN NATURAL LANGUAGE MODE);
*/

// 🔸 Menggunakan Boolean Mode untuk advanced search

SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('+MySQL -Oracle' IN BOOLEAN MODE);
*/



 * ======================================
 *   KAPAN MENGGUNAKAN FULL-TEXT INDEX?
 * ======================================
 *
 * ✅ Ketika:
 *   - Kamu memiliki kolom teks panjang (TEXT, VARCHAR)
 *   - Ingin mencari berdasarkan kata/frasa, bukan exact match
 *   - Butuh fitur boolean search (+term, -term, "frasa")
 *   - LIKE '%kata%' sangat lambat (full table scan)
 *
 * ❌ Hindari jika:
 *   - Hanya mencari angka, id, kode
 *   - Kolom sangat pendek (misal 'status', 'kota')
 *   - Tidak butuh relevansi
 *
 *
 * ======================================
 *       KELEBIHAN FULL-TEXT INDEX
 * ======================================
 * ✅ Relevansi pencarian otomatis
 * ✅ Pencarian multi-kata/frasa lebih akurat
 * ✅ Support mode natural dan boolean
 * ✅ Performa tinggi untuk teks panjang
 *
 * ======================================
 *       KEKURANGAN FULL-TEXT INDEX
 * ======================================
 * ❌ Index lebih besar
 * ❌ Tidak membantu query LIKE biasa
 * ❌ Tidak mendukung pencarian prefix LIKE 'abc%'
 * ❌ Syntax lebih kompleks
 * ❌ Tidak case-sensitive
 *
 *
 * ======================================
 *       PENUTUP
 * ======================================
 *
 * 💡 Kesimpulan:
 *   - Full-Text Index sangat berguna untuk pencarian teks
 *     panjang dan kompleks (artikel, deskripsi).
 *   - Regular Index tetap dibutuhkan untuk nilai exact,
 *     sorting, dan filter biasa.
 *   - Keduanya memiliki peran masing-masing dalam desain database.
 *
 * ⚠️ Rekomendasi: Gunakan sesuai konteks dan kombinasi bila perlu.
 *
 */




 *
 * 🔍 APA ITU FULL-TEXT SEARCH?
 * --------------------------------
 * Full-Text Search adalah fitur pencarian teks canggih di MySQL
 * yang memungkinkan pencarian terhadap kata atau frase dalam
 * teks panjang, seperti artikel, deskripsi, komentar, dll.
 *
 * ➕ Dibandingkan LIKE '%kata%', FTS jauh lebih efisien dan akurat.
 * ➕ Digunakan untuk pencarian kata kunci (keyword search), bukan pencocokan tepat (exact match).
 *
 * Contoh: pencarian artikel yang mengandung kata "programming".
 *
 *
 * 📦 TIPE STORAGE YANG DIDUKUNG:
 * --------------------------------
 * ✅ MyISAM (sejak MySQL 3.23)
 * ✅ InnoDB (sejak MySQL 5.6+)
 *
 *
 * 🧠 CARA KERJANYA (DI BALIK LAYAR):
 * ------------------------------------
 * 1. MySQL membangun **Full-Text Index**, yaitu struktur khusus
 *    yang memetakan kata-kata ke baris di tabel.
 * 2. Setiap kata dipisah (tokenized), dihapus stopword (kata umum seperti "and", "the").
 * 3. Kata dicocokkan menggunakan algoritma boolean atau natural language.
 *
 *
 * 🛠️ SINTAKS UMUM:
 * -------------------
 *   MATCH(kolom1, kolom2, ...)
 *   AGAINST('kata yang dicari' [IN NATURAL LANGUAGE MODE | IN BOOLEAN MODE | WITH QUERY EXPANSION])
 *
 *
 * ================================================
 *       CONTOH PENGGUNAAN DAN IMPLEMENTASI
 * ================================================
 */

// Step 1: Buat tabel dengan fulltext index

CREATE TABLE artikel (
  id INT AUTO_INCREMENT PRIMARY KEY,
  judul TEXT,
  isi TEXT,
  FULLTEXT(judul, isi) -- inilah fulltext index
) ENGINE=InnoDB;
*/

// Step 2: Masukkan data artikel

INSERT INTO artikel (judul, isi) VALUES
('Belajar MySQL', 'MySQL adalah sistem manajemen basis data relasional.'),
('Pemrograman Dasar', 'Belajar dasar-dasar programming dan algoritma.'),
('Tips Database', 'Gunakan full-text index untuk pencarian cepat.');
*/

// Step 3: Cari artikel yang mengandung kata "programming"

SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('programming');
*/

// Step 4: Mode Pencarian:
// --------------------------
// ✅ IN NATURAL LANGUAGE MODE (default):
//    - Mode default.
//    - Pencarian berdasarkan relevansi dari hasil.
//    - Tidak mendukung operator logika seperti + - ~ dll.


SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('belajar database' IN NATURAL LANGUAGE MODE);
*/

// ✅ IN BOOLEAN MODE:
//    - Mendukung operator seperti:
//        +kata   -> wajib ada
//        -kata   -> jangan ada
//        "..."   -> frase persis
//        *       -> wildcard akhir kata


SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('+belajar -mysql' IN BOOLEAN MODE);
*/

// ✅ WITH QUERY EXPANSION:
//    - MySQL mencari kata kunci awal, lalu secara otomatis
//      memperluas pencarian berdasarkan hasil awal tersebut.
//    - Berguna untuk pencarian lebih fleksibel.


SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('mysql' WITH QUERY EXPANSION);
*/



 * ================================================
 *           APA SAJA KELEBIHAN FULLTEXT?
 * ================================================
 * ✅ Pencarian cepat dan efisien di kolom teks panjang.
 * ✅ Lebih akurat daripada LIKE '%kata%'.
 * ✅ Mendukung pencarian fleksibel (natural/boolean).
 * ✅ Bisa mencari lebih dari 1 kata/frasa.
 * ✅ Bisa sorting berdasarkan relevansi.
 *
 * ================================================
 *           APA SAJA KEKURANGANNYA?
 * ================================================
 * ❌ Tidak cocok untuk field yang sangat pendek.
 * ❌ Tidak cocok untuk pencarian angka atau kode.
 * ❌ Tidak cocok jika butuh pencarian case-sensitive.
 * ❌ Tidak seakurat mesin pencari khusus seperti Elasticsearch.
 *
 * ================================================
 *           KAPAN HARUS MENGGUNAKAN INI?
 * ================================================
 * 💡 Gunakan FTS saat:
 *   - Butuh pencarian teks dalam deskripsi, artikel, komentar.
 *   - Data banyak dan LIKE menjadi lambat.
 *   - Ingin pencarian multi-kata dan relevansi.
 *   - Aplikasi blog, forum, katalog, e-learning, dll.
 *
 *
 * ================================================
 *              OPSI TAMBAHAN & TIPS
 * ================================================
 * 🔹 Stopwords: MySQL abaikan kata-kata umum ("is", "the", "on").
 *     - Bisa diubah lewat konfigurasi.
 * 🔹 Minimum word length: Default = 3 karakter.
 *     - Kata <3 huruf akan diabaikan (bisa diubah).
 * 🔹 Relevansi dihitung otomatis oleh MySQL.
 * 🔹 Bisa digunakan dalam SELECT, WHERE, atau ORDER BY.
 *
 * Contoh mengurutkan berdasarkan relevansi:
 * 
 * SELECT *, MATCH(judul, isi) AGAINST('database') AS skor
 * FROM artikel
 * ORDER BY skor DESC;
 *
 *
 * ================================================
 *           PERBEDAAN DENGAN LIKE
 * ================================================
 * 🔍 LIKE '%kata%':
 *   - Lambat, tidak bisa pakai index biasa.
 *   - Tidak tahu relevansi.
 *   - Tidak mengenali frasa.
 *
 * 🔍 Full-Text Search:
 *   - Cepat karena pakai indeks khusus.
 *   - Bisa tahu relevansi.
 *   - Mendukung frasa/logika/kata jamak.
 *
 *
 * ================================================
 *         PENUTUP & REKOMENDASI PENGGUNAAN
 * ================================================
 * ✅ FTS sangat disarankan jika kamu membangun fitur pencarian
 *    dalam teks panjang dengan hasil akurat dan cepat.
 * ✅ Tapi jika kamu butuh pencarian sangat kompleks
 *    seperti typo tolerance, highlighting, bahasa alami,
 *    maka gunakan Elasticsearch atau alat pencarian lanjutan.
 *

 USE toko_online;
 SELECT * FROM artikel;
 truncate artikel;

 INSERT INTO artikel (judul, isi) VALUES
('Belajar MySQL', 'MySQL adalah sistem basis data relasional yang populer untuk pengembangan web.'),
('Pengenalan SQL', 'SQL digunakan untuk mengakses dan memanipulasi database.'),
('Optimasi Index', 'Index digunakan untuk meningkatkan performa query pada tabel besar.'),
('Dasar JavaScript', 'JavaScript sering digunakan untuk membuat halaman web menjadi interaktif.'),
('HTML dan CSS', 'HTML memberikan struktur, sementara CSS memberikan gaya pada halaman.'),
('Belajar Python', 'Python adalah bahasa pemrograman yang bersifat general purpose dan mudah dipelajari.'),
('Algoritma Sorting', 'Bubble Sort, Merge Sort, dan Quick Sort adalah algoritma sorting populer.'),
('Struktur Data Stack', 'Stack mengikuti prinsip LIFO dan sering digunakan dalam rekursi.'),
('Perbandingan SQL dan NoSQL', 'SQL bersifat relasional, sementara NoSQL fleksibel dan skalabel.'),
('Pemrograman Asinkron', 'Asynchronous programming menggunakan callback, promise, atau async-await.'),
('Express.js untuk REST API', 'Express.js memudahkan pembuatan REST API menggunakan Node.js.'),
('Autentikasi dengan JWT', 'JWT digunakan untuk autentikasi berbasis token yang aman.'),
('Belajar Git', 'Git adalah version control system yang populer di kalangan developer.'),
('Penggunaan GitHub', 'GitHub menyediakan platform untuk kolaborasi dan hosting repository.'),
('CRUD di PHP', 'Operasi CRUD adalah dasar dari pemrograman aplikasi berbasis database.'),
('Middleware Express', 'Middleware memungkinkan penanganan request dan response yang fleksibel.'),
('Mengenal React', 'React adalah library JavaScript untuk membangun antarmuka UI.'),
('State Management', 'State di React dapat dikelola dengan Context API atau Redux.'),
('CSS Flexbox', 'Flexbox membuat tata letak halaman lebih responsif dan fleksibel.'),
('Responsive Web Design', 'Desain responsif memastikan tampilan halaman bagus di berbagai perangkat.'),
('Database Normalization', 'Normalisasi mengurangi redundansi dan meningkatkan integritas data.'),
('JOIN di SQL', 'JOIN digunakan untuk menggabungkan data dari dua atau lebih tabel.'),
('Belajar Laravel', 'Laravel adalah framework PHP modern dengan banyak fitur siap pakai.'),
('Perbedaan API dan Webhook', 'API dipanggil oleh klien, sedangkan webhook dikirim otomatis oleh server.'),
('Unit Testing di JavaScript', 'Unit test memastikan fungsi berjalan sesuai harapan tanpa error.'),
('Belajar Vue.js', 'Vue merupakan framework JavaScript yang ringan dan reaktif.'),
('XAMPP dan PHP', 'XAMPP menyediakan server lokal untuk menjalankan skrip PHP dan MySQL.'),
('Validasi Form HTML', 'Validasi input penting untuk menjaga keamanan dan integritas data.'),
('Konsep OOP', 'OOP melibatkan inheritance, encapsulation, dan polymorphism.'),
('SQL Injection', 'SQL Injection adalah ancaman umum yang menyerang perintah SQL.'),
('Parameterized Query', 'Gunakan parameter untuk mencegah SQL Injection di aplikasi.'),
('Debugging JavaScript', 'Console.log dan debugger adalah alat penting dalam debugging.'),
('Apa itu API', 'API memungkinkan sistem berkomunikasi satu sama lain melalui protokol tertentu.'),
('Manajemen Proyek', 'Gunakan Trello, Jira, atau Notion untuk mengelola tugas dan proyek.'),
('Hosting Web', 'Website dapat di-hosting di layanan seperti Netlify, Vercel, atau cPanel.'),
('Desain Minimalis', 'Desain UI minimalis meningkatkan pengalaman pengguna.'),
('EJS di Express', 'EJS adalah template engine untuk render HTML di server Node.js.'),
('Async Await di Node', 'Async/Await memudahkan penulisan kode asynchronous.'),
('Firebase untuk Auth', 'Firebase menyediakan autentikasi berbasis email, Google, dan lainnya.'),
('Penggunaan dotenv', 'Variabel lingkungan disimpan dalam file .env untuk keamanan konfigurasi.');


 


