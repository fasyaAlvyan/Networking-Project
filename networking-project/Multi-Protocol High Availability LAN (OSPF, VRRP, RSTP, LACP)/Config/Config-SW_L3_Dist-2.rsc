# aug/23/2026 17:56:13 by RouterOS 7.1
# software id = 
#
/interface bridge
add name=LoopBack protocol-mode=none
add comment=Root-Bridge name=Switch-L3-Dist-2 priority=0 vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] comment=Bonding-to-Eth3-R_Core
set [ find default-name=ether2 ] comment=Bonding-to-Eth5-R_Core
set [ find default-name=ether3 ] comment=Bonding-to-Eth3-SW_L3_Dist
set [ find default-name=ether4 ] disabled=yes
set [ find default-name=ether5 ] comment=Management-Port
set [ find default-name=ether6 ] comment=Bonding-to-Eth2-SW_L2_Accs-4
set [ find default-name=ether7 ] comment=Bonding-to-Eth2-SW_L2_Accs-4
set [ find default-name=ether8 ] comment=Bonding-to-Eth2-SW_L2_Accs_3
set [ find default-name=ether9 ] comment=Bonding-to-Eth1-SW_L2_Accs_3
set [ find default-name=ether10 ] comment=Bonding-to-Eth10-SW_L3_Dist
set [ find default-name=ether11 ] comment=VRRP-GW-BCK-Swl2_Accs2-eth7
/interface vlan
add comment="Vlan-300(Guest)" interface=Switch-L3-Dist-2 mtu=1480 name=\
    "Vlan-300(Guest)" vlan-id=300
add comment="Vlan-400 (Engineer)" interface=Switch-L3-Dist-2 mtu=1480 name=\
    "Vlan-400 (Engineer)" vlan-id=400
/interface bonding
add comment=LAG-to-R_core down-delay=100ms lacp-rate=1sec mii-interval=80ms \
    mode=802.3ad name=LAG-to-R_Core slaves=ether2,ether1 \
    transmit-hash-policy=layer-2-and-3 up-delay=100ms
add comment="LAG(4)-to-SW_L2_Accs_3" down-delay=100ms lacp-rate=1sec \
    mii-interval=80ms mode=802.3ad name=LAG-to-SW-L2-Accs-3 slaves=\
    ether8,ether9 transmit-hash-policy=layer-2-and-3 up-delay=100ms
add comment="LAG(5)-to-SW_L2_Accs_4" down-delay=100ms lacp-rate=1sec \
    mii-interval=80ms mode=802.3ad name=LAG-to-SW_L2_Accs_4 slaves=\
    ether7,ether6 transmit-hash-policy=layer-2-and-3 up-delay=100ms
add comment=LAG-to-SW_L3_Dist_1 down-delay=100ms lacp-rate=1sec mii-interval=\
    80ms mode=802.3ad name=LAG-to-SW_L3_Dist_1 slaves=ether3,ether10 \
    transmit-hash-policy=layer-2-and-3 up-delay=100ms
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=IP_Guest ranges=192.168.20.3-192.168.20.100
add name=IP_Office ranges=192.168.10.101-192.168.10.200
add name=IP_Server ranges=10.20.1.8-10.20.1.13
/ip dhcp-server
add address-pool=IP_Guest interface="Vlan-300(Guest)" name=DHCP_For_Vlan-300
add add-arp=yes address-pool=IP_Office interface=ether11 name=\
    DHCP_For_Vlan-200
add address-pool=IP_Server interface=ether12 name=DHCP_For_Vlan-100
/port
set 0 name=serial0
set 1 name=serial1
/routing id
add disabled=no id=10.0.0.3 name=id-1 select-dynamic-id=any,only-loopback
/routing ospf instance
add name=ospf-instance-AREA-0 redistribute="" router-id=id-1
/routing ospf area
add instance=ospf-instance-AREA-0 name=ospf-area-0
/interface vrrp
add comment="Vlan-100-BACKUP(Pr.100)" group-master=VRRP-1-VLAN-100-SERVER \
    interface=ether12 name=VRRP-1-VLAN-100-SERVER preemption-mode=no
add comment="Vlann-200-BACKUP(Pr.100)" group-master=VRRP-2-VLAN-200-OFFICE \
    interface=ether11 name=VRRP-2-VLAN-200-OFFICE preemption-mode=no vrid=2
add comment="Vlan-300-MASTER(Pr.254)" group-master=VRRP-3-VLAN-300-GUEST \
    interface="Vlan-300(Guest)" name=VRRP-3-VLAN-300-GUEST priority=254 vrid=\
    3
add comment="Vlan-400-MASTER(Pr.254)" group-master=\
    VRRP-4-VLAN-400-Engineering interface="Vlan-400 (Engineer)" name=\
    VRRP-4-VLAN-400-Engineering priority=254 vrid=4
/interface bridge port
add bridge=Switch-L3-Dist-2 comment="TRUNK-VLAN-300(GUEST)" interface=\
    LAG-to-SW-L2-Accs-3
