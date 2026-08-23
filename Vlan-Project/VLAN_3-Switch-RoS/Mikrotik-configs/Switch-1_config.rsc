/interface bridge
add name=bridge1 pvid=99 vlan-filtering=yes
/interface vlan
add interface=bridge1 name=Management vlan-id=99
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/port
set 0 name=serial0
set 1 name=serial1
/interface bridge port
add bridge=bridge1 interface=ether1 pvid=10
add bridge=bridge1 interface=ether2 pvid=20
add bridge=bridge1 interface=ether3 pvid=99
add bridge=bridge1 interface=ether4 pvid=99
/interface bridge vlan
add bridge=bridge1 tagged=ether3,ether4 untagged=ether1 vlan-ids=10
add bridge=bridge1 tagged=ether3,ether4 untagged=ether2 vlan-ids=20
add bridge=bridge1 tagged=bridge1,ether3,ether4 vlan-ids=99
/ip address
add address=10.1.99.2/29 interface=Management network=10.1.99.0
/system identity
set name=s1
/tool romon
set enabled=yes