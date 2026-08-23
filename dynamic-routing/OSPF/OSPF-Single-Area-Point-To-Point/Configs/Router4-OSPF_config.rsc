/interface bridge
add name=loopback0
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=dhcp_pool0 ranges=172.16.20.2-172.16.20.126
/ip dhcp-server
add address-pool=dhcp_pool0 interface=ether3 name=dhcp1
/port
set 0 name=serial0
set 1 name=serial1
/routing id
add disabled=no id=4.4.4.4 name=id-1 select-dynamic-id=any
/routing ospf instance
add name=ospf-instance-1 router-id=id-1
/routing ospf area
add instance=ospf-instance-1 name=ospf-area-1
/ip address
add address=10.1.4.2/30 interface=ether2 network=10.1.4.0
add address=10.1.3.2/30 interface=ether1 network=10.1.3.0
add address=172.16.20.1/25 interface=ether3 network=172.16.20.0
add address=4.4.4.4 interface=loopback0 network=4.4.4.4
/ip dhcp-server network
add address=172.16.20.0/25 dns-server=8.8.8.8,1.1.1.1 gateway=172.16.20.1
/routing ospf interface-template
add area=ospf-area-1 comment="Backup path" cost=100 interfaces=ether1 \
    networks=10.1.3.0/30 type=ptp
add area=ospf-area-1 comment="Primary path" cost=10 interfaces=ether2 \
    networks=10.1.4.0/30 type=ptp
add area=ospf-area-1 interfaces=ether3 networks=172.16.20.0/25 passive
/system identity
set name=r4
