



-- Semua data dari **tabel kanan (RIGHT TABLE)** akan ditampilkan,
-- Data dari **tabel kiri (LEFT TABLE)** hanya ditampilkan jika ada kecocokan.

-- Jika tidak ada pasangan dari tabel kiri, maka kolom dari tabel kiri akan bernilai `NULL`.

-- jadi kebalikan dari si left join

use toko_online;

-- disini coba kita tambahkan lagi data dicategory tapi yang tidak berelasi 
-- ditabel kirinya

select * FROM category;
INSERT INTO category (nama)
VALUES ('snack'),('balon');

-- versi biasa
SELECT p.nama AS nama, p.id_category, c.nama AS categorynya
FROM products AS p
INNER JOIN category AS c ON (p.id_category = c.id);

-- versi left
SELECT p.nama AS nama, p.id_category, c.nama AS categorynya
FROM products AS p
left JOIN category AS c ON (p.id_category = c.id);

-- versi right
SELECT p.nama AS nama, p.id_category, c.nama AS categorynya
FROM products AS p
right JOIN category AS c ON (p.id_category = c.id);


