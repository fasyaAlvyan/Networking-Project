# Designing a Resilient Enterprise LAN: Three-Tier Architecture with OSPF, VRRP, RSTP & LACP
Proyek ini merupakan simulasi jaringan untuk ketersediaan tinggi dengan mengkombinasikan/mengintegrasikan protokol seperti *Open Shortest Path First(**OSPF**), Virtual Redundancy Router Protocol(**VRRP**), Rapid Spanning Tree Protocol(**RSTP**) dan Link Agregation Control Protocol(**LACP**)*
,keempat protokol ini berguna untuk menyelesaikan masalah tiap kelemahan pada desain jaringan untuk mencapai tingkat ketersediaan tinggi dan tahan terhadap kegagalan, dengan metode menyediakan banyak backup untuk setiap device *intermediary* dan media transmisi(*Ethernet cable*), jika ada kegagalan, perangkat yang disediakan sebagai backup akan menghandle sementara agar koneksi client tidak terputus. Keempat protokol ini memiliki perannya masing masing di dalam jaringan.
## Fungsi dari setiap protokol pada jaringan High Availability(HA) ini :
- OSPF : OSPF berperan sebagai protokol dynamic routing berbasis Link-State yang melakukan kalkulasi rute terbaik menggunakan algoritma SPF dari data LSDB. Dalam konteks High Availability, OSPF berperan melakukan rekalkulasi rute saat sebuah link atau perangkat mengalami kegagalan, memindahkan trafik ke link alternatif dengan waktu deteksi kegagalan hingga 40 detik (dead interval default).
- VRRP : VRRP berperan sebagai protokol redundansi gateway dengan membagi 1 IP virtual dan 1 MAC virtual (00:00:5E:00:01:xx) kepada 2 atau lebih perangkat Layer 3. Perangkat ditetapkan peran MASTER dan BACKUP, dimana Master aktif sebagai gateway dan mengirim VRRP Advertisement setiap 1 detik (default) kepada Backup. Jika Backup tidak menerima Advertisement dalam waktu Master Down Interval, Backup akan mengambil alih peran Master secara otomatis.
- RSTP : RSTP berperan mencegah broadcast storm akibat loop pada topologi redundant. Tidak seperti STP klasik, RSTP memiliki waktu konvergensi yang jauh lebih cepat (dalam hitungan detik) karena menggunakan mekanisme proposal-agreement antar switch. Saat terjadi kegagalan, RSTP akan mengaktifkan Alternate Port atau Backup Port yang sebelumnya dalam kondisi Discarding menjadi Forwarding untuk mempertahankan konektivitas.
- LACP : LACP berperan menggabungkan 2 atau lebih link fisik menjadi 1 link logis (LAG/Bond) untuk meningkatkan bandwidth agregat dan toleransi kegagalan. LACP menggunakan mekanisme pengiriman LACPDU pada setiap link anggota untuk memverifikasi kondisi link secara berkala. Jika salah satu link mengalami kegagalan, LACP akan mengeluarkannya dari LAG agar tidak masuk ke algoritma hash distribusi trafik (XOR-based), yang berpotensi menyebabkan black hole pada trafik tertentu.
## Konsep Desain Three-Tier Architecture :
Jaringan ini menggunakan desain *Three-Tier* yang dikembangkan oleh Cisco (Walaupun vendor yang digunakan adalah Ruijie dan Mikrotik), desain ini digunakan karena beberapa alasan:
- **Fleksibilitas & Skalabilitas** — pembagian layer membuat jaringan mudah dikelompokkan, ditambah, atau dikembangkan menjadi lebih besar tanpa mengganggu layer lain.
- **Keamanan** — jika terjadi serangan pada perangkat Access, isolasi bisa dilakukan hanya pada layer tersebut tanpa perlu mengisolasi Distribution atau Core, sehingga dampak insiden bisa dibatasi.
- **Kinerja** — setiap perangkat intermediary bekerja sesuai perannya masing-masing (Core untuk forwarding cepat, Distribution untuk policy & inter-VLAN routing, Access untuk konektivitas end device) tanpa mencampuradukkan fungsi, sehingga beban kerja per device lebih terarah dan mudah di-troubleshoot.

