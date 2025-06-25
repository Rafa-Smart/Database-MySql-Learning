

-- jadi setiap kali user menambhaka data ke dalam tabel, maka kolom yg di tunjuk sebagai
-- auto increment akan menambah 1 dari angka sebelumnya

-- nah dengan syarat bahwa auto increment ini hanya bisa digunakan pada kolom
-- yg ditunjuk sebagai PRIMARY KEY 

-- contoh 

-- dan biasanya kita membuat auto increment ketika membaut table


-- disini kita akn buat table admin

USE toko_online;

CREATE TABLE admin(
    id int NOT NULL AUTO_INCREMENT,
    first_name varchar(100) NOT NULL,
    last_name varchar(100) NOT NULL,
    -- disini kita setting primary keynya
    PRIMARY KEY (id)
) engine = innodb;
  

DESCRIBE admin;
SELECT * FROM admin ORDER BY id desc;
-- disini coba kita tambahkan dulu datanya, tanpa si idnya

INSERT INTO admin(first_name, last_name)
values("rafa", "khadafi");

INSERT INTO admin(first_name, last_name)
values("putri", "maulidia");

INSERT INTO admin (first_name, last_name)
VALUES ("jamal", "istiqomah"),
       ("siti", "muhaimin"),
       ("khayla", "isyanie");

-- dan kalo kita execute lagi perintah ini maka nanti akna tetep nambah datanya jadi 6,7,8,9


-- dan ketika kita hapus data ditengahnya misal kita hapus siti
-- yg primary keynya itu adalah 4 dan setelahnya itu ada khayla
-- yg primary keynya itu adalah 5
-- maka yg terjadi adalah primary id khayla tetap 5, dan tidak dikurang 1, jadi 1,2,3,5

DELETE FROM admin WHERE first_name = "siti";

truncate admin;

-- PNETING

-- dan kalo misalkan kita delete data terakhir yaitu yg idnya 5, nah berati kan jadi 1,2,3,4
-- nah ketika kita insert lagi datanya, maka data tersebut akan langsung masuk menjadi data ke 6 bukan ke 5
-- jadi akan nambah lagi data idnya dari yg terakhir kai di generete, dan ga peduli apakah data terakhirnya itu masih ada atau engga

-- nah kalo misalkan kita inign melihat id yg terkahir kali di genereate itu id yg kebereapa
-- maka mysql memiliki functionnya

INSERT INTO admin(first_name, last_name)
values("budi", "handoko");

