-- insert data 
-- ketika kita inign mengissert kan data ke table, kita bisa menyebutkna kolom mana yg inign kita isi
-- jika kita tidak menyebutkan kolom mana yg ingin kita isi maka kolom tersebut tidak akna kita isi
-- dan secara otomatis kolom yg tidak kita isi, nilainya akan null (kecuali jika di set default value)

use toko_online;
DESCRIBE barang;

-- disini kita akan coba membuat tabel products

create table products(
	id varchar(10) not null,
	nama varchar(100) not null,
	description text,
	price int unsigned not null,
	quantity int unsigned not null,
	created_at timestamp not null default current_timestamp
	-- not null itu artinya tidak boleh kosong
) ENGINE = innodb;

-- 1.memasukan data pertama

INSERT INTO products (id, nama, price, quantity)
VALUES ('p0001', 'mie ayam original', 15000, 100);

INSERT INTO products (id, nama, description, price, quantity)
VALUES ("p0002", 'mie ayam bakso tahu','mie ayam original + bakso tahu' , 20000, 100);
-- gausah berurutan sama urutan tablenya, tapi ketika di parameter productsmya harus sama dengan
-- paramter di valuesnya

-- 2. memasukan DATA banyak secara langsung
INSERT INTO products (id, nama, description, price, quantity)
VALUES
('p0003', 'Mie Bakso Original', 'Mie bakso dengan kuah gurih', 15000, 100),
('p0004', 'Mie Ayam Pedas', 'Mie ayam dengan sambal spesial', 16000, 90),
('p0005', 'Bakso Urat Jumbo', 'Bakso urat isi telur puyuh', 18000, 80),
('p0006', 'Soto Ayam Lamongan', 'Soto ayam khas Lamongan', 17000, 70),
('p0007', 'Nasi Goreng Spesial', 'Nasi goreng dengan ayam dan sosis', 20000, 60),
('p0008', 'Ayam Geprek Level 5', 'Ayam geprek dengan sambal super pedas', 19000, 50),
('p0009', 'Mie Goreng Jawa', 'Mie goreng tradisional Jawa', 16000, 90),
('p0010', 'Seblak Ceker', 'Seblak kuah pedas dengan ceker ayam', 15000, 85),
('p0011', 'Nasi Ayam Kremes', 'Nasi ayam dengan kremesan renyah', 18000, 70),
('p0012', 'Bakmi Goreng Seafood', 'Bakmi goreng isi udang dan cumi', 21000, 65),
('p0013', 'Mie Rebus Telur', 'Mie rebus dengan telur setengah matang', 14000, 95),
('p0014', 'Ayam Bakar Madu', 'Ayam bakar dengan saus madu manis', 20000, 55),
('p0015', 'Sate Ayam', 'Sate ayam bumbu kacang', 18000, 75),
('p0016', 'Nasi Pecel Lele', 'Lele goreng dan sambal tomat', 17000, 85),
('p0017', 'Kwetiau Goreng', 'Kwetiau goreng dengan ayam dan telur', 19000, 60),
('p0018', 'Mie Kuah Kari', 'Mie kuah dengan rasa kari ayam', 16000, 100),
('p0019', 'Bakso Mercon', 'Bakso isi sambal super pedas', 17000, 90),
('p0020', 'Nasi Uduk Komplit', 'Nasi uduk, ayam, tempe, sambal', 18000, 70),
('p0021', 'Mie Setan', 'Mie super pedas dengan topping ayam cincang', 15000, 80),
('p0022', 'Nasi Ayam Teriyaki', 'Nasi dengan ayam teriyaki manis gurih', 19000, 60),
('p0023', 'Sop Buntut', 'Sop buntut sapi kuah bening', 25000, 45),
('p0024', 'Mie Bakso Beranak', 'Bakso besar isi bakso kecil', 20000, 50),
('p0025', 'Tahu Gejrot', 'Tahu dengan kuah asam manis pedas', 10000, 100),
('p0026', 'Nasi Goreng Kampung', 'Nasi goreng khas kampung dengan terasi', 17000, 90),
('p0027', 'Ayam Goreng Kuning', 'Ayam goreng bumbu kuning khas Jawa', 18000, 65);




-- 3. memilih DATA yg ditampilkan ke OUTPUT 
-- menampilkan semua colom dengan *
-- * artinya seluruh DATA COLUMN / seuruh headernya 
SELECT * FROM products;

-- menampilkan sebagian saja (yg dipilih)
SELECT nama, quantity, price FROM products;
-- dan urutannya tidak harus sama dengn yg ditable, tapi nanti yg keluar di outputnya
-- akan sama dnegan apa yg kita tulis di SELECT nama, quantity, price FROM products;
-- jadi meskipun di table aslinya harusnya price dulu, tapi karena kita milihnya quantity duu, maka nanti yg muncul 
-- quantity dulu baru price




show tables;
DESCRIBE products;
describe products;
show create table products;
desc products;




