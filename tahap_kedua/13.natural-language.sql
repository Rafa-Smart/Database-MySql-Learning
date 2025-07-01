
dan defaultnya itu case INSENSITIVE
baik itu FULLTEXT SEARCH atau juga yg LIKE

tapi yg LIKE juga bisa diatur ke SENSITIVE mneggunkan 
LIKE BINARY '%rafa%' --> maka akan sensitive

-- jadi ada beberapa mode pencarian fulltext search yaitu salah satunya adalah
-- natural language mode
https://dev.mysql.com/doc/refman/8.4/en/fulltext-natural-language.html
-- nah jdai ini tuh mode untuk mnecari seperti bahawa natural (perkata)
-- jadi akn dicari kata yg score nya tertinggi, dan untuk lihat apa saja yg memengearuhi scorenya
-- bsia dilihat di pnejelasan dibawah

Pencocokan secara eksak (exact matching) dalam konteks database berarti mencari data yang persis sama dengan nilai yang dicari, tanpa toleransi terhadap variasi atau kemiripan.

USE toko_online;
SELECT * FROM artikel;

DESCRIBE artikel;
-- nah disini kita akn mencoba pencariannya

ALTER TABLE artikel
add FULLTEXT fulltext_rafa (judul, isi);
-- ini seeblumnya 
SELECT * FROM artikel
WHERE judul LIKE '%sql%' OR isi LIKE '%sql%'
ORDER BY id ASC;

SELECT * FROM artikel
WHERE match(judul, isi)
    against('sql' IN NATURAL LANGUAGE mode)
    -- kalo engga pake order, maka nanti akna berdasarkan 
    -- data terbanyak yg ada pada suatu baris
    -- jadi dicari klo sql ada di judul dan ada juga di isi, maka kemungkinannya
    -- akan ditaro diatas
ORDER BY id asc;



-- ini kenapa lebih banyak menggunakan like dari pada pake fulltext
-- ini karena cara nyarinya beda, kalo like itu cari dimana saja (karena '%sql%')
-- jadi bisa ditengah, akhir, awal, akan dianggap data yg dicari

-- tapi kalo yg fulltext, berati mencari kata indiidualnya saja, 
-- makanya cocok untuk pencarian text yg panjang

-- atau kalo pengen liat berapa kemungkinan tersaring data yg ada sqlnya
-- kita bisa pake cara ini
SELECT *, match(judul, isi)
    against('sql' IN NATURAL LANGUAGE mode) AS skor 
    FROM artikel;


SHOW INDEX FROM artikel;

SELECT *, MATCH(judul, isi) AGAINST('programming dan database' IN NATURAL LANGUAGE MODE) AS skor
FROM artikel
ORDER BY skor DESC;




 *
 * 🔍 APA ITU FULL-TEXT SEARCH NATURAL LANGUAGE MODE?
 * ------------------------------------------------------------
 * Full-Text Search (FTS) adalah fitur di MySQL untuk melakukan 
 * pencarian kata/frasa di dalam kolom teks (TEXT, VARCHAR, dsb).
 *
 * Salah satu mode pencariannya adalah:
 *     🔹 NATURAL LANGUAGE MODE
 *
 * Mode ini memungkinkan pencarian berdasarkan **bahasa alami**.
 * Artinya: MySQL akan memahami konteks kalimat atau kata-kata,
 * bukan sekadar mencocokkan teks secara literal.
 *
 * ➕ Cocok untuk sistem pencarian seperti: artikel, blog, katalog,
 *     deskripsi produk, sistem e-learning, forum, dan lainnya.
 *
 *
 * 🧠 BAGAIMANA CARA KERJANYA?
 * ------------------------------------------------------------
 * - MySQL memproses input pencarian sebagai kalimat bahasa alami.
 * - Kata-kata dalam kolom teks di-*tokenize* (dipisahkan per kata).
 * - MySQL menghitung **skor relevansi** setiap baris data
 *   terhadap kata pencarian, bukan mencocokkan secara eksak.
 * - Hasil dikembalikan berdasarkan skor tertinggi.
 *
 * 💡 Tidak ada operator khusus seperti "+" atau "-".
 * 💡 Pencarian mendukung multi-kata dan frasa.
 *
 *
 * 🔧 SINTAKS DASAR:
 * ------------------------------------------------------------
 *     MATCH(kolom1, kolom2, ...)
 *     AGAINST('kata yang dicari' IN NATURAL LANGUAGE MODE)
 *
 *
 * 📦 CONTOH PRAKTIS
 * ------------------------------------------------------------
// Langkah 1: Buat tabel dan fulltext index

CREATE TABLE artikel (
  id INT AUTO_INCREMENT PRIMARY KEY,
  judul TEXT,
  isi TEXT,
  FULLTEXT(judul, isi)
) ENGINE=InnoDB;
*/

// Langkah 2: Masukkan data

INSERT INTO artikel (judul, isi) VALUES
('Belajar MySQL', 'MySQL adalah sistem manajemen basis data relasional.'),
('Pemrograman Dasar', 'Belajar dasar-dasar programming dan algoritma.'),
('Tips Database', 'Gunakan full-text index untuk pencarian cepat.'),
('Pemrograman Web', 'HTML, CSS, dan JavaScript sangat penting.');
*/

