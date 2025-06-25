-- alias
-- ini mungkin belum terlalu berguna, tapi nanti ketita ada relasi table, maka akn berguna



-- 1. ini contoh untuk menamibplakn dataa ditable, dengn nama kolomnya
-- di aliaskan agar mudah dibaca dan singkat 
USE toko_online;
SELECT * FROM products;

SELECT 
    id AS kode,
    nama AS "nama produk", -- kalo mau spasi, maka pake kutip,
    category AS kategori,
    description AS deskripsi,
    price AS harga,
    quantity jumlah -- atau bisa juga ga pake as, tapi ini untuk keterbacaan, lebih baik pake
FROM products;
    

-- 2. atau bisa juga pake expresi, nih lihat

-- jadi kita akan membat kolom baru yg isinya itu adalah harga dari
price * jumlah dan dibagi 1000, jadi untuk 10k,20k, atau ribuan lah

SELECT id, nama,price,quantity, (price * quantity) / 1000 AS 'harga hasil' 
FROM products;




-- 3. membuat alias untuk table

SELECT 
    p.id AS kode,
    p.nama AS name,
    p.category AS kategori,
    p.description AS deskripsi,
    p.price AS harga,
    p.quantity jumlah
FROM products AS p;

-- jadi maksudnya adlaah kita ingin mengakses kolom pada tabel, tape mengunakan nama tabelnya
-- dan sebenarnya ketika kita inign mengakses kolom pada tabel, defaultnya dlah seperti ini
-- jadi kia akses berdasarkan tablenya

-- makanya kalo kita berelasi dnegna banyak tabel, kan ada dua tabel tuh, berati ketika kita ingin mengakses nama kolom dari setipa tabelnya
-- kita perlu meggunakan namatabel.namakolomnya
-- jadi agar tidak bentrok dan juga tidak kepanjangan, maka itu lah kegunaan alias

SELECT 
    products.id AS kode,
    products.nama AS name,
    products.category AS kategori,
    products.description AS deskripsi,
    products.price AS harga,
    products.quantity jumlah
