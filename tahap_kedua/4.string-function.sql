-- https://dev.mysql.com/doc/refman/8.4/en/string-functions.html
-- https://chatgpt.com/c/685d4a30-4324-8009-91d5-59907ec1a133



USE toko_online;

DESCRIBE products;

SELECT * FROM products;



SELECT nama, category, upper(category) AS `gede-category` FROM products; 



 * Fungsi-fungsi string di MySQL digunakan untuk memanipulasi,
 * mengolah, dan menganalisis data bertipe teks (VARCHAR, TEXT, dsb).
 *
 * Digunakan dalam SELECT, WHERE, INSERT, UPDATE, dsb.
 *


 * 1. CHAR_LENGTH(str) / CHARACTER_LENGTH(str)
 *    - Menghitung jumlah karakter (bukan byte) dalam string.
 *    - Cocok untuk string multi-byte seperti UTF-8.
 */
-- SELECT CHAR_LENGTH('Halo Dunia'); -- Hasil: 10


 * 2. LENGTH(str)
 *    - Mengembalikan panjang string dalam byte, bukan karakter.
 *    - 'abc' = 3, tapi '你好' = 6 karena UTF-8
 */
-- SELECT LENGTH('Hello'); -- Hasil: 5

 * 3. LOWER(str) / LCASE(str)
 *    - Mengubah semua huruf menjadi huruf kecil.

 * 4. UPPER(str) / UCASE(str)
 *    - Mengubah semua huruf menjadi huruf besar.
 */
-- SELECT UPPER('Halo dunia'); -- 'HALO DUNIA'

 * 5. LEFT(str, n)
 *    - Mengambil n karakter dari kiri.
 */
-- SELECT LEFT('Belajar MySQL', 7); -- 'Belajar'


 * 6. RIGHT(str, n)
 *    - Mengambil n karakter dari kanan.
 */
-- SELECT RIGHT('Belajar MySQL', 5); -- 'MySQL'

/**
 * 7. MID(str, start, len) / SUBSTRING(str, start, len)
 *    - Mengambil bagian string mulai dari posisi tertentu.
 */
-- SELECT MID('Belajar SQL', 9, 3); -- 'SQL'


 * 8. SUBSTRING_INDEX(str, delimiter, count)
 *    - Memecah string berdasarkan delimiter lalu ambil bagian tertentu. pake index
 */
-- SELECT SUBSTRING_INDEX('a,b,c,d', ',', 2); -- 'a,b'
-- SELECT SUBSTRING_INDEX('a/b/c', '/', -1);  -- 'c'


 * 9. LOCATE(substr, str) / POSITION(substr IN str)
 *    - Menentukan posisi substr dalam str.
 *    - Posisi dihitung mulai dari 1.
 */
-- SELECT LOCATE('SQL', 'Belajar SQL'); -- 9

 * 10. INSTR(str, substr)
 *     - Sama seperti LOCATE, tapi argumennya dibalik.
 */
-- SELECT INSTR('Halo Dunia', 'Dunia'); -- 6

 * 11. REPLACE(str, from_str, to_str)
 *     - Mengganti semua kemunculan from_str dengan to_str.
 */
-- SELECT REPLACE('Aku belajar PHP', 'PHP', 'MySQL'); -- 'Aku belajar MySQL'


 * 12. REPEAT(str, count)
 *     - Mengulang string sebanyak count kali.
 */
-- SELECT REPEAT('A', 5); -- 'AAAAA'


 * 13. CONCAT(str1, str2, ...)
 *     - Menggabungkan beberapa string.
 */

 * 14. CONCAT_WS(separator, str1, str2, ...)
 *     - Sama seperti CONCAT tapi dengan pemisah (separator).
 */
-- SELECT CONCAT_WS('-', '2025', '06', '26'); -- '2025-06-26'

 * 15. TRIM([LEADING | TRAILING | BOTH] str FROM str)
 *     - Menghapus spasi (atau karakter lain) dari kiri/kanan string.
 */
-- SELECT TRIM('  Halo  '); -- 'Halo'
-- SELECT TRIM(BOTH 'a' FROM 'aaHaloaa'); -- 'Halo'

 * 16. LPAD(str, len, padstr)
 *     - Menambahkan karakter di kiri agar panjang jadi len.
 */
-- SELECT LPAD('7', 3, '0'); -- '007'

 * 17. RPAD(str, len, padstr)
 *     - Menambahkan karakter di kanan agar panjang jadi len.
 */
-- SELECT RPAD('Hi', 5, '!'); -- 'Hi!!!'

 * 18. REVERSE(str)
 *     - Membalik urutan karakter.
 */
-- SELECT REVERSE('abcde'); -- 'edcba'


 * 19. ELT(index, str1, str2, ...)
 *     - Mengambil elemen ke-index dari list string.
 */
-- SELECT ELT(2, 'apel', 'jeruk', 'mangga'); -- 'jeruk'


 * 20. FIELD(str, str1, str2, ...)
 *     - Mencari posisi str di antara argumen lainnya.
 *     - Mirip indexOf.
 */
