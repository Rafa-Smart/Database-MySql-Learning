

https://dev.mysql.com/doc/refman/8.4/en/fulltext-boolean.html

SELECT * FROM artikel;

USE toko_online; 
SELECT * FROM artikel
WHERE MATCH(judul, isi)
    against('+database -responsive' IN boolean mode);

-- atau conoth lain

SELECT * FROM artikel
WHERE match(judul, isi)
    against('+database -nosql' IN boolean mode);

-- atau awalan prog

SELECT * FROM artikel
WHERE match(judul, isi)
    against('prog*' IN boolean mode);

-- Cari kata yang dimulai dengan "data"
SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('data*' IN BOOLEAN MODE);



*
 * 🔍 APA ITU FULL-TEXT SEARCH IN BOOLEAN MODE?
 * ------------------------------------------------------------
 * Ini adalah salah satu mode dari Full-Text Search (FTS) di MySQL
 * yang memungkinkan kamu melakukan pencarian teks dengan
 * **kontrol penuh menggunakan operator logika (boolean)**.
 *
 * ➕ Dibandingkan NATURAL LANGUAGE MODE, boolean mode memungkinkan:
 *   - pencarian wajib
 *   - pengecualian kata
 *   - pencarian wildcard (*)
 *   - pengelompokan hasil dengan +, -, "", *, dsb.
 *
 *
 * 🧠 CARA KERJANYA:
 * ------------------------------------------------------------
 * - Input query dianggap sebagai kumpulan **istilah logika**.
 * - MySQL mencocokkan baris yang sesuai dengan aturan tersebut.
 * - Tidak dihitung relevansi skor (hasil = TRUE atau FALSE).
 *
 * 💡 Full control tanpa pemrosesan semantik atau relevansi otomatis.
 *
 *
 * 🔧 SINTAKS DASAR:
 * ------------------------------------------------------------
 *     MATCH(kolom1, kolom2, ...)
 *     AGAINST('query boolean' IN BOOLEAN MODE)
 *
 *
 * ✅ CONTOH PRAKTIS DASAR:
 * ------------------------------------------------------------
// Mencari artikel yang mengandung kata 'database'

SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('database' IN BOOLEAN MODE);
*/

// Mencari yang mengandung 'database' DAN 'mysql'

SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('+database +mysql' IN BOOLEAN MODE);
*/

// Mengandung 'database' TAPI TIDAK 'nosql'

SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('+database -nosql' IN BOOLEAN MODE);
*/

// Mencari frasa spesifik "sql injection"

SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('"sql injection"' IN BOOLEAN MODE);
*/

// Kata dengan awalan 'prog'

SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('prog*' IN BOOLEAN MODE);
*/
 *
 *
 * 🧩 DAFTAR OPERATOR BOOLEAN
 * ------------------------------------------------------------
 *
 * | Operator  | Fungsi                                               | Contoh                        |
 * |-----------|------------------------------------------------------|-------------------------------|
 * | +         | Kata wajib muncul                                    | '+mysql +database'            |
 * | -         | Kata harus tidak muncul                              | '+mysql -nosql'               |
 * | "..."     | Frasa tepat (exact phrase)                           | '"sql injection"'             |
 * | *         | Wildcard untuk awalan kata (bukan tengah/akhir)      | 'prog*' → program, programming|
 * | > <       | Menandai prioritas relatif (jarang digunakan)       | '>mysql <nosql'               |
 * | ()        | Pengelompokan ekspresi                               | '+(php mysql)'                |
 * | ~         | Kurangi nilai relevansi (jika pakai ranking)         | '~php'                        |
 * | @weight   | Prioritas manual (InnoDB only, jarang dipakai)       | 'php@2 mysql@5'               |
 *
 *
 * 📌 PENTING:
 * ------------------------------------------------------------
 * - Semua kata akan dicocokkan secara literal (bukan semantik).
 * - Tidak ada relevansi otomatis (scoring), hanya TRUE/FALSE.
 * - Semua operator harus ditulis dalam string query boolean.
 * - Case-insensitive.
 *
 *
 * ✅ PERBEDAAN DENGAN NATURAL LANGUAGE MODE
 * ------------------------------------------------------------

 * | Aspek              | BOOLEAN MODE                    | NATURAL LANGUAGE MODE               |
 * |--------------------|----------------------------------|--------------------------------------|
 * | Relevansi Skor     | ❌ Tidak dihitung otomatis       | ✅ Ya, dihitung                      |
 * | Kontrol Pengguna   | ✅ Sangat tinggi (operator logika)| ❌ Terbatas, tanpa kontrol logika   |
 * | Pencarian Frasa    | ✅ Ya ("kata kata")              | ❌ Tidak                            |
 * | Pencarian Wajib    | ✅ (+ dan -)                     | ❌ Tidak bisa                       |
 * | Wildcard Support   | ✅ Ya (* akhir kata)             | ❌ Tidak bisa                       |
 * | Kinerja            | ✅ Sangat cepat                  | ✅ Cepat, tapi bisa lebih berat     |
 *
 *
 * 🎯 KAPAN HARUS GUNAKAN BOOLEAN MODE?
 * ------------------------------------------------------------
 * ✅ Saat kamu butuh:
 *   - Mencari frasa yang persis ("...")
 *   - Mengatur kata wajib atau harus tidak muncul
 *   - Pencarian dengan wildcard (misal prog* → programming)
 *   - Pencarian kompleks seperti `(php mysql) -laravel`
 *   - Sistem pencarian internal seperti admin panel, backend tools
 *
 *
 * ❌ TIDAK cocok jika:
 *   - Kamu ingin pencarian otomatis dan simpel oleh user umum
 *   - Kamu butuh hasil dengan urutan berdasarkan relevansi otomatis
 *
 *
 * 📌 CATATAN TEKNIS TAMBAHAN
 * ------------------------------------------------------------
 * - Harus ada FULLTEXT INDEX di kolom yang digunakan dalam MATCH().
 * - Kata lebih pendek dari `ft_min_word_len` akan diabaikan (default: 4).
 * - Stopwords tetap diabaikan.
 * - Engine harus InnoDB atau MyISAM.
 * - Jika ingin mencari `sql` (3 huruf), kamu perlu ubah `ft_min_word_len`.
 *
 *
 * 🔐 KELEBIHAN BOOLEAN MODE
 * ------------------------------------------------------------
 * ✅ Lebih fleksibel dan powerful untuk kontrol pencarian.
 * ✅ Cocok untuk sistem pencarian tingkat lanjut.
 * ✅ Dapat mencari kata dengan awalan tertentu.
 *
 * ❌ KEKURANGAN BOOLEAN MODE
 * ------------------------------------------------------------
 * ❌ Perlu pemahaman syntax (tidak cocok untuk pengguna awam).
 * ❌ Tidak memberi skor relevansi otomatis.
 * ❌ Tidak bisa digunakan untuk ranking berdasarkan konteks.
 *
 *
 * ✅ LATIHAN QUERY LANJUTAN
 * ------------------------------------------------------------


-- Cari yang mengandung kata "javascript" atau "python"
SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('javascript python' IN BOOLEAN MODE);

-- Cari yang mengandung "programming" tapi tidak "oop"
SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('+programming -oop' IN BOOLEAN MODE);

-- Cari frasa persis "sql injection"
SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('"sql injection"' IN BOOLEAN MODE);

-- Cari kata yang dimulai dengan "data"
SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('data*' IN BOOLEAN MODE);
*/

 *
 * 🧠 BEST PRACTICES
 * ------------------------------------------------------------
 * - Gunakan Boolean Mode untuk sistem pencarian lanjutan internal.
 * - Selalu beri pelatihan/petunjuk pada pengguna soal operator.
 * - Kombinasikan dengan NATURAL LANGUAGE MODE di sisi frontend (opsional).
 * - Hindari mencampur LIKE dengan MATCH() karena hasil bisa tidak konsisten.
 *
 *
 * ✨ PENUTUP
 * ------------------------------------------------------------
 * BOOLEAN MODE adalah mode pencarian full-text paling fleksibel di MySQL.
 * Ia memberikan kemampuan logika seperti wajib, dikecualikan, frasa, wildcard,
 * dan pengelompokan. Cocok untuk sistem pencarian yang memerlukan kontrol tinggi.
 * Namun, jangan digunakan untuk user awam tanpa pelatihan karena syntax bisa membingungkan.
 *
 */









