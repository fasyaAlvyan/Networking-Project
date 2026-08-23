# apr/28/2026 13:57:30 by RouterOS 7.1
# software id = 
#
/interface bridge
add name=loopback0
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=dhcp_pool0 ranges=10.30.30.2-10.30.30.254
/port
set 0 name=serial0
set 1 name=serial1
/routing id
add disabled=no id=1.1.1.2 name=id-1 select-dynamic-id=any select-from-vrf=\
    main
/routing ospf instance
add name=ospf-instance-1-BACKBONE originate-default=always router-id=id-1
/routing ospf area
add instance=ospf-instance-1-BACKBONE name=ospf-area-0-BACKBONE
/snmp community
set [ find default=yes ] name=BTAPSecure2026 security=authorized
/ip address
add address=10.0.0.1/30 interface=ether2 network=10.0.0.0
add address=10.0.1.1/30 interface=ether3 network=10.0.1.0
add address=10.0.2.1/30 interface=ether4 network=10.0.2.0
add address=10.0.3.1/30 interface=ether5 network=10.0.3.0
add address=1.1.1.2 interface=loopback0 network=1.1.1.2
/ip dhcp-client
add interface=ether1
/ip dns
set servers=8.8.8.8,1.1.1.1
/ip firewall filter
add action=accept chain=input comment="Default accept input" \
    connection-state=established,related
add action=accept chain=forward comment="Defaul accept forward" \
    connection-state=established,related
add action=accept chain=input comment="allow OSPF protocol" protocol=ospf
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
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
/routing ospf interface-template
add area=ospf-area-0-BACKBONE auth=md5 auth-id=1 auth-key=area1 interfaces=\
    ether3 networks=10.0.1.0/30 type=ptp
add area=ospf-area-0-BACKBONE auth=md5 auth-id=2 auth-key=area2 interfaces=\
    ether4 networks=10.0.2.0/30 type=ptp
add area=ospf-area-0-BACKBONE auth=md5 auth-id=3 auth-key=area3 interfaces=\
    ether5 networks=10.0.3.0/30 type=ptp
add area=ospf-area-0-BACKBONE auth=md5 auth-id=100 auth-key=areaINT0 \
    interfaces=ether2 networks=10.0.0.0/30 type=ptp
add area=ospf-area-0-BACKBONE interfaces=loopback0 networks=1.1.1.2/32 \
    passive
/snmp
set enabled=yes trap-target=10.10.10.100 trap-version=2
/system identity
set name=R-CORE-ASBR
/system ntp client
set enabled=yes
/system ntp client servers
add address=0.id.pool.ntp.org
