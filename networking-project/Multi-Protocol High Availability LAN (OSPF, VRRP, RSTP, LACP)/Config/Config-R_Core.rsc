# aug/23/2026 17:59:35 by RouterOS 7.1
# software id = 
#
/interface bridge
add name=LoopBack
/interface ethernet
set [ find default-name=ether1 ] comment=UPLINK
set [ find default-name=ether2 ] comment=Bonding-to-eth1-SW_Dist
set [ find default-name=ether3 ] comment=Bonding-to-eth1-SW_Dist_02
set [ find default-name=ether4 ] comment=Bonding-to-eth2-SW_Dist
set [ find default-name=ether5 ] comment=Bonding-to-eth2-SW_Dist_02
/interface bonding
add comment=LAG-to-SW-L3-Dist down-delay=100ms lacp-rate=1sec mii-interval=\
    80ms mode=802.3ad name=LAG-to-SW_L3_Dist slaves=ether2,ether4 \
    transmit-hash-policy=layer-3-and-4 up-delay=100ms
add comment=LAG-to-SW-L3-Dist_2 down-delay=100ms lacp-rate=1sec mii-interval=\
    80ms mode=802.3ad name=LAG-to-SW_L3_Dist_2 slaves=ether3,ether5 \
    transmit-hash-policy=layer-3-and-4 up-delay=100ms
/interface list
add name=Bonding-Interface-list
add name=WAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/port
set 0 name=serial0
set 1 name=serial1
/routing id
add disabled=no id=1.0.0.1 name=id-1 select-dynamic-id=any,only-loopback
/routing ospf instance
add comment=INSTANCE-AREA-0 name=ospf-instance-1 originate-default=always \
    router-id=id-1
/routing ospf area
add instance=ospf-instance-1 name=ospf-area-0
/interface list member
add comment=Bonding-Interface-list interface=LAG-to-SW_L3_Dist list=\
    Bonding-Interface-list
add comment=Bonding-Interface-list interface=LAG-to-SW_L3_Dist_2 list=\
    Bonding-Interface-list
add comment=UPLINK interface=ether1 list=WAN
add comment=UPLINK interface=ether8 list=Bonding-Interface-list
/ip address
add address=10.0.1.1/30 comment=To-Switch-L3-DIST interface=LAG-to-SW_L3_Dist \
    network=10.0.1.0
add address=10.1.0.1/30 comment=To-Switch-L3-Dist_2 interface=\
    LAG-to-SW_L3_Dist_2 network=10.1.0.0
add address=1.0.0.1 comment="LOOPBACK OSPF" interface=LoopBack network=\
    1.0.0.1
add address=10.10.10.2/30 comment="UP-Link-ISP(MiAu-MiAu)" interface=ether8 \
    network=10.10.10.0
/ip dhcp-client
add add-default-route=no comment="UP-Link-ISP(Neko-Neko)" interface=ether1
/ip firewall filter
add action=accept chain=input comment="Default Accept Input" \
    connection-state=established,related
add action=accept chain=forward comment="Default Accept Forward" \
    connection-state=established,related
add action=accept chain=input comment=\
    "Allow Access to R_Core From Enginering Network" connection-state=\
    established,related,new dst-port=9395,2933 in-interface-list=\
    Bonding-Interface-list protocol=tcp src-address=10.10.11.0/29
add action=accept chain=input comment="Allowing Ping to Router From Intranet" \
    connection-state=established,related,new in-interface-list=\
    Bonding-Interface-list log=yes protocol=icmp
add action=accept chain=input comment=OSPF protocol=ospf
add action=drop chain=input comment="Default Drop Input" connection-state=\
    invalid,new
add action=drop chain=forward comment="Default Drop Forward" \
    connection-state=invalid
/ip firewall nat
add action=masquerade chain=srcnat comment="Masking Local IP" \
    out-interface-list=WAN
/ip route
add comment="Recursive(Primary)-GW-(ISP-MiAu-MiAu)" disabled=no distance=1 \
    dst-address=0.0.0.0/0 gateway=8.8.8.8 pref-src="" routing-table=main \
    scope=10 suppress-hw-offload=no target-scope=30
add check-gateway=ping comment="Recurive(Primary)-GW-(ISP-MiAu-MiAu)" \
    disabled=no distance=1 dst-address=8.8.8.8/32 gateway=10.10.10.1 \
    pref-src="" routing-table=main scope=10 suppress-hw-offload=no \
    target-scope=10
add check-gateway=ping comment="Recursive(Backup)-GW-(ISP-Neko-Neko)" \
    disabled=no distance=2 dst-address=0.0.0.0/0 gateway=9.9.9.9 \
    routing-table=main scope=10 suppress-hw-offload=no target-scope=30
add check-gateway=ping comment="Recurive(Backup)-GW-(ISP-Neko-Neko)" \
    disabled=no distance=2 dst-address=9.9.9.9/32 gateway=192.168.233.2 \
    pref-src="" routing-table=main scope=10 suppress-hw-offload=no \
    target-scope=10
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set ssh port=9395
set api disabled=yes
set winbox port=2933
set api-ssl disabled=yes
/routing ospf interface-template
add area=ospf-area-0 auth=md5 auth-key=labwkwk comment="PTP OSPF to SW DIST1" \
    interfaces=LAG-to-SW_L3_Dist networks=10.0.1.0/30 type=ptp
add area=ospf-area-0 auth=md5 auth-key=labwkwk comment=\
    "PTP OSPF to SW DIST 2" interfaces=LAG-to-SW_L3_Dist_2 networks=\
    10.1.0.0/30 type=ptp
/system identity
set name=Mikrotik-R_Core
