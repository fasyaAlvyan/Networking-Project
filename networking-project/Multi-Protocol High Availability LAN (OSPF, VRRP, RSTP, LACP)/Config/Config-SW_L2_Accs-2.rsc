# aug/23/2026 10:49:26 by RouterOS 7.1
# software id = 
#
/interface bridge
add comment="Non-Root-Bridge(BCK)" mtu=1500 name=Switch-L2_Accs_2 priority=\
    0x4000 vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] comment=Bonding-to-Eth9_SW_L3_Dist
set [ find default-name=ether2 ] comment=Bonding-to-Eth_8_SW_L3_Dist
set [ find default-name=ether3 ] comment=Bonding-to-Eth3_SW_Accs-1
set [ find default-name=ether4 ] comment=Bonding-to-Eth4_SW_Accs-1
set [ find default-name=ether5 ] comment=Client
set [ find default-name=ether6 ] comment=Management-Port
set [ find default-name=ether7 ] comment="VRRP-GW(BCK)-Vlan-200"
set [ find default-name=ether8 ] comment=Client
/interface bonding
add comment="LAG(3)-to-SW_L2_Accs_1" down-delay=100ms lacp-rate=1sec \
    mii-interval=80ms mode=802.3ad name=LAG-to-SW_L2_Accs_1 slaves=\
    ether4,ether3 transmit-hash-policy=layer-2-and-3 up-delay=100ms
add comment="LAG(2)-to-SW_L3_Dist_1" down-delay=100ms lacp-rate=1sec \
    mii-interval=80ms mode=802.3ad name=LAG-to-SW_L3_Dist_1 slaves=\
    ether1,ether2 transmit-hash-policy=layer-2-and-3 up-delay=100ms
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/port
set 0 name=serial0
set 1 name=serial1
/interface bridge port
add bridge=Switch-L2_Accs_2 comment="TRUNK VLAN-100" interface=\
    LAG-to-SW_L3_Dist_1
add bridge=Switch-L2_Accs_2 comment="TRUNK VLAN-200" interface=\
    LAG-to-SW_L2_Accs_1
add bpdu-guard=yes bridge=Switch-L2_Accs_2 comment=ACCS-Client edge=yes \
    interface=ether8 point-to-point=yes pvid=200 restricted-role=yes \
    restricted-tcn=yes
add bpdu-guard=yes bridge=Switch-L2_Accs_2 comment=ACCS-Client edge=yes \
    interface=ether5 point-to-point=yes pvid=200 restricted-role=yes \
    restricted-tcn=yes
add bpdu-guard=yes bridge=Switch-L2_Accs_2 comment=\
    "ACCS-VRRP-Gateway(BCK)-VLAN-200" edge=yes interface=ether7 \
    point-to-point=yes pvid=200 restricted-role=yes restricted-tcn=yes
/interface bridge vlan
add bridge=Switch-L2_Accs_2 comment=Vlan-100-Server tagged=\
    LAG-to-SW_L3_Dist_1,LAG-to-SW_L2_Accs_1 vlan-ids=100
add bridge=Switch-L2_Accs_2 comment=Vlan-200-Office tagged=\
    LAG-to-SW_L3_Dist_1,LAG-to-SW_L2_Accs_1 untagged=ether5,ether7,ether8 \
    vlan-ids=200
/ip dhcp-client
# DHCP client can not run on slave interface!
add interface=ether1
/system identity
set name=Switch_L2_Accs-02
