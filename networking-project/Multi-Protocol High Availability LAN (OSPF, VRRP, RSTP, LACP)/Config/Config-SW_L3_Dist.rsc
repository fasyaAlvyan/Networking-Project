# aug/23/2026 10:46:29 by RouterOS 7.1
# software id = 
#
/interface bridge
add name=LoopBack protocol-mode=none
add comment=Root-Bridge mtu=1500 name=SWITCH-L3 priority=0 vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] comment="Bonding-to-Eth4-( R_Core )"
set [ find default-name=ether2 ] comment="Bonding-to-Eth2-( R_Core )"
set [ find default-name=ether3 ] comment="Bonding-to-Eth3-( SW_L3_Dist_2 )"
set [ find default-name=ether4 ] comment=Native-VLAN-to-Legacy-SW
set [ find default-name=ether5 ] comment=Management-Port
set [ find default-name=ether6 ] comment="Bonding-to-eth2-( SW_L2_Accs_2 )"
set [ find default-name=ether7 ] comment="Bonding-to-eth1-( SW_L2_Accs_2 )"
set [ find default-name=ether8 ] comment="Bonding-to-Eth1-( SW_L2_Accs_1 )"
set [ find default-name=ether9 ] comment="Bonding-to-Eth2-( SW_L2_Accs_1 )"
set [ find default-name=ether10 ] comment="Bonding-to-Eth10-( SW_L3_Dist_2 )"
set [ find default-name=ether11 ] comment="VRRP-GW(BCK)-Vlan-300"
set [ find default-name=ether12 ] comment="VRRP-GW(BCK)-Vlan-400"
/interface vlan
add comment="Vlan-100(Server)" interface=SWITCH-L3 mtu=1480 name=\
    Vlan-100_Server vlan-id=100
add arp=reply-only comment="Vlan-200(Office)" interface=SWITCH-L3 mtu=1480 \
    name=Vlan-200_Office vlan-id=200
add comment=vlan1-Native-without-Tagging interface=SWITCH-L3 mtu=1480 name=\
    vlan1-Native vlan-id=1
/interface bonding
add comment=LAG-to-R_Core down-delay=100ms lacp-rate=1sec mii-interval=80ms \
    mode=802.3ad name=LAG-to-R_Core slaves=ether1,ether2 \
    transmit-hash-policy=layer-2-and-3 up-delay=100ms
add comment="LAG(1)-to-SW-L2-Accs_1" down-delay=100ms lacp-rate=1sec \
    mii-interval=80ms mode=802.3ad name=LAG-to-SW-L2-Accs1 slaves=\
    ether8,ether9 transmit-hash-policy=layer-2-and-3 up-delay=100ms
add comment="LAG(2)-to-SW-L2-Accs_2" down-delay=100ms lacp-rate=1sec \
    mii-interval=80ms mode=802.3ad name=LAG-to-SW-L2-Accs2 slaves=\
    ether6,ether7 transmit-hash-policy=layer-2-and-3 up-delay=100ms
add comment=LAG-to-SW_L3_Dist-2 lacp-rate=1sec mode=802.3ad name=\
    LAG-to-SW_L3_Dist_2 slaves=ether3,ether10 transmit-hash-policy=\
    layer-2-and-3
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=Server_IP ranges=10.20.1.3-10.20.1.7
add name=Office_IP ranges=192.168.10.3-192.168.10.99
add comment=Native-vlan-1-without-tagging name=Guest2_IP ranges=\
    192.168.100.2-192.168.100.254
add name=Guest_IP ranges=192.168.20.101-192.168.20.253
/ip dhcp-server
add address-pool=Server_IP interface=Vlan-100_Server lease-time=30m name=\
    DHCP_For_Vlan-100
add address-pool=Office_IP interface=Vlan-200_Office lease-time=30m name=\
    DHCP_For_Vlan-200
add address-pool=Guest2_IP interface=vlan1-Native name=DHCP_For_Vlan-1
/port
set 0 name=serial0
set 1 name=serial1
/routing id
add disabled=no id=10.0.0.2 name=id-1 select-dynamic-id=any,only-loopback
/routing ospf instance
add comment="OSPF AREA 0" name=ospf-instance-AREA-0 redistribute="" \
    router-id=id-1
/routing ospf area
add instance=ospf-instance-AREA-0 name=ospf-area-0
/interface vrrp
add comment="Vlan-100-MASTER(Pr.254)" group-master=VRRP-1-VLAN-100-SERVER \
    interface=Vlan-100_Server name=VRRP-1-VLAN-100-SERVER priority=254
add comment="Vlan-200-MASTER(Pr.254)" group-master=VRRP-2-VLAN-200-OFFICE \
    interface=Vlan-200_Office name=VRRP-2-VLAN-200-OFFICE priority=254 vrid=2
add comment="Vlan-300-BACKUP(Pr.100)" group-master=VRRP-3-VLAN-300-GUEST \
    interface=ether11 name=VRRP-3-VLAN-300-GUEST preemption-mode=no vrid=3
