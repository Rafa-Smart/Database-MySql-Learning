-- cara mendelete data di mysql
-- klao hapus table itu drop

dan perintah DELETE ini sama deperti UPDATE dan SELECT
-- yg dimana kita perlu untuk meemberi tahu data mana yg akan di hapus dengn where clause
-- dan hati hati ketika menggunakan where clause, takutnya malah seluruh datanya terhapus

-- disini misal kita inign menghapus baris yg idnya p0027


DELETE 
FROM products
WHERE id = "p0027";


USE toko_online;
SHOW CREATE TABLE products;
SELECT * FROM products;




 * ================================
 *     MATERI: DELETE DATA DI MYSQL
 * ================================
 *
 * Fungsi DELETE digunakan untuk menghapus satu atau lebih baris dari tabel.
 * 
 * Bentuk umum sintaks:
 * ---------------------
 *   DELETE FROM nama_tabel
 *   WHERE kondisi;
 * 
 * PERINGATAN PENTING:
 * - Jika lupa menulis klausa WHERE, maka SEMUA DATA dalam tabel akan dihapus!
 * - Tidak seperti TRUNCATE, perintah DELETE bisa dikembalikan (ROLLBACK) jika menggunakan transaksi.
 * 
 * =====================================================
 *                CONTOH STRUKTUR TABEL
 * =====================================================
 *   CREATE TABLE pelanggan (
 *     id INT PRIMARY KEY AUTO_INCREMENT,
 *     nama VARCHAR(100),
 *     kota VARCHAR(100),
 *     status_member ENUM('silver', 'gold', 'platinum')
 *   );
 *
 *   INSERT INTO pelanggan (nama, kota, status_member) VALUES
 *   ('Rafa', 'Bandung', 'gold'),
 *   ('Budi', 'Jakarta', 'silver'),
 *   ('Ani', 'Surabaya', 'platinum'),
 *   ('Sari', 'Bandung', 'silver');
 * 
 * =====================================================
 *             1. DELETE SATU BARIS DATA
 * =====================================================
 *   DELETE FROM pelanggan
 *   WHERE id = 2;
 * 
 * Penjelasan:
 * - Menghapus baris yang memiliki id = 2, yaitu pelanggan bernama Budi.
 * 
 * =====================================================
 *          2. DELETE BEBERAPA DATA DENGAN KONDISI
 * =====================================================
 *   DELETE FROM pelanggan
 *   WHERE kota = 'Bandung';
 * 
 * Penjelasan:
 * - Menghapus semua pelanggan yang berasal dari Bandung.
 * - Bisa lebih dari satu baris.
 * 
 * =====================================================
 *         3. DELETE SEMUA DATA DENGAN KONFIRMASI
 * =====================================================
 *   DELETE FROM pelanggan;
 * 
 * Penjelasan:
 * - Menghapus semua data dalam tabel pelanggan.
 * - TIDAK MENGHAPUS STRUKTUR TABEL.
 * - Bisa dikembalikan jika menggunakan transaksi:
 *     START TRANSACTION;
 *     DELETE FROM pelanggan;
 *     ROLLBACK; // untuk membatalkan
 *     COMMIT;   // untuk menyimpan perubahan
 *
 * =====================================================
 *        4. PERBEDAAN DELETE VS TRUNCATE VS DROP
 * =====================================================
 *   DELETE:
 *     - Bisa pakai WHERE
 *     - Bisa di-ROLLBACK jika pakai transaksi
 *     - Menulis log perubahan (lebih lambat dari TRUNCATE)
 *
 *   TRUNCATE:
 *     - Menghapus semua data TANPA WHERE
 *     - Tidak bisa di-ROLLBACK (kecuali engine mendukung)
 *     - Lebih cepat dari DELETE karena tidak tulis log
 *
 *   DROP:
 *     - Menghapus seluruh tabel (data + struktur tabel)
 *     - Tidak bisa dikembalikan
 *
 * =====================================================
 *      5. DELETE DENGAN JOIN (MULTI TABLE DELETE)
 * =====================================================
 *   DELETE pelanggan
 *   FROM pelanggan
 *   JOIN kota_terlarang ON pelanggan.kota = kota_terlarang.nama_kota
 *   WHERE kota_terlarang.dilarang = 1;
 *
 * Penjelasan:
 * - Menghapus data pelanggan yang berasal dari kota-kota yang dilarang.
 * - Tabel kota_terlarang digunakan sebagai acuan penghapusan.
 * 
 * =====================================================
 *               6. BEST PRACTICES
 * =====================================================
 * ✅ Selalu gunakan klausa WHERE saat delete data.
 * ✅ Backup data terlebih dahulu sebelum delete.
 * ✅ Gunakan transaksi (START TRANSACTION) jika ingin aman.
 * ✅ Test query SELECT terlebih dahulu:
 *     SELECT * FROM pelanggan WHERE kota = 'Bandung';
 * ✅ Gunakan LIMIT untuk menghindari penghapusan massal tidak sengaja:
 *     DELETE FROM pelanggan WHERE status_member = 'silver' LIMIT 2;
 *
 * =====================================================
 *         7. MENGHAPUS DATA DARI NODE.JS
 * =====================================================
 * Contoh menggunakan Node.js dan mysql2/promise:
 */

// import library mysql2
import mysql from "mysql2/promise";

(async () => {
  const connection = await mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "toko"
  });

  try {
    // Mulai transaksi agar aman
    await connection.beginTransaction();

    // Contoh delete 1 data berdasarkan ID
    const [result] = await connection.execute(
      "DELETE FROM pelanggan WHERE id = ?",
      [2]
    );

    console.log("Jumlah baris yang dihapus:", result.affectedRows);

    // Commit jika tidak ada error
    await connection.commit();
  } catch (err) {
    console.error("Terjadi kesalahan:", err.message);

    // Rollback jika terjadi kesalahan
    await connection.rollback();
  } finally {
    // Tutup koneksi
    await connection.end();
  }
})();

/**
 * =====================================================
 *                 CATATAN PENTING
 * =====================================================
 * - Gunakan fitur `affectedRows` untuk mengetahui berapa banyak data yang berhasil dihapus.
 * - Gunakan async/await agar alur eksekusi lebih rapi.
 * - Jangan gunakan DELETE tanpa WHERE kecuali memang benar-benar ingin hapus semuanya.
 */







