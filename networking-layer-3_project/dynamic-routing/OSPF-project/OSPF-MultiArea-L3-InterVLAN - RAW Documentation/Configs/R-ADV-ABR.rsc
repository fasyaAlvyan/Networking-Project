# apr/28/2026 14:10:11 by RouterOS 7.1
# software id = 
#
/interface bridge
add name=loopback0
/interface vlan
add interface=ether3 name=vlan30-Adventure/VisitorVR vlan-id=30
add comment="for snmp" interface=ether3 name=vlan99 vlan-id=99
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=dhcp_pool0 ranges=10.30.30.2-10.30.30.200
/ip dhcp-server
add address-pool=dhcp_pool0 interface=vlan30-Adventure/VisitorVR lease-time=\
    1h name=dhcp1
/port
set 0 name=serial0
set 1 name=serial1
/routing id
add disabled=no id=2.2.2.2 name=id-1 select-dynamic-id=any,only-loopback
/routing ospf instance
add name=ospf-instance-1 router-id=id-1
/routing ospf area
add instance=ospf-instance-1 name=ospf-area-0-BACKBONE
add area-id=0.0.0.1 instance=ospf-instance-1 name=ospf-area-1 type=stub
/snmp community
set [ find default=yes ] name=BTAPSecure2026 security=authorized
/ip address
add address=10.0.1.2/30 interface=ether1 network=10.0.1.0
add address=2.2.2.2 interface=loopback0 network=2.2.2.2
add address=10.30.30.1/24 interface=vlan30-Adventure/VisitorVR network=\
    10.30.30.0
add address=10.1.1.1/30 interface=ether2 network=10.1.1.0
add address=10.31.31.1/30 interface=vlan99 network=10.31.31.0
/ip dhcp-server network
add address=10.30.30.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=10.30.30.1
/ip firewall filter
add action=accept chain=input comment="Default accept input" \
    connection-state=established,related
add action=accept chain=forward comment="Defaul accept forward" \
    connection-state=established,related
add action=accept chain=forward comment=\
    "Allow ICMP from Vlan30(Adventure VR) to Vlan60(Camera)" dst-address=\
    10.60.60.0/24 protocol=icmp src-address=10.30.30.0/24
add action=drop chain=forward comment=\
    "Block Traffic from Vlan 30(Adventure VR) to Vlan60(Camera)" dst-address=\
    10.60.60.0/24 src-address=10.30.30.0/24
add action=accept chain=input comment="allow OSPF protocol" protocol=ospf
add action=accept chain=input comment="Accept DHCP for client" dst-port=67,68 \
    in-interface=vlan30-Adventure/VisitorVR protocol=udp
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
add area=ospf-area-0-BACKBONE auth=md5 auth-id=1 auth-key=area1 interfaces=\
    ether1 networks=10.0.1.0/30 type=ptp
add area=ospf-area-1 auth=md5 auth-id=11 auth-key=areaINT interfaces=ether2 \
    networks=10.1.1.0/30 type=ptp
add area=ospf-area-1 interfaces=vlan30-Adventure/VisitorVR networks=\
    10.30.30.0/24 passive
add area=ospf-area-1 interfaces=vlan99 networks=10.31.31.0/30 passive
add area=ospf-area-0-BACKBONE interfaces=loopback0 networks=2.2.2.2/32 \
    passive
/snmp
set enabled=yes trap-target=10.10.10.100 trap-version=2
/system identity
set name=R-ADV-ABR