FROM products;









 * =============================================
 *           MATERI: ALIAS (NAMA LAIN) DI MYSQL
 * =============================================
 *
 * Pengertian:
 * -----------
 * Alias adalah nama sementara yang diberikan untuk kolom atau tabel
 * agar query menjadi lebih singkat, jelas, dan mudah dibaca.
 *
 * Alias tidak mengubah nama asli kolom/tabel di database.
 * Alias hanya digunakan saat menampilkan hasil query.
 *
 * Alias ditulis menggunakan kata kunci "AS", atau tanpa AS (langsung).
 *
 * =====================================================
 *                1. ALIAS UNTUK KOLOM
 * =====================================================
 * Sintaks:
 *   SELECT nama_kolom AS nama_alias FROM nama_tabel;
 * atau:
 *   SELECT nama_kolom nama_alias FROM nama_tabel;
 *
 * Contoh:
 *   SELECT nama AS nama_pelanggan, kota AS asal_kota FROM pelanggan;
 *
 * Penjelasan:
 * - Menampilkan kolom `nama` dengan label `nama_pelanggan`
 * - dan kolom `kota` dengan label `asal_kota`
 *
 * Output:
 * +----------------+-----------+
 * | nama_pelanggan | asal_kota|
 * +----------------+-----------+
 * | Budi           | Jakarta  |
 *
 * =====================================================
 *               2. ALIAS TANPA AS
 * =====================================================
 * Bisa juga tanpa kata AS:
 *   SELECT nama nama_pelanggan FROM pelanggan;
 * Tapi disarankan menggunakan AS untuk keterbacaan.
 *
 * =====================================================
 *        3. ALIAS UNTUK EKSPRESI ATAU PERHITUNGAN
 * =====================================================
 * Contoh:
 *   SELECT harga * jumlah AS total_harga FROM penjualan;
 *
 * Penjelasan:
 * - `harga * jumlah` adalah ekspresi (hasil perkalian)
 * - Diberi alias `total_harga` agar hasil kolom lebih jelas
 *
 * =====================================================
 *         4. ALIAS UNTUK TABEL (TABLE ALIAS)
 * =====================================================
 * Alias tabel digunakan agar query lebih singkat,
 * terutama saat JOIN antar banyak tabel.
 *
 * Sintaks:
 *   SELECT t.nama FROM pelanggan AS t;
 *
 * Contoh penggunaan di JOIN:
 *   SELECT p.nama, o.total
 *   FROM pelanggan AS p
 *   JOIN orders AS o ON p.id = o.pelanggan_id;
 *
 * Penjelasan:
 * - `p` adalah alias dari `pelanggan`
 * - `o` adalah alias dari `orders`
 *
 * Alias tabel sangat membantu ketika:
 * ✅ Nama tabel panjang
 * ✅ Ada banyak join
 * ✅ Query kompleks
 *
 * =====================================================
 *         5. ALIAS UNTUK SUBQUERY (SUBQUERY ALIAS)
 * =====================================================
 * Alias juga bisa dipakai untuk subquery (SELECT di dalam SELECT).
 *
 * Contoh:
 *   SELECT * FROM (
 *     SELECT nama, kota FROM pelanggan
 *   ) AS data_pelanggan;
 *
 * Penjelasan:
 * - Subquery harus punya alias agar bisa digunakan
 *
 * =====================================================
 *         6. ALIAS DENGAN SPASI ATAU KHUSUS
 * =====================================================
 * Jika alias mengandung spasi atau karakter khusus, gunakan tanda kutip:
 *   SELECT nama AS "Nama Pelanggan Lengkap" FROM pelanggan;
 *
 * Bisa juga:
 *   SELECT nama AS `Nama Pelanggan` FROM pelanggan;
 *
 * =====================================================
 *         7. LATIHAN CONTOH TABEL & DATA
 * =====================================================
 * CREATE TABLE pelanggan (
 *   id INT PRIMARY KEY AUTO_INCREMENT,
 *   nama VARCHAR(100),
 *   kota VARCHAR(100),
 *   poin INT
 * );
 *
 * INSERT INTO pelanggan (nama, kota, poin) VALUES
 * ('Rafa', 'Bandung', 100),
 * ('Dina', 'Jakarta', 150),
 * ('Budi', 'Bandung', 200);
 *
 * Contoh query dengan alias:
 *   SELECT
 *     nama AS nama_pelanggan,
 *     kota AS asal,
 *     poin AS "Total Poin"
 *   FROM pelanggan;
 *
 * =====================================================
 *       8. PRAKTIK MENGGUNAKAN NODE.JS (mysql2)
 * =====================================================
 * Contoh pemakaian alias dalam query menggunakan Node.js:
 */

import mysql from "mysql2/promise";

(async () => {
  const conn = await mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "toko"
  });

  const [rows] = await conn.execute(`
    SELECT 
      id AS id_pelanggan,
      nama AS nama_lengkap,
      kota AS asal_kota,
      poin AS total_poin
    FROM pelanggan
  `);

  console.log("Hasil query dengan alias:");
  console.table(rows);

  await conn.end();
})();


 * =====================================================
 *                9. RANGKUMAN ALIAS
 * =====================================================
 * ✅ Alias digunakan untuk memberikan nama baru pada kolom/tabel di hasil query.
 * ✅ Tidak mengubah struktur atau nama asli di database.
 * ✅ Gunakan alias untuk:
 *    - Penyingkatan
 *    - Kejelasan
 *    - Hasil ekspresi perhitungan
 *    - Subquery
 * ✅ Gunakan `AS` untuk keterbacaan, walaupun tidak wajib.
 *
 * =======================
 *     SELESAI MATERI
 * =======================
 */