# Topology
- Topology ![Topology](https://github.com/fasyaAlvyan/Networking-Project/blob/main/networking-project/Multi-Protocol%20High%20Availability%20LAN%20(OSPF%2C%20VRRP%2C%20RSTP%2C%20LACP)/Topology/TOPOLOGY.png)
### Peran dan fungsi setiap device pada jaringan :
- Router - Mikrotik - Core : Berperan sebagai router utama yang menghubungkan jaringan lokal dengan internet. Perangkat ini juga bertindak sebagai ASBR (Autonomous System Boundary Router) dalam OSPF, yang bertugas mendistribusikan default route ke seluruh jaringan internal.
- Switch - L3 - Mikrotik - DIST : Switch Layer 3 ini bertindak sebagai gateway, firewall,Root bridge pada instance 1, dan DHCP Server (untuk VLAN 100-300),sekaligus mengambil alih tugas inter-VLAN routing agar tidak membebani router core. Selain itu, perangkat ini juga mengelola redundansi via VRRP (Master untuk VLAN 100 & 200, serta Backup untuk VLAN 300 & 400), lalu switch ini bertindak sebagai backup jika SW DIST 2 mengalami kegagalan.
- Switch - L3 - Mikrotik 02 - DIST : Switch Layer 3 seperti SW DIST 1, bertindak sebagai gateway,Root bridge pada instance 2,firewall dan DHCP Server (untuk VLAN 100-300), sekaligus mengambil alih tugas inter-VLAN routing dan sebagai BACKUP jika SW DIST 1 mengalami kegagalan, perangkat ini mengelola redundansi via VRRP(Master untuk VLAN 300 & 400, serta Backup untuk VLAN 100 & 200), VLAN 400 tidak menggunakan DHCP Server karena pure IP statis .
- Mikrotik - SW - L2 - Accs - 1 : Berperan sebagai switch access untuk client pada VLAN 100 dan berperan juga sebagai Non root Bridge(Backup(1)) pada instance RSTP 1, memiliki BID dengan *System Priority 0x2000*,terhubung dengan kedua switch DIST dan switch access(2).
- Mikrotik - SW - L2 - Accs - 2 : Berperan sebagai switch access untuk client pada VLAN 200 dan berperan sebagai Non root Bridge(Backup(2)) pada instance RSTP 1, memiliki BID dengan *System Priority 0x4000*, terhubung dengan kedua switch DIST dan switch access(1).
- Mikrotik - SW - L2 - Accs - 3 : Berperan sebagai switch access untuk client padda VLAN 300 dan berperan sebagai Non root Bridge(Backup(1)) pada instance RSTP 2, memiliki BID dengan *System Priority 0x5000* terhubung dengan kedua switch DIST dan switch access(4)
- Mikrotik - SW - L2 - Accs - 4 : Berperan sebagai switch access untuk client padda VLAN 400 dan berperan sebagai Non root Bridge(Backup(2)) pada instance RSTP 2, memiliki BID dengan *System Priority 0x6000* terhubung dengan kedua switch DIST dan switch access(3)
- Legacy-Ruijie-SW : Berperan sebagai switch access unmanaged untuk client pada vlan 1(Native), switch ini tidak support dengan standar IEEE 802.1Q untuk menyisipkan tag 802.1Q pada versi frame *Ethernet II*, Switch ini tidak berpartisipasi dengan instance RSTP manapun dan hanya terhubung pada switch DIST 1 saja sebagai gatewaynya untuk vlan 1, tidak ada redundansi gateway yang digunakan karena potensi serangan VLAN hopping yang cukup tinggi.
- Dual ISP UPLINK(Neko-Neko & MiAu-MiAu) : Berperan sebagai penyedia koneksi ke internet untuk local,menggunakan 2 ISP karena jika salah satu ISP Down,ISP lainnya bisa menjadi Backup, pada R-Core mekanisme perpindahan dilakukan dengan metode Recursive Gateway untuk benar benar mengecek konektivitas langsung ke internet dan menghindari kesalahan palsu dari ONT/ONU yang mati.
### Catatan Desain VRRP, DHCP Server dan OSPF:
- Pada jaringan ini, desain yang digunakan adalah active-active load balance,Switch DIST 1 menjadi gateway untuk VLAN 100 & 200, Switch DIST 2 menjadi gateway untuk VLAN 300 & 400 agar tidak hanya satu device yang aktif dengan memanfaatkan resource dan membagi beban gateway antar vlan.
- Desain DHCP Server yang digunakan adalah DHCP Server dengan split pool dengan pembagian 50/50 pada IP yang didistribusikannya.
- Desain OSPF yang digunakan adalah *Point to Point*, tidak ada pemilihan DR/BDR/DROther dalam topologi ini karena setiap instance OSPF berjalan di subnet yang berbeda dan tipe jaringannya adalah point to point sehingga pemilihan peran DR tidak diperlukan karena router sudah dipastikan akan mengetahui lawannya tanpa ada kebutuhan untuk melakukan efisiensi LSA packet.
## Terdapat 2 Root bridge pada jaringan ini, karena :
Jaringan ini dipecah menjadi 2 instance RSTP yang berbeda agar Root Bridge pada tiap instance selalu align dengan VRRP Master pada domain VLAN yang sama. Instance 1 (Root: SW-DIST) menaungi VLAN 100 & 200, sesuai domain VRRP Master SW-DIST. Instance 2 (Root: SW-DIST2) menaungi VLAN 300 & 400, sesuai domain VRRP Master SW-DIST2.Dengan alignment ini, jalur forwarding Layer 2 (menuju root bridge) selalu sejalan dengan jalur default gateway Layer 3 (VRRP master), sehingga traffic tidak perlu melewati jalur non-optimal (extra hop) untuk mencapai gateway-nya.
### Desain Port Edge pada Link VRRP Backup
Link "Gateway Backup" antara Distribution dan Access switch sengaja dipisahkan dari Bonding LAG utama untuk menyediakan jalur independen bagi VRRP Advertisement, mencegah split-brain jika LAG utama gagal total.
Pada sisi Distribution, port link ini **tidak** dimasukkan ke dalam bridge, sehingga berfungsi sebagai interface routed murni dan berada di luar domain RSTP — tidak ada BPDU yang dikirim melalui port ini.
Pada sisi Access switch, port yang menghadap link ini dikonfigurasi sebagai **edge port** dengan link type **point-to-point**. Karena tidak ada bridge lain di ujung satunya, tidak mungkin terbentuk loop melalui link ini, sehingga status edge port aman digunakan. Jika suatu saat port Distribution secara tidak sengaja dimasukkan ke bridge (menciptakan potensi loop), port Access akan menerima BPDU dan otomatis kehilangan status edge-nya, kembali ke proses RSTP normal sebagai proteksi fallback. Dari riset yang saya lakukan, **edge port** RSTP pada vendor mikrotik tidak mengirimkan BPDU config/TC pada port yang dikonfigurasi sebagai **edge port** khususnya mode "edge=yes". 


### VLAN & Subnet Schema

| VLAN ID & Name | Network IP | Gateway IP (VRRP) | Broadcast IP |
| :--- | :--- | :--- | :--- |
| **VLAN 1** (Native-Guest) | `192.168.100.0/24` | `192.168.100.1` | `192.168.100.255` |
| **VLAN 100** (Server) | `10.20.1.0/28` | `10.20.1.14` | `10.20.1.15` |
| **VLAN 200** (Office) | `192.168.10.0/24` | `192.168.10.254` | `192.168.10.255` |
| **VLAN 300** (Guest) | `192.168.20.0/24` | `192.168.20.254` | `192.168.20.255` |
| **VLAN 400** (Engineering)| `10.10.11.0/29` | `10.10.11.6` | `10.10.11.7` |

### Inter-Device Routing Schema (LACP Links)

| Connection / LACP ID | Network IP | IP Device 1 | IP Device 2 |
| :--- | :--- | :--- | :--- |
| **LACP - 0** | `10.0.1.0/30` | `10.0.1.1` (SW-L3-Mikrotik-DIST) | `10.0.1.2` (R-Mikrotik-Core) |
| **LACP - 1** | `10.1.0.0/30` | `10.1.0.2` (SW-L3-Mikrotik 02-DIST) | `10.1.0.1` (R-Mikrotik-Core) |
| **LACP - 3** | `10.2.1.0/30` | `10.2.1.1` (SW-L3-Mikrotik-DIST) | `10.2.1.2` (SW-L3-Mikrotik 02-DIST) |

### Port Channel / LAG Configurations

| LAG Group | Device 1 Ports | Device 2 Ports |
| :--- | :--- | :--- |
| **LACP - 0** | SW-DIST (Eth 1, Eth 2) | R-Core (Eth 2, Eth 4) |
| **LACP - 1** | SW-DIST2 (Eth 1, Eth 2) | R-Core (Eth 3, Eth 5) |
| **LACP - 3** | SW-DIST (Eth 3, Eth 10) | SW-DIST2 (Eth 3, Eth 10) |
| **LAG - 1** | Accs1 (Eth 1, Eth 2) | DIST (Eth 8, Eth 9) |
| **LAG - 2** | Accs2 (Eth 1, Eth 2) | DIST (Eth 6, Eth 7) |
| **LAG - 3** | Accs1 (Eth 3, Eth 4) | Accs2 (Eth 3, Eth 4) |
| **LAG - 4** | Accs3 (Eth 1, Eth 2) | DIST2 (Eth 8, Eth 9) |
| **LAG - 5** | Accs4 (Eth 1, Eth 2) | DIST2 (Eth 6, Eth 7) |
| **LAG - 6** | Accs4 (Eth 3, Eth 4) | Accs3 (Eth 3, Eth 4) |
