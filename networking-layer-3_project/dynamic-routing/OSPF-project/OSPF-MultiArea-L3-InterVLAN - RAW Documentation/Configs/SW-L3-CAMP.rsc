# apr/28/2026 13:59:50 by RouterOS 7.1
# software id = 
#
/interface bridge
add name=SWITCH vlan-filtering=yes
add name=loopback0
/interface vlan
add interface=SWITCH name=vlan10-Management vlan-id=10
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=pool-vlan-Management ranges=10.10.10.2-10.10.10.200
/ip dhcp-server
add address-pool=pool-vlan-Management interface=vlan10-Management lease-time=\
    1h name=dhcp1
/port
set 0 name=serial0
set 1 name=serial1
/routing id
add disabled=no id=1.1.1.3 name=id-1 select-dynamic-id=only-loopback
/routing ospf instance
add name=ospf-instance-1-INT router-id=id-1
/routing ospf area
add instance=ospf-instance-1-INT name=ospf-area-0-BACKBONE
/snmp community
set [ find default=yes ] name=BTAPSecure2026 security=authorized
/interface bridge port
add bridge=SWITCH interface=ether4 pvid=10
add bridge=SWITCH interface=ether2 pvid=10
add bridge=SWITCH interface=ether3
/interface bridge vlan
add bridge=SWITCH tagged=SWITCH vlan-ids=10
/ip address
add address=10.0.0.2/30 interface=ether1 network=10.0.0.0
add address=10.10.10.1/24 interface=vlan10-Management network=10.10.10.0
add address=1.1.1.3 interface=loopback0 network=1.1.1.3
/ip dhcp-server network
add address=10.10.10.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=10.10.10.1
/ip firewall filter
add action=accept chain=input comment="Default accept input" \
    connection-state=established,related
add action=accept chain=forward comment="Defaul accept forward" \
    connection-state=established,related
add action=accept chain=input comment="allow OSPF protocol" protocol=ospf
add action=accept chain=input comment="Accept DHCP for client" dst-port=67,68 \
    in-interface=vlan10-Management protocol=udp
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
add area=ospf-area-0-BACKBONE auth=md5 auth-id=100 auth-key=areaINT0 \
    interfaces=ether1 networks=10.0.0.0/30 type=ptp
add area=ospf-area-0-BACKBONE interfaces=vlan10-Management networks=\
    10.10.10.0/24 passive
add area=ospf-area-0-BACKBONE interfaces=loopback0 networks=1.1.1.3/32 \
    passive
/snmp
set enabled=yes trap-target=10.10.10.100 trap-version=2
/system identity
set name=SW-L3-CAMP
