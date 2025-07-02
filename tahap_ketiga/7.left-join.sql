


-- disini kita tambahkan data baru ke products
-- yang belum berelasi ke tabel category

SELECT * FROM products;
INSERT INTO products (id,nama,indikasi,description,price,quantity) 
-- sengaja dilewat untuk masukan data id_category nya
VALUES ('xxx1','bubur ayam', 'murah', 'bubur ayam pak jo', 13000, 10),
       ('xxx2','bubur ayam2', 'murah2', 'bubur ayam pak jo2', 13000, 30)
       ('xxx3','bubur ayam2', 'murah2', 'bubur ayam pak jo2', 13000, 8);

-- jadi left join ini kna mengambil seluruh data yang inner join
-- tapi juga mengambil seluruh data yang ada di tabel pertama atau kiri
-- jadi kalo ada data di tabel kiri yang datanya barisnya punya relasi
-- ke tabel kedua atau tabel kanan, maka akn ditambilkan
-- tapi juga ketika ada data di tabel kiri (pertama) yang tidak punya relasi ke tabel kanan
-- maka akn ditampilkan juga tapi pad akolom yang harusnya berelasi
-- akan DISINI DENGAN NULL


use toko_online;
SELECT * FROM products;
-- cara biasa
SELECT p.id AS `id produk`,
       p.nama AS `nama produk`,
       pjln.jumlah `jumlah beli`, 
       pjln.harga `harga produk`, 
       (pjln.harga * pjln.jumlah) AS `total beli`
       FROM products AS p
       INNER JOIN penjualan AS pjln ON (pjln.id_products = p.id);

SELECT p.nama AS nama, p.id_category, c.nama AS categorynya
FROM products AS p
INNER JOIN category AS c ON (p.id_category = c.id);

-- cara kedua, lihat bedanya
SELECT p.id AS `id produk`,
       p.nama AS `nama produk`,
       pjln.jumlah `jumlah beli`, 
       pjln.harga `harga produk`, 
       (pjln.harga * pjln.jumlah) AS `total beli`
       FROM products AS p
       left JOIN penjualan AS pjln ON (pjln.id_products = p.id);

SELECT p.nama AS nama, p.id_category, c.nama AS categorynya
FROM products AS p
LEFT JOIN category AS c ON (p.id_category = c.id);

-- jadi fungsinya adllah untuk melihat data yang ada ditabel kiri
-- yang belum berelasi di tabel kanan

-- disini melihat produk yang belum punya category




`LEFT JOIN` adalah salah satu jenis JOIN di SQL yang digunakan
untuk menggabungkan dua tabel, di mana:

➡️ **Semua data dari tabel kiri (LEFT TABLE)** akan ditampilkan,
➡️ Dan hanya **data yang cocok dari tabel kanan (RIGHT TABLE)** yang ditampilkan.

🧩 Jika tidak ada kecocokan dari tabel kanan,
maka hasilnya tetap ditampilkan, tapi nilainya menjadi `NULL`.

---------------------------------------------------------

🔍 2. BAGAIMANA CARA KERJANYA?
---------------------------------------------------------
Misalkan kita punya dua tabel: `products` dan `category`

- `products` memiliki kolom `category` yang mereferensikan `category.id`
- Jika ada produk yang **belum punya kategori**, `LEFT JOIN` tetap akan menampilkan produknya

📌 PERBEDAAN DENGAN INNER JOIN:
- INNER JOIN: hanya tampilkan yang cocok
- LEFT JOIN: semua dari kiri, cocok atau tidak cocok tetap muncul

---------------------------------------------------------

🎯 3. KENAPA HARUS MENGGUNAKAN LEFT JOIN?
---------------------------------------------------------
✅ Digunakan saat:
- Ingin melihat semua data dari satu tabel utama (misal: produk)
- Ingin tahu mana data yang **tidak punya relasi**
- Berguna untuk **laporan**, **analisis data kosong**, **debugging relasi**

🧾 Contoh Kasus:
- Menampilkan semua produk, termasuk yang belum diberi kategori
- Menampilkan semua customer, termasuk yang belum pernah beli produk

---------------------------------------------------------

📦 4. STRUKTUR CONTOH DATABASE
---------------------------------------------------------
*/

-- Tabel kategori
CREATE TABLE category (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nama VARCHAR(100) NOT NULL
);

-- Tabel produk
CREATE TABLE products (
    id VARCHAR(10) PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    category INT, -- Boleh NULL
    CONSTRAINT fk_category FOREIGN KEY (category) REFERENCES category(id)
);


---------------------------------------------------------
🧪 5. CONTOH DATA
---------------------------------------------------------
*/

-- Isi kategori
INSERT INTO category (nama) VALUES
('Makanan Berat'),    -- id = 1
('Berkuah'),          -- id = 2
('Camilan');          -- id = 3

-- Isi produk (beberapa belum punya kategori)
INSERT INTO products (id, nama, category) VALUES
('p001', 'Mie Goreng Jawa', 1),
('p002', 'Bakso Mercon', 2),
('p003', 'Tahu Gejrot', 3),
('p004', 'Produk Tidak Diketahui', NULL); -- Produk tanpa kategori


---------------------------------------------------------
🔗 6. QUERY LEFT JOIN
---------------------------------------------------------
Tampilkan semua produk beserta nama kategorinya, 
termasuk produk yang tidak punya kategori.

SYNTAX:
SELECT ...
FROM tabel_kiri
LEFT JOIN tabel_kanan
ON tabel_kiri.kolom = tabel_kanan.kolom;
*/

SELECT 
    p.id AS id_produk,
    p.nama AS nama_produk,
    c.nama AS kategori
FROM products p
LEFT JOIN category c ON p.category = c.id;


---------------------------------------------------------
📈 7. HASIL OUTPUT:

| id_produk | nama_produk           | kategori        |
|-----------|------------------------|-----------------|
| p001      | Mie Goreng Jawa        | Makanan Berat   |
| p002      | Bakso Mercon           | Berkuah         |
| p003      | Tahu Gejrot            | Camilan         |
| p004      | Produk Tidak Diketahui| NULL            | ← Ini keunggulan LEFT JOIN!

🟢 Terlihat bahwa `p004` tetap ditampilkan walau tidak punya kategori.
📌 Kalau kita pakai INNER JOIN, maka `p004` tidak akan muncul.

---------------------------------------------------------

📊 8. KAPAN TIDAK DIGUNAKAN?
---------------------------------------------------------
❌ Jangan pakai LEFT JOIN jika:
- Hanya butuh data yang sudah berelasi
- Ingin menghindari NULL
→ Dalam kasus ini gunakan INNER JOIN.

---------------------------------------------------------

🔄 9. PERBANDINGAN JOIN

| JOIN TYPE   | APA YANG TAMPIL?                             |
|-------------|-----------------------------------------------|
| INNER JOIN  | Hanya data yang cocok di kedua tabel         |
| LEFT JOIN   | Semua data dari kiri + data cocok dari kanan |
| RIGHT JOIN  | Semua dari kanan + data cocok dari kiri      |
| FULL JOIN*  | Semua data dari kedua sisi (tidak didukung native oleh MySQL)

---------------------------------------------------------

✅ 10. KESIMPULAN
---------------------------------------------------------
- LEFT JOIN sangat penting untuk melihat **semua data utama**,
  termasuk yang **belum berelasi**.
- Digunakan untuk debugging data yang hilang, laporan penuh, dll.
- Sangat umum dalam aplikasi CRUD, laporan, dan sistem informasi.

=========================================================
*/