// Langkah 3: Pencarian menggunakan Natural Language

SELECT *, MATCH(judul, isi) AGAINST('programming dan database' IN NATURAL LANGUAGE MODE) AS skor
FROM artikel
ORDER BY skor DESC;
*/

//
// Output akan mengurutkan baris artikel dengan "programming" dan "database"
// paling relevan di atas, meskipun tidak persis sama.
//
 *
 *
 * 🧮 CARA MENGHITUNG SKOR RELEVANSI (SECARA SEDERHANA)
 * ------------------------------------------------------------
 * Skor dihitung berdasarkan:
 *   - Frekuensi kata dalam dokumen
 *   - Jumlah total dokumen
 *   - Jumlah dokumen yang mengandung kata tersebut
 *   - Panjang teks
 *
 * Ini disebut **TF-IDF (Term Frequency - Inverse Document Frequency)**
 * meskipun MySQL tidak mendokumentasikan detail algoritmenya secara terbuka.
 *
 *
 * 📋 FITUR PENTING & PERLAKUAN KHUSUS
 * ------------------------------------------------------------
 * 🔹 Stopword List:
 *   - Kata umum seperti “the”, “is”, “on”, “and”, dsb akan diabaikan.
 *   - Bisa disesuaikan lewat file konfigurasi MySQL.
 *
 * 🔹 Minimum Word Length:
 *   - Default: 3 karakter (kata lebih pendek akan diabaikan).
 *   - Bisa diubah via konfigurasi `ft_min_word_len`.
 *
 * 🔹 Bahasa:
 *   - MySQL tidak memahami grammar bahasa alami, tapi memakai teknik statistik.
 *   - Tidak ada fitur NLP (Natural Language Processing) tingkat lanjut.
 *
 *
 * ✅ KELEBIHAN NATURAL LANGUAGE MODE
 * ------------------------------------------------------------
 * - Relevan dan kontekstual, bukan sekadar cocok literal.
 * - Hasil otomatis diurutkan berdasarkan relevansi skor.
 * - Tidak perlu syntax yang rumit.
 * - Mudah diimplementasikan untuk pencarian umum.
 *
 *
 * ❌ KEKURANGAN
 * ------------------------------------------------------------
 * - Tidak mendukung pencarian kompleks (tidak bisa pakai +, -, *, dll).
 * - Tidak bisa mengatur pencarian wajib atau dikecualikan.
 * - Tidak cocok jika pengguna butuh kontrol penuh atas query.
 * - Tidak selalu akurat jika datanya tidak representatif.
 *
 *
 * ⚖️ PERBANDINGAN NATURAL LANGUAGE MODE VS BOOLEAN MODE
 * ------------------------------------------------------------
 *
 * | Aspek                 | NATURAL LANGUAGE MODE         | BOOLEAN MODE                 |
 * |----------------------|-------------------------------|------------------------------|
 * | Tujuan               | Pencarian berdasarkan makna   | Pencarian berdasarkan logika |
 * | Dukungan operator    | ❌ Tidak ada                   | ✅ + - " " * dll              |
 * | Skor relevansi       | ✅ Ya                          | ❌ Tidak, hanya TRUE/FALSE    |
 * | Hasil urutan         | Berdasarkan skor relevansi    | Tidak otomatis terurut       |
 * | Fleksibilitas        | Mudah, user friendly           | Lebih teknikal dan spesifik  |
 *
 *
 * 🛠 TIPS DAN BEST PRACTICES
 * ------------------------------------------------------------
 * 🔹 Gunakan mode natural untuk pencarian umum (user-friendly).
 * 🔹 Pastikan kamu menggunakan tipe InnoDB (MySQL 5.6+) atau MyISAM.
 * 🔹 Tambahkan FULLTEXT INDEX agar performa tidak lambat.
 * 🔹 Uji kata kunci agar tahu mana yang diproses dan mana yang diabaikan.
 * 🔹 Hindari SELECT * jika tidak perlu, gunakan SELECT kolom.
 *
 *
 * 📚 KASUS PENGGUNAAN NYATA
 * ------------------------------------------------------------
 * ✅ Digunakan pada:
 *   - Blog dan artikel (misal: pencarian judul/postingan)
 *   - Sistem pembelajaran (e-learning)
 *   - Marketplace (deskripsi produk)
 *   - Forum diskusi
 *   - Arsip dokumen
 *
 *
 * ✅ CONTOH QUERY FINAL:
 * ------------------------------------------------------------

SELECT *, MATCH(judul, isi) 
AGAINST('belajar database programming' IN NATURAL LANGUAGE MODE) AS relevansi
FROM artikel
ORDER BY relevansi DESC;
*/
 *
 *
 * ✨ PENUTUP
 * ------------------------------------------------------------
 * Full-Text Search dengan Natural Language Mode sangat cocok
 * untuk kebutuhan pencarian sederhana, cepat, dan relevan.
 * Meskipun tidak seteknis Boolean Mode, mode ini powerful
 * dalam sistem yang ingin memberikan hasil pencarian instan
 * berdasarkan makna kata dan tidak ribet.
 *
 */







