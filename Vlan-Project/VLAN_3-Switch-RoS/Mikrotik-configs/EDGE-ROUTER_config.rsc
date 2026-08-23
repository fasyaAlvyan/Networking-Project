/system identity
set name=EDGE-ROUTER
/interface vlan
add interface=ether2 name=Native-Management vlan-id=99
add interface=ether2 name=Vlan20 vlan-id=20
add interface=ether2 name=vlan10 vlan-id=10
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=dhcp_pool0 ranges=192.168.10.2-192.168.10.254
add name=dhcp_pool1 ranges=192.168.20.2-192.168.20.254
/ip dhcp-server
add address-pool=dhcp_pool0 interface=vlan10 name=dhcp1
add address-pool=dhcp_pool1 interface=Vlan20 name=dhcp2
/port
set 0 name=serial0
set 1 name=serial1
/ip address
add address=192.168.10.1/24 interface=vlan10 network=192.168.10.0
add address=192.168.20.1/24 interface=Vlan20 network=192.168.20.0
add address=10.1.99.1/29 interface=Native-Management network=10.1.99.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server network
add address=192.168.10.0/24 gateway=192.168.10.1
add address=192.168.20.0/24 gateway=192.168.20.1
/tool romon
set enabled=yes