-- SELECT FIELD('jeruk', 'apel', 'jeruk', 'mangga'); -- 2


 * 21. FIND_IN_SET(str, strlist)
 *     - Mencari posisi str dalam daftar yang dipisah koma.
 */
-- SELECT FIND_IN_SET('jeruk', 'apel,jeruk,mangga'); -- 2


 * 22. MAKE_SET(bits, str1, str2, ...)
 *     - Mengembalikan string berdasarkan bit posisi yang aktif.
 */
-- SELECT MAKE_SET(5, 'A', 'B', 'C'); -- bit 1 dan 3 aktif => 'A,C'


 * 23. QUOTE(str)
 *     - Menambahkan tanda kutip di sekitar string & escapement karakter.
 */
-- SELECT QUOTE("O'Reilly"); -- "'O\'Reilly'"

  * 24. ASCII(str)
  *     - Mengembalikan nilai ASCII karakter pertama dari string.
  */
-- SELECT ASCII('A'); -- 65

 * 25. BIN(N) / OCT(N) / HEX(N)
 *     - Mengubah angka menjadi biner, oktal, atau heksadesimal.
 */
-- SELECT BIN(10); -- '1010'
-- SELECT OCT(10); -- '12'
-- SELECT HEX(255); -- 'FF'


 * 26. UNHEX(hex)
 *     - Mengonversi nilai heksadesimal ke string biner.
 */
-- SELECT UNHEX('4D7953514C'); -- 'MySQL'


 * 27. CHAR(N, ...)
 *     - Mengembalikan karakter berdasarkan nilai ASCII.
 */
-- SELECT CHAR(72, 105); -- 'Hi'


 * 28. EXPORT_SET(bits, on, off, separator, number_of_bits)
 *     - Konversi bit ke representasi teks (mirip boolean string).
 */
-- SELECT EXPORT_SET(6, 'Y', 'N', ',', 4); -- 'N,Y,Y,N'


 * 29. INSERT(str, pos, len, newstr)
 *     - Menyisipkan newstr ke str pada posisi tertentu dan menggantikan len karakter.
 */
-- SELECT INSERT('Hello World', 7, 5, 'MySQL'); -- 'Hello MySQL'

 * 30. FORMAT(X, D)
 *     - Mengubah angka menjadi string format ribuan dan desimal.
 */
-- SELECT FORMAT(1234567.891, 2); -- '1,234,567.89'

 * 31. SOUNDEX(str)
 *     - Menghasilkan kode soundex (pengucapan) dari string.
 *     - Berguna untuk pencarian fonetik (suara mirip).
 */
-- SELECT SOUNDEX('Robert'), SOUNDEX('Rupert'); -- sama: 'R163'


 * 32. SPACE(N)
 *     - Mengembalikan string berisi N spasi.
 */
-- SELECT CONCAT('A', SPACE(3), 'B'); -- 'A   B'


 * 33. STRCMP(str1, str2)
 *     - Membandingkan dua string.
 *     - 0: sama, 1: str1 > str2, -1: str1 < str2
 */
-- SELECT STRCMP('abc', 'abd'); -- -1


 * 34. JSON_QUOTE(str)
 *     - Mengubah string jadi representasi aman JSON (dengan escape karakter).
 */
-- SELECT JSON_QUOTE('Halo "Dunia"'); -- '"Halo \"Dunia\""'
 
 
 
 


 * https://dev.mysql.com/doc/refman/8.4/en/string-functions.html
 *
 * Fungsi regex sangat bertenaga untuk pencarian,
 * ekstraksi, dan penggantian pola kompleks di string.


// ————————————————————————————————————————————————————————————————
// 1. REGEXP / RLIKE (operator)
//    - Mengecek apakah string cocok pola regex (boolean).
//    - Case-insensitive secara default.
//    - Bisa digabung dengan BINARY untuk sensitif huruf.
//    - Syntax: expr REGEXP 'pattern'
//    - Alias: RLIKE
//
// Contoh:
// SELECT name FROM users WHERE name REGEXP '^Sa' ;
//  => mencari nama yang dimulai dengan 'Sa' :contentReference[oaicite:1]{index=1}
//
// Select case sensitive:
// SELECT * FROM author WHERE aut_name REGEXP BINARY '^w' ;
//  => hanya huruf 'w' kecil :contentReference[oaicite:2]{index=2}

// ————————————————————————————————————————————————————————————————
// 2. REGEXP_LIKE(str, pattern [, match_type])
//    - Fungsi seperti REGEXP, tapi lebih fleksibel.
//    - match_type opsi: 'c','i','m','n','u' (case/multi-line/etc).
//
// Contoh:
// SELECT * FROM actor
//  WHERE REGEXP_LIKE(last_name, 'son$', 'i');
// => cari last_name yang berakhiran "son", tanpa peduli case :contentReference[oaicite:3]{index=3}

