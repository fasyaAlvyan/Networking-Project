/interface bridge
add name=loopback0
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=dhcp_pool0 ranges=192.168.20.2-192.168.20.126
/ip dhcp-server
add address-pool=dhcp_pool0 interface=ether3 name=dhcp1
/port
set 0 name=serial0
set 1 name=serial1
/routing id
add disabled=no id=3.3.3.3 name=id-1 select-dynamic-id=any
/routing ospf instance
add name=ospf-instance-1 router-id=id-1
/routing ospf area
add instance=ospf-instance-1 name=ospf-area-1
/ip address
add address=10.1.2.2/30 interface=ether1 network=10.1.2.0
add address=10.1.3.1/30 interface=ether2 network=10.1.3.0
add address=192.168.20.1/25 interface=ether3 network=192.168.20.0
add address=3.3.3.3 interface=loopback0 network=3.3.3.3
/ip dhcp-server network
add address=192.168.20.0/25 dns-server=8.8.8.8,1.1.1.1 gateway=192.168.20.1
/routing ospf interface-template
add area=ospf-area-1 comment="Backup path" cost=100 interfaces=ether1 \
    networks=10.1.2.0/30 type=ptp
add area=ospf-area-1 comment="Primary path" cost=10 interfaces=ether2 \
    networks=10.1.3.0/30 type=ptp
add area=ospf-area-1 dead-interval=10s hello-interval=5s interfaces=ether3 \
    networks=192.168.20.0/25 passive
/system identity
set name=r3
