# Simple Redundant Static Routing (Cisco Packet Tracer) Version

## 📌 Deskripsi Proyek
Proyek ini merupakan simulasi jaringan LAN menggunakan **Static Routing** Tujuannya adalah untuk menciptakan jaringan yang memiliki *Redundancy* dan *High Availability*.

## 🛠️ Konsep Jaringa
Dalam topologi ini, saya menerapkan:
* **Primary Path:** Jalur utama pengiriman data.
* **Backup Path:** Jalur cadangan yang akan aktif secara otomatis jika jalur utama mengalami kegagalan (Down).
* **Administrative Distance (AD):** Saya mengatur nilai AD pada jalur cadangan lebih tinggi daripada jalur utama agar mekanisme *failover* dapat berjalan.

## 🗺️ Topologi Jaringan
![Network Topology](https://github.com/fasyaAlvyan/Just_Learn_Networking/blob/main/Static-Routing_basic/cisco-redudant-static/Topology.png)

## Cara Menjalankan
1. Download file `.pkt` di bawah ini.
2. Buka menggunakan aplikasi **Cisco Packet Tracer**.
3. Lakukan pengujian dengan melakukan `ping` antar PC atau `traceroute` untuk melihat perubahan jalur saat kabel utama diputus.

## 📂 File Project
* [Download File Topology (.pkt)](https://github.com/fasyaAlvyan/Just_Learn_Networking/raw/refs/heads/main/Static-Routing_basic/cisco-redudant-static/Simple-Redundant-Static-Routing.pkt)

## Kekurangan / Kelemahan
- Saya tidak mengimplementasikan Administrative distance(AD) pada semua router didalam topologi, sehingga paket data akan berputar terlebih dahulu kebeberapa router yang akan meningkatkan hop count, ini menyebabkan ketidak efisienan network dan meningkatkan latency karena paket data yang berputar terlebih dahulu kebeberapa router.

## Rencana perbaikan
- Saya berencana untuk menggunakan metode Floating static agar hanya 1 link yang dipakai, untuk pengiriman paket data yang lebih efisien, dan berencana untuk menggunakan protokol routing dinamis agar lebih *Redundant* dan *scalable*.
