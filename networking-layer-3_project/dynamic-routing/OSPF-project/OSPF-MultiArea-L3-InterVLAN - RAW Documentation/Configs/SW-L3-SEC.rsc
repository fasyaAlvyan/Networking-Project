# apr/28/2026 14:34:05 by RouterOS 7.1
# software id = 
#
/interface bridge
add name=SWITCH vlan-filtering=yes
add name=loopback0
/interface vlan
add interface=SWITCH name=Guest/PublicWiFi vlan-id=50
add interface=ether2 name=SecurityCameras&IoT vlan-id=60
add comment="for SNMP" interface=ether2 name=vlan99-Management vlan-id=99
/interface list
add name=VLAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=pool-Guest/PublicWiFi ranges=10.50.50.2-10.50.50.200
add name=pool-SecurityCameras&IoT ranges=10.60.60.2-10.60.60.200
/ip dhcp-server
add address-pool=pool-Guest/PublicWiFi interface=Guest/PublicWiFi lease-time=\
    1h name=dhcp1
add address-pool=pool-SecurityCameras&IoT interface=SecurityCameras&IoT \
    lease-time=1h name=dhcp2
/port
set 0 name=serial0
set 1 name=serial1
/routing id
add disabled=no id=4.4.4.1 name=id-1 select-dynamic-id=any,only-loopback
/routing ospf instance
add name=ospf-instance-1-BACKBONE router-id=id-1
/routing ospf area
add area-id=0.0.0.3 instance=ospf-instance-1-BACKBONE name=ospf-area-3 type=\
    stub
/snmp community
set [ find default=yes ] name=BTAPSecure2026 security=authorized
/interface bridge port
add bridge=SWITCH interface=ether4 pvid=50
/interface bridge vlan
add bridge=SWITCH tagged=SWITCH vlan-ids=50
/interface list member
add interface=Guest/PublicWiFi list=VLAN
add interface=SecurityCameras&IoT list=VLAN
/ip address
add address=10.3.3.2/30 interface=ether1 network=10.3.3.0
add address=10.50.50.1/24 interface=Guest/PublicWiFi network=10.50.50.0
add address=4.4.4.1 interface=loopback0 network=4.4.4.1
add address=10.60.60.1/24 interface=SecurityCameras&IoT network=10.60.60.0
add address=10.61.61.1/30 interface=vlan99-Management network=10.61.61.0
/ip dhcp-server network
add address=10.50.50.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=10.50.50.1 \
    netmask=24
add address=10.60.60.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=10.60.60.1
/ip firewall address-list
add address=10.50.50.0/24 list=LAN
add address=10.60.60.0/24 list=LAN
add address=10.60.60.0/24 list="Network VLan 60 dan Vlan 10"
add address=10.10.10.0/24 list="Network VLan 60 dan Vlan 10"
/ip firewall filter
add action=accept chain=input comment="Default accept input" \
    connection-state=established,related
add action=accept chain=forward comment="Defaul accept forward" \
    connection-state=established,related
add action=accept chain=forward comment=\
    "Allow Traffic vlan 20(Staff) to vlan 60(Camera)" dst-address=\
    10.60.60.0/24 src-address=10.20.20.0/24
add action=accept chain=forward comment=\
    "Allow ICMP from Vlan30(Adventure VR) to Vlan60(Camera)" dst-address=\
    10.60.60.0/24 protocol=icmp src-address=10.30.30.0/24
add action=drop chain=forward comment="memblokir traffic vlan 50 ke vlan 10" \
    dst-address-list="Network VLan 60 dan Vlan 10" src-address=10.50.50.0/24
add action=drop chain=forward comment=\
    "Block Trafiic from other vlan to vlan60(Camera)" dst-address=\
    10.60.60.0/24
add action=accept chain=input comment="allow OSPF protocol" protocol=ospf
add action=accept chain=input comment="Accept DHCP for client" dst-port=67,68 \
    in-interface-list=VLAN protocol=udp src-address-list=LAN
add action=accept chain=input comment="Allow SNMP trap and pool" dst-port=\
    161,162 protocol=udp src-address=10.10.10.100
add action=accept chain=input comment="Allow winbox and SSH access" dst-port=\
    8291,22 protocol=tcp src-address=10.10.10.100
add action=accept chain=forward comment=\
    "Allow forwarding ICMP packet for Troubleshooting" protocol=icmp
add action=drop chain=input comment="Default input drop" connection-state=\
    invalid,new
add action=drop chain=forward comment="Default drop forward" \
    connection-state=invalid,new
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
/routing ospf interface-template
add area=ospf-area-3 auth=md5 auth-id=3 auth-key=areaINT3 interfaces=ether1 \
    networks=10.3.3.0/30 type=ptp
add area=ospf-area-3 interfaces=Guest/PublicWiFi networks=10.50.50.0/24 \
    passive
add area=ospf-area-3 interfaces=SecurityCameras&IoT networks=10.60.60.0/24 \
    passive
add area=ospf-area-3 interfaces=vlan99-Management networks=10.61.61.0/30 \
    passive
add area=ospf-area-3 interfaces=loopback0 networks=4.4.4.1/32 passive
/snmp
set enabled=yes trap-target=10.10.10.100 trap-version=2
/system identity
set name=SW-L3-SEC
