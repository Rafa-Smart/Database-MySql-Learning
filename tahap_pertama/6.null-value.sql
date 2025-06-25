show databases;
use toko_online;

describe barang;

-- nah coba liat di output, ada keterngan bleh atua tidak nya null ketika datanya kosong pada sebuah column
-- kalo no berati ga boleh null, dan kalo yesy, berati boleh null

-- maka kita bisa set agat column tertntu tidak boleh null dnegna cara not null, ketika pembuatan table /
-- bisa ketika alter

-- 1. 
alter table barang 
	modify harga int not null;
-- nah nanti keterangan null atau tidaknya
-- pada column harga akan no, maka artinya data harga ini tidak boleh koosng atau null
-- jadi ketika dia tidka diisi maka nanti akna ditolak


-- 2. 
alter table barang
	modify nama varchar(200) not null;



-- 3. default value
-- nah ketika kita menyimpan data kedalam table, lalu kita hanya memasukan data hanya ke beberapa kolom saja
-- maka kolo yg tidak diisi nilai defultnya adlah null

-- makanya kalo kita inign merubha nilai default dari sebuah kolom kita bisa menggunakan defalut nilainya apa
-- ketika pembuatan kolom atau ketika alter

alter table barang 
	modify harga int default 0;

alter table barang
	modify jumlah int default 0;
	-- harus menyertakan tipedatanya 
	-- keduali kalo drop


-- tapi khusus tipe data datetime atau timestamp, jika kita ingin menggunkaan default value dengan nilai waktu saat ini
-- maka kita bisa menggunakan kata kunci current_timestamp

alter table barang 
	add waktu timestamp;

alter table barang
	modify waktu timestamp default current_timestamp;

-- jadi kalo kita tidak memasukan nilai kedalam kolom waktu, maka secaara default akan diisi dengan waktu saat ini




-- cara membua ulang table
-- jadi kita akn meghapus semua data didalam table lalu membaut ulang tablenya
-- NAH TAPI TABLENYA MASIH ADA, HANYA DATANYA SAJA YANG HILANG, tapi headernya masih ada
-- kit bisa mneggunkan truncate barang

-- jadi
-- Menghapus semua baris dalam tabel, tetapi struktur tabel tetap ada.

truncate table barang;



-- tapi kalo ingin menghapus tabel secara permanen kita bisa menggunakan 
-- jadi menghapus seluruh tabel dan data didalamnya
-- drop table barang;


show create table barang;
use toko_online;
describe barang;

use world;
describe city;


