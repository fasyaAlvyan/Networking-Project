/system identity set name=mikrotik-1
/ip address
add address=1.1.1.1/30 comment="its for router1(eth1) to router2(eth1)" interface=ether1 network=1.1.1.0
add address=2.2.2.1/30 comment="its for router1(eth2) to router3(eth1)" interface=ether2 network=2.2.2.0
add address=192.168.1.1/24 comment="ip for client in local network" interface=ether3 network=192.168.1.0
/ip route
add check-gateway=none disabled=no distance=10 dst-address=192.168.2.0/24 gateway=1.1.1.2
add check-gateway=none disabled=no distance=1 dst-address=192.168.2.0/24 gateway=2.2.2.2
