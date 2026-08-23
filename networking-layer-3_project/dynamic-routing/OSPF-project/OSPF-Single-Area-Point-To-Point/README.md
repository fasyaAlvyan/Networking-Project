# OSPF Single Area Point-To-Point (PNETLab)

## Deskripsi Proyek
Proyek ini merupakan simulasi jaringan Routing dinamis menggunakan protocol **OSPF**, dengan model jaringan **Single Area Point-to-Point**. Tujuannya membuat jaringan yang **redundant** untuk meningkatkan **fault tolerance** , menggunakan teknik **manipulation cost** dengan menentukan cost pada output interface secara manual menggunakan perhitungan

![formula](https://latex.codecogs.com/png.image?\dpi{150}\bg{white}Cost=\frac{Reference\;Bandwidth}{Interface\;Bandwidth})

untuk menentukan Primary path(link) dan Backup link
## Topologi Jaringan
![Network Topology](https://github.com/fasyaAlvyan/Networking-Project/blob/main/networking-layer-3_project/dynamic-routing/OSPF-project/OSPF-Single-Area-Point-To-Point/Screenshots/Topology.png)

## Konsep Jaringan
Dalam topologi ini, saya menerapkan:
* **OSPF(Open Shortest Path First)** protokol Link-state utama yang dipakai dalam simulasi ini, untuk membuat rute data secara otomatis dari kalkulasi LSDB menggunakan algoritma SPF, yang hasilnya dicatat di tabel routing.
* **DHCP(Dynamic Host Configuration Protocol)** protokol yang dipakai untuk pengalamatan IP secara otomatis menggunakan proses DORA(Discover, Offer, Request, Acknowledge) kepada client / host yang terhubung.
* **Passive Interface** dipakai agar paket dari protokol OSPF tidak mengirim ke interface yang dikonfigurasi sebagai Passive karena tidak ada neighbor di interface tersebut <eth 3 all router are passive>.
* **Default Route Originate** digunakan pada Router 2 yang berperan sebagai ASBR, untuk mengiklankan default route (0.0.0.0/0) ke router lain sehingga mereka dapat mengakses jaringan luar melalui Router 2 sebagai gateway.

## IP Addressing Scheme

| Router | Loopback0 | eth1              | eth2              |LAN (ether3 Passive)|
|--------|-----------|-------------------|-------------------|--------------------|
| R1     | 1.1.1.1   | 10.1.1.1/30       | 10.1.2.1/30       | 192.168.10.1/25    |
| R2     | 2.2.2.2   | 10.1.1.2/30       | 10.1.4.1/30       | 172.16.10.1/25     |
| R3     | 3.3.3.3   | 10.1.2.2/30       | 10.1.3.1/30       | 192.168.20.1/25    |
| R4     | 4.4.4.4   | 10.1.3.2/30       | 10.1.4.2/30       | 172.16.20.1/25     |


## Cara Menjalankan
1. Import konfigurasi MikroTik melalui Winbox atau `/import`
2. Verifikasi neighbor OSPF dengan perintah `/routing ospf neighbor print`
3. Cek tabel routing dengan `/ip route print`
4. Test konektivitas antar LAN dengan ping dari masing-masing router

## Verifikasi & Pengujian
- Tabel IP R1 : ![Semua rute berhasil dikalkulasikan oleh protokol OSPF yang berjalan di R1 dan neighbor OSPF terdeteksi](https://github.com/fasyaAlvyan/Networking-Project/blob/main/networking-layer-3_project/dynamic-routing/OSPF-project/OSPF-Single-Area-Point-To-Point/OSPF-single-area-test/OSPF-single1.png)
- Tabel IP R2 : ![Semua rute berhasil dikalkulasikan oleh protokol OSPF yang berjalan di R2 dan neighbor OSPF terdeteksi](https://github.com/fasyaAlvyan/Networking-Project/blob/main/networking-layer-3_project/dynamic-routing/OSPF-project/OSPF-Single-Area-Point-To-Point/OSPF-single-area-test/OSPF-single2.png)
- Tabel IP R3 : ![Semua rute berhasil dikalkulasikan oleh protokol OSPF yang berjalan di R3 dan neighbor OSPF terdeteksi](https://github.com/fasyaAlvyan/Networking-Project/blob/main/networking-layer-3_project/dynamic-routing/OSPF-project/OSPF-Single-Area-Point-To-Point/OSPF-single-area-test/OSPF-single3.png)
- Tabel IP R3 : ![Semua rute berhasil dikalkulasikan oleh protokol OSPF yang berjalan di R3 dan neighbor OSPF terdeteksi](https://github.com/fasyaAlvyan/Networking-Project/blob/main/networking-layer-3_project/dynamic-routing/OSPF-project/OSPF-Single-Area-Point-To-Point/OSPF-single-area-test/OSPF-single4.png)
- Hasil Ping ke seluruh client : ![Seluruh IP reacheable dari client di network 192.168.10.0/25 ke seluruh client](https://github.com/fasyaAlvyan/Networking-Project/blob/main/networking-layer-3_project/dynamic-routing/OSPF-project/OSPF-Single-Area-Point-To-Point/OSPF-single-area-test/LAN%20.png)


## File Konfigurasi
- Router 1 : [Config file](https://github.com/fasyaAlvyan/Networking-Project/blob/main/networking-layer-3_project/dynamic-routing/OSPF-project/OSPF-Single-Area-Point-To-Point/Configs/Router1-OSPF_config.rsc)
- Router 2 : [Config file](https://github.com/fasyaAlvyan/Networking-Project/blob/main/networking-layer-3_project/dynamic-routing/OSPF-project/OSPF-Single-Area-Point-To-Point/Configs/Router2-OSPF_config.rsc)
- Router 3 : [Config file](https://github.com/fasyaAlvyan/Networking-Project/blob/main/networking-layer-3_project/dynamic-routing/OSPF-project/OSPF-Single-Area-Point-To-Point/Configs/Router3-OSPF_config.rsc)
- Router 4 : [Config file](https://github.com/fasyaAlvyan/Networking-Project/blob/main/networking-layer-3_project/dynamic-routing/OSPF-project/OSPF-Single-Area-Point-To-Point/Configs/Router4-OSPF_config.rsc)

## Kekurangan dan Kelebihan
### Kekurangan
- Hanya 1 area (Backbone) dengan tipe Point-to-Point → kurang fleksibel jika topologi berubah.
- Menggunakan terlalu banyak interface/link PtP (bisa disederhanakan).
### Kelebihan
- Link redundan (setiap router terhubung ke 2 router lain).
- Fault tolerance tinggi berkat cost manipulation.

## Rencana Perbaikan
- Mengubah topologi menjadi Multiaccess dengan menambahkan switch.
- Mengurangi jumlah interface yang aktif.
- Membuat lab yang lebih scalable dan mudah dikembangkan ke multi-area.
