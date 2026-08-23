
# Static Routing Pada Vendor Mikrotik
Pada topologi jaringan ini, mekanisme perutean yang digunakan adalah routing statis. Routing statis berarti administrator jaringan memasukkan rute secara manual ke dalam tabel routing router. Setiap rute statis biasanya memiliki nilai Administrative Distance (AD) sebesar 1, yang menunjukkan tingkat kepercayaan rute tersebut — semakin rendah nilainya, semakin dipercaya.
Ketika sebuah paket data tiba, router melakukan pencarian di tabel routing menggunakan mekanisme Longest Prefix Match (LPM), yaitu memilih rute dengan prefix paling spesifik yang cocok dengan alamat tujuan. Jika terdapat beberapa rute dengan prefix length yang sama, router menggunakan tie breaker berupa AD terlebih dahulu, lalu Metric/Cost.
Setelah rute terpilih, proses forwarding paket diserahkan ke data plane yang menggunakan chip ASIC, sehingga perpindahan paket dapat terjadi sangat cepat dalam orde mikrodetik tanpa membebani CPU router.



| No   | IP Network      | Subnet Mask           |
|------|-----------------|---------------------|
| 1    | 192.168.1.0/24  |  255.255.255.0      |
| 2    | 192.168.2.0/24  |  255.255.255.0      |
| 3    | 1.1.1.0/30      |  255.255.255.252    |
| 3    | 2.2.2.0/30      |  255.255.255.252    |
| 3    | 3.3.3.0/30      |  255.255.255.252    |
| 3    | 4.4.4.0/30      |  255.255.255.252    |

## Topology
![Network Topology](https://github.com/fasyaAlvyan/Networking-Project/blob/main/static-routing/mikrotik-redudant-static/Topology.png)

## File-config-Router
- [Router 1-Config](https://github.com/fasyaAlvyan/Networking-Project/blob/main/static-routing/mikrotik-redudant-static/Router1-config.rsc)
- [Router 2-Config](https://github.com/fasyaAlvyan/Networking-Project/blob/main/static-routing/mikrotik-redudant-static/Router2-config.rsc)
- [Router 3-Config](https://github.com/fasyaAlvyan/Networking-Project/blob/main/static-routing/mikrotik-redudant-static/Router3-config.rsc)
- [Router 4-Config](https://github.com/fasyaAlvyan/Networking-Project/blob/main/static-routing/mikrotik-redudant-static/Router4-config.rsc)
