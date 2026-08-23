# apr/28/2026 14:31:27 by RouterOS 7.1
# software id = 
#
/interface bridge
add name=SWITCH vlan-filtering=yes
add name=loopback0
/interface vlan
add interface=SWITCH name=Staff vlan-id=20
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=pool-Staff ranges=10.20.20.2-10.20.20.200
/ip dhcp-server
add address-pool=pool-Staff interface=Staff lease-time=1h name=dhcp1
/port
set 0 name=serial0
set 1 name=serial1
/routing id
add disabled=no id=4.4.4.4 name=id-1 select-dynamic-id=any,only-loopback
/routing ospf instance
add name=ospf-instance-1 router-id=id-1
/routing ospf area
add instance=ospf-instance-1 name=ospf-area-0-BACKBONE
add area-id=0.0.0.3 instance=ospf-instance-1 name=ospf-area-3 type=stub
/snmp community
set [ find default=yes ] name=BTAPSecure2026 security=authorized
/interface bridge port
add bridge=SWITCH interface=ether4 pvid=20
/interface bridge vlan
add bridge=SWITCH tagged=SWITCH untagged=ether4 vlan-ids=20
/ip address
add address=10.0.3.2/30 interface=ether1 network=10.0.3.0
add address=4.4.4.4 interface=loopback0 network=4.4.4.4
add address=10.3.3.1/30 interface=ether2 network=10.3.3.0
add address=10.20.20.1/24 interface=Staff network=10.20.20.0
/ip dhcp-server network
add address=10.20.20.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=10.20.20.1
/ip firewall filter
add action=accept chain=input comment="Default accept input" \
    connection-state=established,related
add action=accept chain=forward comment="Defaul accept forward" \
    connection-state=established,related
add action=accept chain=input comment="allow OSPF protocol" protocol=ospf
add action=accept chain=input comment="Accept DHCP for client" dst-port=67,68 \
    in-interface=Staff protocol=udp
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
add area=ospf-area-0-BACKBONE auth=md5 auth-id=3 auth-key=area3 interfaces=\
    ether1 networks=10.0.3.0/30 type=ptp
add area=ospf-area-3 auth=md5 auth-id=3 auth-key=areaINT3 interfaces=ether2 \
    networks=10.3.3.0/30 type=ptp
add area=ospf-area-3 interfaces=Staff networks=10.20.20.0/24 passive
add area=ospf-area-0-BACKBONE interfaces=loopback0 networks=4.4.4.4/32 \
    passive
/snmp
set enabled=yes trap-target=10.10.10.100 trap-version=2
/system identity
set name=R-STAFF-ABR
