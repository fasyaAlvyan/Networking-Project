/interface bridge
add name=loopback0
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=dhcp_pool0 ranges=192.168.10.2-192.168.10.126
/ip dhcp-server
add address-pool=dhcp_pool0 interface=ether3 name=dhcp1
/port
set 0 name=serial0
set 1 name=serial1
/routing id
add disabled=no id=1.1.1.1 name=id-1 select-dynamic-id=any
/routing ospf instance
add name=ospf-instance-1 redistribute="" router-id=id-1
/routing ospf area
add instance=ospf-instance-1 name=ospf-area-1
/ip address
add address=10.1.1.1/30 interface=ether1 network=10.1.1.0
add address=10.1.2.1/30 interface=ether2 network=10.1.2.0
add address=192.168.10.1/25 interface=ether3 network=192.168.10.0
add address=1.1.1.1 interface=loopback0 network=1.1.1.1
/ip dhcp-server network
add address=192.168.10.0/25 gateway=192.168.10.1
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,1.1.1.1
/routing ospf interface-template
add area=ospf-area-1 comment="Primary path" cost=10 instance-id=1 interfaces=\
    ether1 networks=10.1.1.0/30 type=ptp
add area=ospf-area-1 interfaces=ether3 networks=192.168.10.0/25 passive
add area=ospf-area-1 comment="Backup Path" cost=100 interfaces=ether2 \
    networks=10.1.2.0/30 type=ptp
/system identity
set name=r1
