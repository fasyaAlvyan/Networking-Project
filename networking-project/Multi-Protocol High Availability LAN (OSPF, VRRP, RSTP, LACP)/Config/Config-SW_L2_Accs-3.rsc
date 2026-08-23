# aug/23/2026 10:50:09 by RouterOS 7.1
# software id = 
#
/interface bridge
add name=Switch-L2_Accs-3 priority=0x5000 vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] comment=Bonding-to-Eth9-SW_L3_Dist-2
set [ find default-name=ether2 ] comment=Bonding-to-Eth8-SW_L3_Dist-2
set [ find default-name=ether3 ] comment=Bonding-to-Eth3-SW_L2_Accs-4
set [ find default-name=ether4 ] comment=Bonding-to-Eth4-SW_L2_Accs-4
set [ find default-name=ether5 ] comment=Management-Port
set [ find default-name=ether6 ] comment=Client
set [ find default-name=ether7 ] comment=Client
set [ find default-name=ether8 ] comment=Client
set [ find default-name=ether9 ] comment="VRRP-GW(BCK)-Vlan-300"
/interface bonding
add comment="LAG(6)-to-SW_L2-Accs-04" down-delay=100ms lacp-rate=1sec \
    mii-interval=80ms mode=802.3ad name=LAG-to-SW_L2-Accs-04 slaves=\
    ether4,ether3 transmit-hash-policy=layer-2-and-3 up-delay=100ms
add comment="LAG(4)-to-SW_L3_Dist_02" down-delay=100ms lacp-rate=1sec \
    mii-interval=80ms mode=802.3ad name=LAG-to-SW_L3_Dist_02 slaves=\
    ether1,ether2 transmit-hash-policy=layer-2-and-3 up-delay=100ms
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/port
set 0 name=serial0
set 1 name=serial1
/interface bridge port
add bridge=Switch-L2_Accs-3 comment=TRUNK interface=LAG-to-SW_L3_Dist_02
add bpdu-guard=yes bridge=Switch-L2_Accs-3 comment=ACCS-Client edge=yes \
    interface=ether6 point-to-point=yes pvid=300 restricted-role=yes \
    restricted-tcn=yes
add bridge=Switch-L2_Accs-3 comment=TRUNK interface=LAG-to-SW_L2-Accs-04
add bpdu-guard=yes bridge=Switch-L2_Accs-3 comment=ACCS-Client edge=yes \
    interface=ether8 point-to-point=yes pvid=300 restricted-role=yes \
    restricted-tcn=yes
add bpdu-guard=yes bridge=Switch-L2_Accs-3 comment=ACCS-Client edge=yes \
    interface=ether7 point-to-point=yes pvid=300 restricted-role=yes \
    restricted-tcn=yes
add bpdu-guard=yes bridge=Switch-L2_Accs-3 comment=\
    "ACCS-VRRP-Gateway(BCK)-Vlan-300" edge=yes interface=ether9 \
    point-to-point=yes pvid=300 restricted-role=yes restricted-tcn=yes
/interface bridge vlan
add bridge=Switch-L2_Accs-3 comment="VLAN-300 Guest" tagged=\
    LAG-to-SW_L2-Accs-04,LAG-to-SW_L3_Dist_02 untagged=\
    ether6,ether7,ether8,ether9 vlan-ids=300
add bridge=Switch-L2_Accs-3 comment="VLAN-400 Engineering" tagged=\
    LAG-to-SW_L2-Accs-04,LAG-to-SW_L3_Dist_02 vlan-ids=400
/ip dhcp-client
# DHCP client can not run on slave interface!
add interface=ether1
/system identity
set name=Switch-L2-Accs-3