SELECT LAST_INSERT_ID();




 * AUTO_INCREMENT adalah fitur di MySQL yang digunakan untuk
 * menghasilkan **nilai numerik unik secara otomatis** di sebuah kolom,
 * biasanya digunakan pada kolom ID atau PRIMARY KEY.
 *
 * Setiap kali kita menyisipkan baris baru (INSERT), MySQL akan
 * menambahkan angka secara otomatis, tanpa perlu kita isi manual.
 *
 * ================================================================
 *              1. SINTAKS DASAR DAN CONTOH
 * ================================================================
 * 
 * ➤ Format:
 * CREATE TABLE nama_tabel (
 *   kolom_id INT AUTO_INCREMENT PRIMARY KEY,
 *   kolom_lain TipeData
 * );
 *
 * ➤ Contoh:
 * CREATE TABLE pelanggan (
 *   id INT AUTO_INCREMENT PRIMARY KEY,
 *   nama VARCHAR(100)
 * );
 *
 * ➤ INSERT contoh:
 * INSERT INTO pelanggan (nama) VALUES ('Rafa');
 * INSERT INTO pelanggan (nama) VALUES ('putri');
 *
 * ➤ Hasil:
 * +----+--------+
 * | id | nama   |
 * +----+--------+
 * | 1  | Rafa   |
 * | 2  | putri  |
 * +----+--------+
 *
 * ✅ Tanpa kita isi `id`, MySQL mengisi otomatis: 1, 2, 3, ...
 *
 * ================================================================
 *             2. SYARAT & ATURAN AUTO_INCREMENT
 * ================================================================
 * ✅ Kolom harus bertipe numerik: INT, BIGINT, TINYINT, dll
 * ✅ Hanya boleh ada **satu kolom AUTO_INCREMENT per tabel**
 * ✅ Biasanya dipasangkan dengan PRIMARY KEY (tapi tidak wajib)
 * ✅ Nilai awal default: **1**
 * ✅ Setiap record baru akan naik otomatis (+1) dari nilai sebelumnya
    -- record itu maksudnya adalah baris
    
 *
 * ================================================================
 *         3. PERILAKU SAAT DELETE ATAU GAGAL INSERT
 * ================================================================
 * ➤ Jika data dengan ID 3 dihapus:
 *     DELETE FROM pelanggan WHERE id = 3;
 *
 * ➤ Maka ID selanjutnya **tetap 4**, bukan kembali ke 3
 *     Karena AUTO_INCREMENT tidak menyesuaikan ke angka sebelumnya
 *
 * ➤ Artinya:
 *     - Tidak menjamin ID selalu berurutan sempurna
 *     - Tapi tetap **unik dan tidak duplikat**
 *
 * ================================================================
 *      4. MENGATUR NILAI AWAL (AUTO_INCREMENT = X)
 * ================================================================
 * ➤ Atur saat membuat tabel:
 *   CREATE TABLE contoh (
 *     id INT AUTO_INCREMENT PRIMARY KEY
 *   ) AUTO_INCREMENT = 1000;
 *
 * ➤ Atur setelah tabel dibuat:
 *   ALTER TABLE contoh AUTO_INCREMENT = 1000;
 *
 * ✅ Maka INSERT pertama akan menggunakan id = 1000
 *
 * ================================================================
 *         5. MENGATUR LANGKAH KENAIKAN (INCREMENT VALUE)
 * ================================================================
 * ➤ Default langkah: +1
 *
 * ➤ Untuk ubah langkah kenaikan (global):
 *   SET @@auto_increment_increment = 5;
 *
 * ➤ Maka ID akan: 1, 6, 11, 16, ...
 *
 * ⚠️ Biasanya digunakan pada **replication** atau **cluster**
 *
 * ================================================================
 *            6. PENGGUNAAN AUTO_INCREMENT DI NODE.JS
 * ================================================================


import mysql from "mysql2/promise";

(async () => {
  const conn = await mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "toko"
  });

  // Membuat tabel dengan kolom AUTO_INCREMENT
  await conn.execute(`
    CREATE TABLE IF NOT EXISTS pelanggan (
      id INT AUTO_INCREMENT PRIMARY KEY,
      nama VARCHAR(100)
    )
  `);

  // Menambahkan data (tanpa isi ID)
  await conn.execute(`INSERT INTO pelanggan (nama) VALUES ('Sari'), ('Budi')`);

  const [rows] = await conn.execute(`SELECT * FROM pelanggan`);
  console.log("Data pelanggan:");
  console.table(rows);

  await conn.end();
})();


 * ✅ Digunakan untuk membuat ID unik otomatis
 * ✅ Umumnya digunakan di kolom PRIMARY KEY
 * ✅ Tidak perlu diisi saat INSERT
 * ✅ Angka terus bertambah walau data sebelumnya dihapus
 * ✅ Bisa diatur nilai awal (mulai dari 1000, dst)
 * ✅ Bisa diatur kenaikan langkah (+2, +5, dst)
 * ✅ Tidak bisa lebih dari satu kolom AUTO_INCREMENT dalam satu tabel
 * ✅ Tipe data harus numerik
 *
 * ================================================================
 *                  8. CONTOH PENGGUNAAN UMUM
 * ================================================================
 * - ID pelanggan
 * - ID transaksi
 * - ID produk
 * - Nomor urut antrian
 * - ID posting/blog
 *
 * ================================================================
 *          9. BEST PRACTICES (REKOMENDASI PENGGUNAAN)
 * ================================================================
 * ✅ Selalu gunakan AUTO_INCREMENT untuk kolom id utama
 * ✅ Tidak perlu mengisi id secara manual
 * ✅ Jangan mengandalkan ID sebagai urutan kronologis pasti
 * ✅ Jangan ubah ID AUTO_INCREMENT tanpa alasan kuat
 * ✅ Gunakan INT atau BIGINT untuk skala besar
 *