// ————————————————————————————————————————————————————————————————
// 3. REGEXP_INSTR(expr, pattern [, start, occurrence, return_option, match_type])
//    - Kembalikan posisi awal cocoknya pola regex.
//    - 0 jika tidak cocok.
//
// Contoh:
// SELECT id, last_name,
//        REGEXP_INSTR(last_name, '[aeiou]', 1, 1, 0, 'i') AS pos_vokal
// FROM actor;
// => pos pertama huruf vokal di last_name :contentReference[oaicite:4]{index=4}

// ————————————————————————————————————————————————————————————————
// 4. REGEXP_SUBSTR(str, pattern [, start, occurrence, match_type])
//    - Ekstrak substring yang cocok pola regex.
//
// Contoh:
// SELECT REGEXP_SUBSTR('abc123xyz', '[0-9]+'); -- '123'
// SELECT REGEXP_SUBSTR('one two three four', '[a-z]+', 5, 2); -- 'three'
// SELECT REGEXP_SUBSTR('Cat bat rat', 'cat', 1, 1, 'i'); -- 'Cat'
// :contentReference[oaicite:5]{index=5}

// ————————————————————————————————————————————————————————————————
// 5. REGEXP_REPLACE(expr, pattern, repl [, pos, occurance, match_type])
//    - Ganti bagian string yang cocok pola regex.
//    - Sangat berguna untuk cleansing data, format, dsb.
//
// Contoh:
// SELECT REGEXP_REPLACE('123-456-7890', '[0-9]', 'X'); 
// => 'XXX-XXX-XXXX' :contentReference[oaicite:6]{index=6}
//
// SELECT REGEXP_REPLACE('hello  2025 world', '\\d+', 'YYYY');
// => 'hello  YYYY world'

// ————————————————————————————————————————————————————————————————
// 🧩 PENDEKATAN REGEX DASAR (dari regex MySQL / ICU)
//    ^, $, ., *, +, ?, {m,n}, [abc], [^...], ranges, alternation |
//    Word boundary: [[:<:]], [[:>:]] :contentReference[oaicite:7]{index=7}
//
// Contoh:
// SELECT * FROM movies_tbl WHERE title REGEXP '[[:<:]]for';  // kata mulai 'for'
// SELECT * FROM movies_tbl WHERE title REGEXP 'ack[[:>:]]'; // kata akhir 'ack'
// :contentReference[oaicite:8]{index=8}

// ————————————————————————————————————————————————————————————————
// 📚 KASUS NYATA (Studi Kasus):
//
// 1) Validasi format email:
const emailQuery = `
SELECT email
FROM users
WHERE NOT REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')`;
// => temukan email invalid
//
// 2) Ekstrak domain dari email:
const domainQuery = `
SELECT REGEXP_SUBSTR(email, '@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}') AS domain
FROM users`; 
// => '@example.com'
//
// 3) Masking nomor HP (ganti huruf jadi X kecuali 4 digit akhir):
const maskHP = `
SELECT REGEXP_REPLACE(phone, '\\d(?=\\d{4})', 'X') AS masked
FROM contacts`;
// Contoh: '081234567890' -> 'XXXXXX7890'
//
// 4) Temukan data import yang duplikat kesalahan format YYYY-MM-DD:
const dateQuery = `
SELECT item, import_date
FROM import_log
WHERE import_date NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'`;
// Temukan baris yang salah format tanggal
//
// 5) Hapus whitespace ganda dalam teks:
const collapseSpaces = `
SELECT REGEXP_REPLACE(notes, '[[:space:]]{2,}', ' ') AS cleaned
FROM reports`; 
// Bersihkan spasi ganda

 * | Fungsi/operator      | Hasil                     | Contoh penggunaan                       |
 * |----------------------|---------------------------|-----------------------------------------|
 * | expr REGEXP pat      | 1/0 (boolean)             | WHERE email REGEXP '^admin@'           |
 * | RLIKE alias          | sama                      | same as above                          |
 * | REGEXP_LIKE()        | boolean, match_type       | lihat di atas                          |
 * | REGEXP_INSTR()       | int posisi awal / 0       | pos vokal pertama                      |
 * | REGEXP_SUBSTR()      | substring cocok           | ekstrak angka                          |
 * | REGEXP_REPLACE()     | string setelah ganti pola | masking/noise cleaning                 |
 *
 * Perlu dicatat:
 * - Regex MySQL berbasis ICU → mendukung full Unicode :contentReference[oaicite:9]{index=9}
 * - Menggunakan POSIX syntax + ICU features
 * - escape `\` jadi `\\` di SQL string literal
 * - Gunakan anchoring `^`, `$` dan match_type untuk kontrol lebih kuat
 * - Optimalkan performance dengan `EXPLAIN`, hindari full-scan besar
 */

 

 * ============================================
 *               CATATAN TAMBAHAN
 * ============================================
 * - Fungsi-fungsi ini sangat krusial dalam:
 *   - Pembersihan data (cleansing)
 *   - Pencarian (search/filter)
 *   - Pemformatan data output
 *   - Pembuatan laporan (reporting)
 *   - Validasi data string
 *
 * - Semua fungsi ini bisa digabungkan dalam query
 *   untuk manipulasi string yang kompleks.
 */