add comment="Vlan-400-BACKUP(Pr.100)" group-master=\
    VRRP-4-VLAN-400-Engineering interface=ether12 name=\
    VRRP-4-VLAN-400-Engineering preemption-mode=no vrid=4
/interface bridge port
add bridge=SWITCH-L3 comment="TRUNK-VLAN-100(Server)" interface=\
    LAG-to-SW-L2-Accs1
add bridge=SWITCH-L3 comment="TRUNK-VLAN-200(Office)" interface=\
    LAG-to-SW-L2-Accs2
add bridge=SWITCH-L3 comment=vlan1-Native-without-Tagging interface=ether4
/interface bridge vlan
add bridge=SWITCH-L3 comment="VLAN-100 Server" tagged=\
    LAG-to-SW-L2-Accs1,LAG-to-SW-L2-Accs2,SWITCH-L3 vlan-ids=100
add bridge=SWITCH-L3 comment="VLAN-200 Office" tagged=\
    LAG-to-SW-L2-Accs2,LAG-to-SW-L2-Accs1,SWITCH-L3 vlan-ids=200
add bridge=SWITCH-L3 comment=vlan1-Native-without-Tagging tagged=\
    ether4,SWITCH-L3 vlan-ids=1
/ip address
add address=10.0.1.2/30 comment=IP_LAG-R_Core interface=LAG-to-R_Core \
    network=10.0.1.0
add address=10.2.1.1/30 comment=IP_LAG-SW_Dist-2 interface=\
    LAG-to-SW_L3_Dist_2 network=10.2.1.0
add address=10.20.1.1/28 comment="IP_GW_Vlan-100 (Server)" interface=\
    Vlan-100_Server network=10.20.1.0
add address=192.168.10.1/24 comment="IP_GW_Vlan-200 (Office)" interface=\
    Vlan-200_Office network=192.168.10.0
add address=1.0.0.2 comment="LoopBack OSPF" interface=LoopBack network=\
    1.0.0.2
add address=192.168.100.1/24 comment="IP_GW_Vlan-1 (Guest 2 Native)" \
    interface=vlan1-Native network=192.168.100.0
add address=192.168.10.254/24 comment=Virtual-GW-Vlan-200 interface=\
    VRRP-2-VLAN-200-OFFICE network=192.168.10.0
add address=10.20.1.14/28 comment=Virtual-GW-Vlan-100 interface=\
    VRRP-1-VLAN-100-SERVER network=10.20.1.0
add address=192.168.20.254/24 comment="Virtual-GW(BCK)-Vlan-300" interface=\
    VRRP-3-VLAN-300-GUEST network=192.168.20.0
add address=192.168.20.2/24 comment=IP_Vlan-300-Guest interface=ether11 \
    network=192.168.20.0
add address=10.10.11.6/29 comment="Virtual-GW(BCK)-Vlan-400" interface=\
    VRRP-4-VLAN-400-Engineering network=10.10.11.0
add address=10.10.11.2/29 comment=IP-Vlan-400 interface=ether12 network=\
    10.10.11.0
/ip dhcp-relay
add delay-threshold=1m40s dhcp-server=10.2.1.2 disabled=no interface=\
    LAG-to-SW_L3_Dist_2 local-address=172.20.1.2 name=Management-DHCP
/ip dhcp-server
add address-pool=Guest_IP interface=VRRP-3-VLAN-300-GUEST name=\
    DHCP_For_Vlan-300
/ip dhcp-server network
add address=10.20.1.0/28 dns-server=1.1.1.1,8.8.8.8 gateway=10.20.1.14 \
    netmask=28
add address=192.168.10.0/24 dns-server=1.1.1.1,8.8.8.8 gateway=192.168.10.254 \
    netmask=24
add address=192.168.20.0/24 dns-server=1.1.1.1 gateway=192.168.20.254
add address=192.168.100.0/24 dns-server=1.1.1.1 gateway=192.168.100.1
/ip firewall address-list
add address=192.168.10.0/24 comment=Net-V200 list=VLANs-1,200
add address=192.168.100.0/24 comment=Net-V1 list=VLANs-1,200
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
add area=ospf-area-0 auth=md5 auth-key=labwkwk comment="PTP OSPF to R_CORE" \
    interfaces=LAG-to-R_Core networks=10.0.1.0/30 type=ptp
add area=ospf-area-0 auth=md5 auth-key=labwkwk comment=\
    "PTP OSPF to SW_DIST 2" interfaces=LAG-to-SW_L3_Dist_2 networks=\
    10.2.1.0/30 type=ptp
add area=ospf-area-0 comment="Passive interface VLAN-100" interfaces=\
    Vlan-100_Server networks=10.20.1.0/28 passive
add area=ospf-area-0 comment="Passive Interface VLAN-200" interfaces=\
    Vlan-200_Office networks=192.168.10.0/24 passive
add area=ospf-area-0 comment="Passive Interface VLAN-1" interfaces=\
    vlan1-Native networks=192.168.100.0/24 passive
/system identity
set name=Switch-L3_Dist
