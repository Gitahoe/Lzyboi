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
42 : Quick T5 (unreliable)
43 : Quick T5 Plus (unreliable)
44 : Standard thorough
45 : Standard mid-thorough (unreliable)

STEALTH
50 - 53 : Unexpected packets (!Windows except for SYN)
54 : Stealth comprehensive T2

DISCOVERY
60 : Quick traceroute
61 : Subnet ping
62 : Comprehensive T4

PARANOÏA
70 : Port "de-spoofer"


Fragmented ACK-less















$CMD -T4 -v -A $T_IP
$CMD -n -v -p- -T5 $T_IP
$CMD -T5 -F $T_IP
$CMD -sV -T5 -O -F --version-light $T_IP
$CMD -A $T_IP ${SUFFIXES[$MODE]}${PIPES[$MODE]}
$CMD -sC -sV $T_IP ${SUFFIXES[$MODE]}${PIPES[$MODE]}




$CMD -sS $T_IP ${SUFFIXES[$MODE]} ${PIPES[$MODE]}
$CMD -sF $T_IP ${SUFFIXES[$MODE]} ${PIPES[$MODE]}
$CMD -sN $T_IP ${SUFFIXES[$MODE]} ${PIPES[$MODE]}
$CMD -sX $T_IP ${SUFFIXES[$MODE]} ${PIPES[$MODE]}
$CMD -sX -T2 -D RND:10 --mtu 32 $T_IP ${SUFFIXES[$MODE]} ${PIPES[$MODE]}





$CMD -sn --traceroute $T_IP ${SUFFIXES[$MODE]} ${PIPES[$MODE]}
$CMD -sn $T_IP ${SUFFIXES[$MODE]} ${PIPES[$MODE]}
$CMD -sS -sU -T4 -A -v -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53 --script default $T_IP ${SUFFIXES[$MODE]} ${PIPES[$MODE]}







$CMD -p1-65535 -A -T5 $T_IP ${SUFFIXES[$MODE]} ${PIPES[$MODE]}
EOF
)
