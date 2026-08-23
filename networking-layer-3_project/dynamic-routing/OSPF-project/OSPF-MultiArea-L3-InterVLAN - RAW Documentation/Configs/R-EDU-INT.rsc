# apr/28/2026 14:28:42 by RouterOS 7.1
# software id = 
#
/interface bridge
add name=SWITCH vlan-filtering=yes
add name=loopback0
/interface vlan
add comment=TRUNK+OSPF interface=SWITCH name=vlan99-Management vlan-id=99
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/port
set 0 name=serial0
set 1 name=serial1
/routing id
add disabled=no id=3.3.3.1 name=id-1 select-dynamic-id=only-loopback
/routing ospf instance
add name=ospf-instance-1-INTERNAL_AREA-2 router-id=id-1
/routing ospf area
add area-id=0.0.0.2 instance=ospf-instance-1-INTERNAL_AREA-2 name=ospf-area-2 \
    type=stub
/snmp community
set [ find default=yes ] name=BTAPSecure2026 security=authorized
/interface bridge port
add bridge=SWITCH interface=ether3 pvid=40
add bridge=SWITCH interface=ether1 pvid=99
/interface bridge vlan
add bridge=SWITCH tagged=ether1 untagged=ether3 vlan-ids=40
add bridge=SWITCH tagged=SWITCH,ether1 vlan-ids=99
/ip address
add address=10.2.2.2/30 interface=vlan99-Management network=10.2.2.0
add address=3.3.3.1 interface=loopback0 network=3.3.3.1
/ip firewall filter
add action=accept chain=input comment="Default accept input" \
    connection-state=established,related
add action=accept chain=forward comment="Defaul accept forward" \
    connection-state=established,related
add action=accept chain=input comment="allow OSPF protocol" protocol=ospf
add action=accept chain=input comment="Allow DHCP for Clien" dst-port=67,68 \
    protocol=udp
add action=accept chain=input comment="Allow SNMP trap and pool" dst-port=\
    161,162 protocol=udp src-address=10.10.10.100
add action=accept chain=input comment="Allow winbox and SSH access" dst-port=\
    8291,22 protocol=tcp src-address=10.10.10.100
add action=accept chain=forward comment=\
    "Allow forwarding ICMP packet for Troubleshooting" protocol=icmp
add action=drop chain=input comment="Default input drop" connection-state=\
    invalid,new disabled=yes
add action=drop chain=forward comment="Default drop forward" \
    connection-state=invalid
/ip route
add dst-address=0.0.0.0/0 gateway=10.2.2.1
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
/routing ospf interface-template
add area=ospf-area-2 auth=md5 auth-id=2 auth-key=areaINT interfaces=\
    vlan99-Management networks=10.2.2.0/30 type=ptp
add area=ospf-area-2 interfaces=loopback0 networks=3.3.3.1/32
/snmp
set enabled=yes trap-target=10.10.10.100 trap-version=2
/system identity
set name=R-EDU-INT
