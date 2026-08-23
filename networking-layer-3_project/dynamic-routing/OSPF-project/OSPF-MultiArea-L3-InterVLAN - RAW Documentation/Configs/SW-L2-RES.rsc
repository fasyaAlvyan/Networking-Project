# apr/28/2026 14:45:33 by RouterOS 7.1
# software id = 
#
/interface bridge
add name=SWITCH vlan-filtering=yes
/interface vlan
add comment="for SNMP" interface=SWITCH name=vlan99-SNMP vlan-id=99
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/port
set 0 name=serial0
set 1 name=serial1
/snmp community
set [ find default=yes ] name=BTAPSecure2026 security=authorized
/interface bridge port
add bridge=SWITCH comment=Trunk interface=ether1 pvid=99
add bridge=SWITCH comment=Access interface=ether2 pvid=30
add bridge=SWITCH comment=Access interface=ether3 pvid=30
/interface bridge vlan
add bridge=SWITCH tagged=ether1 untagged=ether2,ether3 vlan-ids=30
add bridge=SWITCH tagged=SWITCH,ether1 vlan-ids=99
/ip address
add address=10.31.31.2/30 interface=vlan99-SNMP network=10.31.31.0
/ip route
add dst-address=0.0.0.0/0 gateway=10.31.31.1
/snmp
set enabled=yes trap-target=10.10.10.100 trap-version=2
/system identity
set name=SW-L2-RES
