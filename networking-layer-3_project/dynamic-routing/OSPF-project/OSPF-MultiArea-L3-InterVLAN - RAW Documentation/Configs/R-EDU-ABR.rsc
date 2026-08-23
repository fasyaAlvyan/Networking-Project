# apr/28/2026 14:26:30 by RouterOS 7.1
# software id = 
#
/interface bridge
add name=loopback0
/interface vlan
add interface=ether2 name=vlan40-Education/Classroom vlan-id=40
add interface=ether2 name=vlan99-Management vlan-id=99
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=vlan40-Education/Classroom ranges=10.40.40.2-10.40.40.200
/ip dhcp-server
add address-pool=vlan40-Education/Classroom interface=\
    vlan40-Education/Classroom lease-time=1h name=dhcp1
/port
set 0 name=serial0
set 1 name=serial1
/routing id
add disabled=no id=3.3.3.3 name=id-1 select-dynamic-id=only-loopback
/routing ospf instance
add name=ospf-instance-1 router-id=id-1
/routing ospf area
add instance=ospf-instance-1 name=ospf-area-0-BACKBONE
add area-id=0.0.0.2 instance=ospf-instance-1 name=ospf-area-2 type=stub
/snmp community
set [ find default=yes ] name=BTAPSecure2026 security=authorized
/ip address
add address=10.0.2.2/30 interface=ether1 network=10.0.2.0
add address=10.2.2.1/30 interface=vlan99-Management network=10.2.2.0
add address=3.3.3.3 interface=loopback0 network=3.3.3.3
add address=10.40.40.1/24 interface=vlan40-Education/Classroom network=\
    10.40.40.0
/ip dhcp-server network
add address=10.40.40.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=10.40.40.1
/ip firewall filter
add action=accept chain=input comment="Default accept input" \
    connection-state=established,related
add action=accept chain=forward comment="Defaul accept forward" \
    connection-state=established,related
add action=accept chain=input comment="allow OSPF protocol" protocol=ospf
add action=accept chain=input comment="Accept DHCP for client" dst-port=67,68 \
    in-interface=vlan40-Education/Classroom protocol=udp
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
add area=ospf-area-0-BACKBONE auth=md5 auth-id=2 auth-key=area2 interfaces=\
    ether1 networks=10.0.2.0/30 type=ptp
add area=ospf-area-2 auth=md5 auth-id=2 auth-key=areaINT interfaces=\
    vlan99-Management networks=10.2.2.0/30 type=ptp
add area=ospf-area-2 interfaces=vlan40-Education/Classroom networks=\
    10.40.40.0/24 passive
add area=ospf-area-0-BACKBONE interfaces=loopback0 networks=3.3.3.3/32
/snmp
set enabled=yes trap-target=10.10.10.100 trap-version=2
/system identity
set name=R-EDU-ABR