add bridge=Switch-L3-Dist-2 comment="TRUNK-VLAN-400(ENGINEERING)" interface=\
    LAG-to-SW_L2_Accs_4
/interface bridge vlan
add bridge=Switch-L3-Dist-2 tagged=\
    LAG-to-SW-L2-Accs-3,LAG-to-SW_L2_Accs_4,Switch-L3-Dist-2 vlan-ids=300
add bridge=Switch-L3-Dist-2 tagged=\
    LAG-to-SW_L2_Accs_4,LAG-to-SW-L2-Accs-3,Switch-L3-Dist-2 vlan-ids=400
/ip address
add address=10.1.0.2/30 comment=IP-R_CORE interface=LAG-to-R_Core network=\
    10.1.0.0
add address=10.2.1.2/30 comment=IP_SW_L3_Dist_1 interface=LAG-to-SW_L3_Dist_1 \
    network=10.2.1.0
add address=192.168.20.1/24 comment=IP-VLAN_300_Guest interface=\
    "Vlan-300(Guest)" network=192.168.20.0
add address=10.10.11.1/29 comment="IP-VLAN_400 Engineer" interface=\
    "Vlan-400 (Engineer)" network=10.10.11.0
add address=10.0.0.3 comment="LoopBack OSPF" interface=LoopBack network=\
    10.0.0.3
add address=192.168.10.254/24 comment="Virtual-GW(BCK)-Vlan-200" interface=\
    VRRP-2-VLAN-200-OFFICE network=192.168.10.0
add address=192.168.10.2 comment=IP-VLAN-200-OFFICE interface=ether11 \
    network=192.168.10.0
add address=10.20.1.14/28 comment="Virtual-GW(BCK)-Vlan-100" interface=\
    VRRP-1-VLAN-100-SERVER network=10.20.1.0
add address=10.20.1.2/28 comment=IP-VLAN-100-SERVER interface=ether12 \
    network=10.20.1.0
add address=192.168.20.254/24 comment=Virtual-GW-Vlan-300 interface=\
    VRRP-3-VLAN-300-GUEST network=192.168.20.0
add address=10.10.11.6/29 comment=Virtual-GW-Vlan-400 interface=\
    VRRP-4-VLAN-400-Engineering network=10.10.11.0
/ip dhcp-server network
add address=10.20.1.0/28 dns-server=1.1.1.1 gateway=10.20.1.14
add address=192.168.10.0/24 dns-server=1.1.1.1 gateway=192.168.10.254
add address=192.168.20.0/24 dns-server=1.1.1.1 gateway=192.168.20.254
/ip firewall filter
add action=drop chain=input comment="Drop invalid connect to Switch" \
    connection-state=invalid
add action=drop chain=forward comment="Drop Invalid Connect to Network" \
    connection-state=invalid
add action=accept chain=forward comment="Allow HTTP/HTTPS to Web Server" \
    dst-address=10.20.1.12 dst-port=80,443 protocol=tcp
add action=accept chain=forward comment=\
    "Allow DNS resolve to DNS server(TCP)" dst-address=10.20.1.8 dst-port=53 \
    protocol=tcp
add action=accept chain=forward comment=\
    "Allow DNS resolve to DNS server(UDP)" dst-address=10.20.1.8 dst-port=53 \
    protocol=udp
add action=drop chain=forward comment="Deny Vlan Guest-2 to Vlan 200" \
    connection-state=invalid,new dst-address=192.168.10.0/24 src-address=\
    192.168.100.0/24
add action=drop chain=forward comment="Deny non-Engineering to VLAN 100" \
    connection-state=invalid,new dst-address=10.20.1.0/28 log=yes \
    src-address-list=VLANs-1,200
add action=drop chain=forward comment="Deny Vlan Guest to Vlan 200" \
    connection-state=invalid,new dst-address=192.168.10.0/24 src-address=\
    192.168.20.0/24
add action=drop chain=forward comment="Deny non-Engineering to VLAN 100" \
    connection-state=invalid,new dst-address=10.20.1.0/28 src-address=\
    192.168.20.0/24
/ip firewall nat
add action=masquerade chain=srcnat out-interface=LAG-to-R_Core
/routing ospf interface-template
add area=ospf-area-0 auth=md5 auth-key=labwkwk comment="PTP OSPF to R_Core" \
    interfaces=LAG-to-R_Core networks=10.1.0.0/30 type=ptp
add area=ospf-area-0 auth=md5 auth-key=labwkwk comment=\
    "PTP OSPF to SW_L3_Dist-1" interfaces=LAG-to-SW_L3_Dist_1 networks=\
    10.2.1.0/30 type=ptp
add area=ospf-area-0 comment="Passive Interface VLAN-300" interfaces=\
    "Vlan-300(Guest)" networks=192.168.20.0/24 passive
add area=ospf-area-0 comment="Passive Interface VLAN-400" interfaces=\
    "Vlan-400 (Engineer)" networks=10.10.11.0/29 passive
/system identity
set name=Switch_L3_Dist-2
