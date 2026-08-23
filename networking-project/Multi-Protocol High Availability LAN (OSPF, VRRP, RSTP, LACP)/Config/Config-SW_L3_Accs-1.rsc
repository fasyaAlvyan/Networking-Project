# aug/23/2026 10:48:45 by RouterOS 7.1
# software id = 
#
/interface bridge
add comment="Non-Root-Bridge(BCK)" mtu=1500 name=Switch-L2-Accs priority=\
    0x2000 vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] comment=Bonding-to-Eth8_SW_Dist
set [ find default-name=ether2 ] comment=Bonding-to-Eth9_SW_Dist
set [ find default-name=ether3 ] comment=Bonding-to-Eth3_SW_Accs-2
set [ find default-name=ether4 ] comment=Bonding-to-Eth4_SW_Accs-2
set [ find default-name=ether5 ] comment="DataBase Server"
set [ find default-name=ether6 ] comment="VRRP-GW(BCK)-VLAN-100"
set [ find default-name=ether7 ] comment=Management-Port
set [ find default-name=ether8 ] comment=Web-Server
set [ find default-name=ether9 ] comment=Mail-Server
set [ find default-name=ether10 ] comment=Server
/interface bonding
add comment="LAG(3)-to-SW_L2_Accs_2" down-delay=100ms lacp-rate=1sec \
    mii-interval=80ms mode=802.3ad name=LAG-to-SW_L2_Accs_2 slaves=\
    ether4,ether3 transmit-hash-policy=layer-2-and-3 up-delay=100ms
add comment="LAG(1)-to-SW_L3_Dist_1" down-delay=100ms lacp-rate=1sec \
    mii-interval=80ms mode=802.3ad name=LAG-to-SW_L3_Dist slaves=\
    ether1,ether2 transmit-hash-policy=layer-2-and-3 up-delay=100ms
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/port
set 0 name=serial0
set 1 name=serial1
/interface bridge port
add bridge=Switch-L2-Accs comment="TRUNK-VLAN 100" interface=\
    LAG-to-SW_L3_Dist
add bpdu-guard=yes bridge=Switch-L2-Accs comment=ACCS-Database-Server edge=\
    yes interface=ether5 point-to-point=yes pvid=100 restricted-role=yes \
    restricted-tcn=yes
add bridge=Switch-L2-Accs comment="TRUNK-VLAN 200" interface=\
    LAG-to-SW_L2_Accs_2 point-to-point=yes
add bpdu-guard=yes bridge=Switch-L2-Accs comment=\
    "ACCS-VRRP-GATEWAY(BCK)-VLAN-100" interface=ether6 pvid=100 \
    restricted-role=yes restricted-tcn=yes
add bpdu-guard=yes bridge=Switch-L2-Accs comment=ACCS-Web-Server edge=yes \
    interface=ether8 point-to-point=yes pvid=100 restricted-role=yes \
    restricted-tcn=yes
add bpdu-guard=yes bridge=Switch-L2-Accs comment=ACCS-Mail-Server edge=yes \
    interface=ether9 point-to-point=yes pvid=100 restricted-role=yes \
    restricted-tcn=yes
add bpdu-guard=yes bridge=Switch-L2-Accs comment=ACCS-Server edge=yes \
    interface=ether10 point-to-point=yes pvid=100 restricted-role=yes \
    restricted-tcn=yes
/interface bridge vlan
add bridge=Switch-L2-Accs comment="VLAN-100 Server" tagged=\
    LAG-to-SW_L2_Accs_2,LAG-to-SW_L3_Dist untagged=\
    ether5,ether6,ether7,ether8,ether9,ether10 vlan-ids=100
add bridge=Switch-L2-Accs comment="VLAN-200 Office" tagged=\
    LAG-to-SW_L2_Accs_2,LAG-to-SW_L3_Dist vlan-ids=200
/system identity
set name=Switch_L2_Accs-01
