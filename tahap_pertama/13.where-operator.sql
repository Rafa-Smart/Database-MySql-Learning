USE toko_online;
SELECT * FROM products;

-- ini salah

-- SELECT id,nama,price,quantity, (price*quantity) / 1000 AS 'harga bayar' 
-- FROM products 
-- WHERE 'harga bayar' > 10;

-- Kamu menggunakan alias kolom 'harga bayar' di dalam klausa WHERE, 
-- namun MySQL tidak mengizinkan penggunaan alias kolom di dalam WHERE clause karena WHERE dievaluasi sebelum alias dibuat.
-- Selain itu, 'harga bayar' ditulis sebagai string literal (pakai tanda kutip '...'), yang berarti
-- MySQL menganggap itu sebagai string "harga bayar" (bukan alias), dan mencoba membandingkannya dengan angka, sehingga muncul error:

-- jadi intinya kenapa ga bisa kaena sudah where ini sudah dijalankan sebelum alias di buat

Alias seperti 'harga bayar' hanya bisa digunakan di:
ORDER BY
GROUP BY
HAVING


SELECT id, nama, price, quantity, (price*quantity) / 1000 AS 'harga bayar'
FROM products
WHERE (price*quantity) / 1000 > 10;

-- jadi kita ga bisa where si harganya, tapi kita bisa where kondisinya

-- Ini adalah cara paling umum dan aman karena semua nilai dihitung dalam urutan eksekusi SQL yang benar:
-- FROM
-- WHERE
-- SELECT (baru di sini alias harga bayar dihitung)


-- atau bisa jga seperti ini
-- jadi pake hacing, karena having itu bisa pake alias karena having itu dieksekusi sesudah select, dan pastinya
-- sesudah pembuatan alias, jadi aliasnya sudha tersedia, karena alias itu dibuat ketika select

SELECT 
  id,
  nama,
  price,
  quantity,
  (price * quantity) / 1000 AS `harga bayar`
FROM 
  products
HAVING 
  `harga bayar` > 10;


-- 2. <> sama dengan !=
  
--   3. operator logika
  bisa NOT, OR, AND, dll
  
  SELECT id, nama, price, quantity, (price * quantity) / 1000 AS harga_bayar
  FROM products
  -- jadi untuk cari harga bayar yg lebih dari 1500 danjuga dibawah 2000
  HAVING harga_bayar > 1500 AND harga_bayar < 2000;
  
  
  -- atau bisa juga pake beetwen
  -- jadi ini tuh maksudnya adlaah diantar
  
  SELECT id, nama, price, quantity, (price * quantity) / 1000 AS harga_bayar
  FROM products
  HAVING harga_bayar BETWEEN 1500 AND 2000;
  
  -- bisa juga not between
  
  

-- dan untuk or dan and, yg lebih diprioritaskan nya itu adalah and (default)
  -- tapi kita juga bisa memprioritaskan sesuatu dulu, emnggunakan kurung
  
  -- jadi defaultnya adlah gini
  SELECT id, nama, category, price, quantity
  FROM products
  WHERE category = "goreng" or (quantity < 100 AND price > 15000);

  
  -- tapi kamu juga bisa gini, dan ini pasti beda
  
  SELECT id, nama, category, price, quantity
  FROM products
  WHERE (category = "goreng" or quantity < 100) AND price > 15000;


  
3. LIKE operator,
-- tpai perlu diingat, bahwa operator ini snagat lanmbat, karena dia akna scaning dari data pertama sampai data terakhir
-- satu persatu

LIKE "b%" -- artinya awalannya b dan setelah b, bebas huruf apa saja
LIKE "%b" -- artiny akhirannya b dan sebelum b, bebas huruf apa saja
LIKE "%rafa%" -- artinya sebelum huruf rafa dan setelah huruf rafa, bebas apa saja
NOT LIKE "b%" -- artinya dicari yg TIDAK huruf awalannya b

SELECT * 
FROM products
WHERE nama LIKE "%mie%";


-- 4. perbandinga null
-- jadi kalo NULL itu ga bisa pake = null
-- tapi harus pake is null atau is not null

SELECT * FROM products WHERE nama IS NOT NULL;



-- 5. IN operetor

-- jadi IN ini adalah oparator untuk melakukan pencarioan sebuah kolom dnegan beberapa nilai
-- misal kita ingin mencari products dengan category kuah dan goreng, maka kita bisa melakukan nya mneggunakan IN operator

SELECT * FROM products WHERE category IN ("kuah", "goreng");

-- bisa juga tapi ini menggunaakn operator or
SELECT * FROM products WHERE category = "kuah" OR category = "goreng";





