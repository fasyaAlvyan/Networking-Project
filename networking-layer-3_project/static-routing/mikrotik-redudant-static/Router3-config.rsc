/system identity set name=mikrotik-3
/ip address
add address=2.2.2.2/30 comment="its for router3(eth1) to router1(eth2)" interface=ether1 network=2.2.2.0
add address=4.4.4.1/30 comment="its for router3(eth2) to router4(eth1)" interface=ether2 network=4.4.4.0
/ip route
add disabled=no dst-address=192.168.1.0/24 gateway=2.2.2.1
add disabled=no dst-address=192.168.2.0/24 gateway=4.4.4.2
