-- where clausa 

-- https://chatgpt.com/c/685ab8eb-185c-8009-baee-c745db1480d9
-- nah WHERE adalah klausa dalam SQL yang digunakan untuk menyaring baris (rows) berdasarkan kondisi tertentu

-- jadi ketika kita mengambil data mneggunakan perintah sql select, terkadang kita ingin melakukan pencarian data
-- misal kita inign mengambil data barang yg harganya 3 jt, atau emngambil data barang yg quantitynya 0 / kosong stoknya
-- Untuk mengambil data yang relevan saja, memfilter hasil query, dan menghindari pengolahan data yang tidak dibutuhkan.
-- jadi where ini ditempatkan setelah kata kunci select


--strukturnya :
--SELECT kolom1, kolom2, ...
--FROM nama_tabel
--WHERE kondisi;

USE toko_online;

SELECT id, nama, price, quantity
FROM products
WHERE quantity = 100;

 -- jadi dia akan menampilkan data id,nama,price, dan quantity
-- yg jumlah quantitynya 100

SELECT nama
FROM products
WHERE quantity <= 100;
-- mencari yg quantitynya lebih kecil dari 100
-- dan kalo engga ada, maka tidak akan muncul datanya


SELECT *
FROM products
WHERE nama like 'm%';

-- jadi cari data yg awalnya itu adalah huruf m







/**

 *
 * WHERE digunakan untuk menyaring baris data berdasarkan kondisi tertentu.
 * WHERE sering digunakan dalam SELECT, UPDATE, DELETE.
 *
 * Format Umum:
 * -------------------------------------------
 * SELECT kolom1, kolom2
 * FROM nama_tabel
 * WHERE kondisi;
 * -------------------------------------------
 *
 * ========================
 *  Operator Perbandingan
 * ========================
 *
 * =     ➜ Sama dengan
 * !=    ➜ Tidak sama dengan (juga bisa pakai <>)
 * >     ➜ Lebih besar dari
 * <     ➜ Lebih kecil dari
 * >=    ➜ Lebih besar atau sama dengan
 * <=    ➜ Lebih kecil atau sama dengan
 *
 * Contoh:
 * SELECT * FROM produk WHERE harga > 50000;
 *
 * ============================
 *  Operator Logika (Boolean)
 * ============================
 *
 * AND     ➜ Semua kondisi harus benar
 * OR      ➜ Salah satu kondisi cukup benar
 * NOT     ➜ Membalik kondisi (negasi)
 *
 * Contoh:
 * SELECT * FROM pelanggan
 * WHERE umur > 18 AND kota = 'Jakarta';
 *
 * SELECT * FROM pelanggan
 * WHERE kota = 'Bandung' OR kota = 'Surabaya';
 *
 * SELECT * FROM user
 * WHERE NOT status = 'nonaktif';
 *
 * ======================
 *  Operator Khusus SQL
 * ======================
 *
 * 1. BETWEEN
 * -------------------------------
 * WHERE nilai BETWEEN 70 AND 100
 * ➜ Mencari nilai dari 70 sampai 100 (inklusif)
 *
 * 2. IN
 * --------------------------------
 * WHERE kota IN ('Jakarta', 'Bandung')
 * ➜ Sama seperti: kota = 'Jakarta' OR kota = 'Bandung'
 *
 * 3. LIKE
 * -----------------------
 * WHERE nama LIKE 'R%'      ➜ nama dimulai dengan huruf R
 * WHERE nama LIKE '_a%'     ➜ huruf kedua adalah 'a'
 *
 * `%` = wildcard banyak karakter
 * `_` = wildcard satu karakter
 *
 * 4. IS NULL / IS NOT NULL
 * ----------------------------------------
 * WHERE email IS NULL        ➜ Cek kolom yang kosong
 * WHERE email IS NOT NULL    ➜ Cek kolom yang ada isinya
 *
 * ⚠ NULL tidak bisa dibandingkan dengan `=`, gunakan IS NULL!
 *
 * ===============================
 *  Gunakan Kurung untuk Prioritas
 * ===============================
 *
 * SELECT * FROM pelanggan
 * WHERE (kota = 'Jakarta' OR kota = 'Bandung')
 * AND umur >= 18;
 *
 * Kurung membantu atur urutan evaluasi logika.
 *
 * ==========================
 *  WHERE pada Perintah Lain
 * =========================
 *
 * Digunakan juga dalam:
 *
 * UPDATE:
 * -------------------------------------
 * UPDATE produk
 * SET stok = stok - 1
 * WHERE id_produk = 'P001';
 *
 * DELETE:
 * -------------------------------------
 * DELETE FROM pelanggan
 * WHERE status = 'nonaktif';
 *
 * ========================
 *  Contoh Studi Kasus Mini
 * ========================
 *
 * Tabel: penjualan
 * +----+-------------+--------+--------+----------+------------+
 * | id | produk      | jumlah | harga  | kota     | tanggal    |
 * +----+-------------+--------+--------+----------+------------+
 * | 1  | Mie Ayam    | 2      | 15000  | Jakarta  | 2025-06-01 |
 * | 2  | Bakso       | 3      | 18000  | Surabaya | 2025-06-02 |
 * | 3  | Nasi Goreng | 1      | 20000  | Jakarta  | 2025-06-03 |
 * | 4  | Mie Ayam    | 4      | 15000  | Bandung  | 2025-06-04 |
 * +----+-------------+--------+--------+----------+------------+
 *
 * Contoh Query:
 * 1. Penjualan di Jakarta:
 *    SELECT * FROM penjualan WHERE kota = 'Jakarta';
 *
 * 2. Penjualan Mie Ayam jumlah > 2:
 *    SELECT * FROM penjualan
 *    WHERE produk = 'Mie Ayam' AND jumlah > 2;
 *
 * 3. Penjualan dengan harga antara 15000 - 20000:
 *    SELECT * FROM penjualan
 *    WHERE harga BETWEEN 15000 AND 20000;
 *
 * =================================
 *  Tips dan Best Practice WHERE
 * =================================
 *
 * ✅ Gunakan WHERE untuk efisiensi data
 * ✅ Pakai indeks di kolom yang sering difilter
 * ✅ Hindari SELECT * jika tidak perlu semua kolom
 * ✅ Gunakan tanda kurung jika ada kombinasi AND & OR
 * ✅ Gunakan `IS NULL` / `IS NOT NULL` untuk pengecekan kosong
 *
 * ❌ Hindari perbandingan NULL dengan `=`
 * ❌ Hindari logika rumit tanpa tanda kurung
 *
 * ========================================
 *  Kesimpulan:
 * - WHERE sangat penting untuk menyaring data.
 * - Bisa digunakan di SELECT, UPDATE, DELETE.
 * - Bisa dikombinasikan dengan operator perbandingan, logika, dan spesial.
 * - Kunci efisiensi dan keamanan dalam pengambilan data.
 *
 */
