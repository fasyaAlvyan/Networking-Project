# apr/28/2026 14:36:31 by RouterOS 7.1
# software id = 
#
/interface bridge
add name=SWITCH vlan-filtering=yes
/interface vlan
add comment="FOR SNMP" interface=SWITCH name=vlan99-management vlan-id=99
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/port
set 0 name=serial0
set 1 name=serial1
/snmp community
set [ find default=yes ] name=BTAPSecure2026 security=authorized
/interface bridge port
add bridge=SWITCH interface=ether1 pvid=99
add bridge=SWITCH interface=ether3 pvid=60
add bridge=SWITCH interface=ether4 pvid=60
add bridge=SWITCH interface=ether5 pvid=60
add bridge=SWITCH interface=ether6 pvid=60
/interface bridge vlan
add bridge=SWITCH tagged=ether1 untagged=ether3,ether4,ether5,ether6 \
    vlan-ids=60
add bridge=SWITCH tagged=SWITCH,ether1 vlan-ids=99
/ip address
add address=10.61.61.2/30 interface=vlan99-management network=10.61.61.0
/ip route
add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=10.61.61.1 pref-src=\
    "" routing-table=main scope=30 suppress-hw-offload=no target-scope=10
/snmp
set enabled=yes trap-target=10.10.10.100 trap-version=2
/system identity
set name=SW-L2-CAM
