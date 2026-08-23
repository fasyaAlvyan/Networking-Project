/system identity set name=mikrotik-4
/ip address
add address=3.3.3.2/30 comment="its for router4(eth2) to router2(eth2)" interface=ether2 network=3.3.3.0
add address=4.4.4.2/30 comment="its for router4(eth1) to router3(eth2)" interface=ether1 network=4.4.4.0
add address=192.168.2.1/24 comment="its for local network" interface=ether3 network=192.168.2.0
/ip route 
add check-gateway=ping disabled=no distance=1 dst-address=192.168.1.0/24 gateway=4.4.4.1
add check-gateway=ping disabled=no distance=10 dst-address=192.168.1.0/24 gateway=3.3.3.1
