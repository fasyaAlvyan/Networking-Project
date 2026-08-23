/system identity set name=mikrotik-2
/ip address
add address=1.1.1.2/30 comment="its for router2(eth1) to router1(eth1)" interface=ether1 network=1.1.1.0
add address=3.3.3.1/30 comment="its for router2(eth2) to router4(eth2)" interface=ether2 network=3.3.3.0
/ip route
add disabled=no dst-address=192.168.2.0/24 gateway=3.3.3.2
add disabled=no dst-address=192.168.1.0/24 gateway=1.1.1.1
