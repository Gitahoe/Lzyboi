#!/bin/bash
# generate $STDOUT_PATH
CMD="nmap"
ADD=(" -oX"
  " -oA"
  " -oX"
)
SUFFFIXES=("nmap.xml $DP "
  ""
  "- localhost "
)
PIPES=("| xmlstarlet sel -t -v '//port[state/@state=\"open\"]/@portid' -nl $DP/nmap.xml | paste -s -d, -"
  ""
  "| xmlstarlet sel -t -v '//port[state/@state=\"open\"]/@portid' -nl | paste -s -d, -"
)
TEMPLATE=$(cat <<EOF
Nmap - Network scanner (Active Reconnaissance)

STANDARD
40 : Standard T4 thorough (add -n to skip domain name)
41 : Thorough T5 (-sT -> -sU for UDP)
42 : Fast Pn
43 : Fast plus
44 : Standard thorough
45 : Standard mid-thorough (unreliable)

STEALTH
50 : Stealthy fast scan
51 - 53 : Unexpected packets (Not Windows compatible)
54 : Stealth comprehensive T2

DISCOVERY
60 : Quick traceroute
61 : Subnet ping
62
63 : Comprehensive on block
64 : Very comprehensive

PARANOÏA
70 : Port "de-spoofer"


Fragmented ACK-less












$CMD -T4 -v -A $T_IP
$CMD -n -v -p- -T5 $T_IP
$CMD -Pn -F $T_IP
$CMD -T4 -sV -O -F --version-light $T_IP
$CMD -sS -A -p- $T_IP
$CMD -sC -sV $T_IP




$CMD -Pn -sS -F $T_IP
$CMD -sF $T_IP
$CMD -sN $T_IP
$CMD -sX $T_IP
$CMD -sX -T2 -D RND:10 --mtu 32 $T_IP





$CMD -sn --traceroute $T_IP
$CMD -sn $T_IP
$CMD -sn -PS$T_PORT $T_IP
$CMD -sn -PS21,22,25,80,445,3389,8080 -PU137,138 -T4 $T_IP$T_SN
$CMD -sS -sU -T4 -A -v -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53 --script default $T_IP





$CMD -p1-65535 -A -T5 $T_IP
EOF
)
