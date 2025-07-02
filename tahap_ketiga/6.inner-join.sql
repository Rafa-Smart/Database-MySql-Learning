


-- jadi inner join adalah mekaisme dimana akan menyeleksi atau menampilkan hanya jika 
-- terdapat data yang berelasi pada kedua table atau lebih, jadi kalo engga berelasi
-- maka ga akan ditampilkan

-- dan ini adlah default join yang ada di mysql
-- jadi kalo hanya ketik join, itu artinya inner join


-- jadi misal ada 2 tabel nah tabel category dan tabel products
-- kalo kita menggunakan inner join, maka data yang dihasilkan hanyalah
-- data data tabel yang berelasi antara tabel category dan tabel products
-- jadi kalo data pada tabel pertama tidak punya relasi ke tabel kedua, maka tidak akn ditampilkan
-- dan begitu pula sebaliknya




-- tolong baca seleuruh penjelasan yang ad adibawah ini
use toko_online;
SELECT c.first_name AS `nama`,
       p.id AS `id produk`,
       c.id AS `id customer`, 
       pjln.jumlah `jumlah beli`, 
       pjln.harga `harga produk`, 
       (pjln.harga * pjln.jumlah) AS `total beli`
       FROM penjualan AS pjln
       INNER JOIN products AS p ON (p.id = pjln.id_products)
       INNER JOIN customer AS c ON (c.id = pjln.id_customer);




🧠 1. APA ITU INNER JOIN?
---------------------------------------------------------
`INNER JOIN` adalah jenis JOIN yang paling umum digunakan 
untuk menggabungkan baris data dari dua (atau lebih) tabel 
berdasarkan kolom yang saling berelasi.

📌 Tujuan: Mengambil data dari beberapa tabel dan menampilkan 
baris yang memiliki kecocokan di antara tabel-tabel tersebut.

---------------------------------------------------------

🔍 2. BAGAIMANA CARA KERJANYA?
---------------------------------------------------------
- MySQL akan mencari data dari dua tabel yang memiliki nilai 
  yang **sama** pada kolom relasi.
- Hanya **data yang cocok di kedua tabel** yang akan ditampilkan.

📌 Jika tidak ada pasangan yang cocok, baris itu **tidak akan muncul**.

---------------------------------------------------------

🎯 3. KENAPA HARUS MENGGUNAKAN INNER JOIN?
---------------------------------------------------------
✅ Digunakan saat:
- Ingin menggabungkan data dari dua tabel yang terhubung.
- Hanya ingin melihat data yang valid / memiliki relasi.
- Ingin menghindari NULL atau data "tidak lengkap".

🧾 Misalnya:
- Menampilkan daftar pesanan lengkap dengan nama pelanggan.
- Menampilkan produk beserta kategori-nya.
- Menggabungkan transaksi dengan informasi pengguna.

---------------------------------------------------------

📦 4. CONTOH STRUKTUR DATABASE
---------------------------------------------------------
Kita gunakan 2 tabel: `products` dan `category`

- Tabel `products`: menyimpan daftar produk
- Tabel `category`: menyimpan jenis kategori produk
- Setiap produk memiliki kolom `category` yang mereferensikan `category.id`

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
    category INT,
    CONSTRAINT fk_category FOREIGN KEY (category) REFERENCES category(id)
);


---------------------------------------------------------
🧪 5. CONTOH DATA
---------------------------------------------------------
*/

-- Isi data kategori
INSERT INTO category (nama) VALUES
('Makanan Berat'),    -- id = 1
('Berkuah'),          -- id = 2
('Camilan');          -- id = 3

-- Isi data produk
INSERT INTO products (id, nama, category) VALUES
('p001', 'Mie Goreng Jawa', 1),
('p002', 'Bakso Mercon', 2),
('p003', 'Tahu Gejrot', 3),
('p004', 'Sate Ayam', 1);


---------------------------------------------------------
🔗 6. CONTOH INNER JOIN
---------------------------------------------------------
Kita ingin menampilkan nama produk beserta nama kategorinya.

SYNTAX DASAR:
SELECT kolom1, kolom2, ...
FROM tabel1
INNER JOIN tabel2
ON tabel1.kolom = tabel2.kolom;
*/

SELECT 
    p.id AS id_produk,
    p.nama AS nama_produk,
    c.nama AS nama_kategori
FROM products p
INNER JOIN category c ON p.category = c.id;


---------------------------------------------------------
📈 7. HASIL OUTPUT:

| id_produk | nama_produk      | nama_kategori  |
|-----------|------------------|----------------|
| p001      | Mie Goreng Jawa  | Makanan Berat  |
| p002      | Bakso Mercon     | Berkuah        |
| p003      | Tahu Gejrot      | Camilan        |
| p004      | Sate Ayam        | Makanan Berat  |

🟢 Hanya produk yang memiliki category yang valid yang akan muncul.
Jika ada produk dengan `category = NULL` atau tidak cocok dengan `category.id`,
maka produk tersebut **tidak akan ditampilkan oleh INNER JOIN**.

---------------------------------------------------------

🧠 8. INNER JOIN vs LEFT JOIN vs RIGHT JOIN
---------------------------------------------------------
| JOIN TYPE   | APA YANG DITAMPILKAN? |
|-------------|------------------------|
| INNER JOIN  | Hanya data yang cocok  |
| LEFT JOIN   | Semua dari kiri + cocok |
| RIGHT JOIN  | Semua dari kanan + cocok |

---------------------------------------------------------

📌 9. INNER JOIN MULTI-TABEL
---------------------------------------------------------
Kamu bisa melakukan JOIN lebih dari 2 tabel sekaligus:

SELECT ...
FROM tabel1
INNER JOIN tabel2 ON ...
INNER JOIN tabel3 ON ...

---------------------------------------------------------


---------------------------------------------------------
- INNER JOIN digunakan untuk mengambil data yang saling cocok dari dua tabel.
- Sangat berguna dalam hampir semua aplikasi nyata yang pakai relasi.
- JOIN membuat data lebih **terstruktur, efisien, dan terintegrasi**.
- Wajib dipahami oleh semua programmer dan database administrator.

=========================================================
*/








