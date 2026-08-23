# apr/28/2026 14:16:17 by RouterOS 7.1
# software id = 
#
/interface bridge
add name=loopback0
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/port
set 0 name=serial0
set 1 name=serial1
/routing id
add id=0.0.1.1 name=id-1 select-dynamic-id=only-loopback
/routing ospf instance
add name=ospf-instance-1 router-id=id-1
/routing ospf area
add area-id=0.0.0.1 instance=ospf-instance-1 name=ospf-area-1 type=stub
/snmp community
set [ find default=yes ] name=BTAPSecure2026 security=authorized
/ip address
add address=10.1.1.2/30 interface=ether1 network=10.1.1.0
add address=2.2.2.1 interface=loopback0 network=0.0.1.1
/ip firewall filter
add action=accept chain=input comment="Default accept input" \
    connection-state=established,related
add action=accept chain=forward comment="Defaul accept forward" \
    connection-state=established,related
add action=accept chain=input comment="allow OSPF protocol" protocol=ospf
add action=accept chain=input comment="Accept DHCP for client" dst-port=67,68 \
    protocol=udp
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
add area=ospf-area-1 auth=md5 auth-id=11 auth-key=areaINT interfaces=ether1 \
    networks=10.1.1.0/30 type=ptp
add area=ospf-area-1 interfaces=loopback0 networks=2.2.2.1/32 passive
/snmp
set enabled=yes trap-target=10.10.10.100 trap-version=2
/system identity
set name=R-ADV-INT
