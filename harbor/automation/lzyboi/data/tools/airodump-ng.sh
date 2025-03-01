snippets=("# INIT"
  "# 40 : Standard T4 (add -n to skip domain name)"
  "# 41 : Thorough T5 (-sT -> -sU for UDP)"
  "# 42 : Quick T5 (URGENCE)"
  "# 43 : Quick T5 Plus (URGENCE)"
  "# 44 : Standard casual"
  
  "# STEALTH"
  "# 50 - 53 : Unexpected packets (!Windows except for SYN)"
  "# 54 : Stealth comprehensive T2"

  "# DISCOVERY"
  "# 60 : Quick traceroute"
  "# 61 : Subnet ping"
  "# 62 : Comprehensive T4"

  "# PARANOÏA"
  "# 70 : Port \"de-spoofer\""
  

  "# Fragmented ACK-less"

  
  
  
  


  
  
  
  
  
  





  "nmap -T4 -v -A $T_IP"
  "nmap -n -v -p- -T5 $T_IP"
  "nmap -T5 -F $T_IP"
  "nmap -sV -T5 -O -F --version-light $T_IP"
  "nmap -sC -sV -oA $T_IP $T_DIR"





  "nmap -sS $T_IP (SYN)"
  "nmap -sF $T_IP (FIN)"
  "nmap -sN $T_IP (NULL)"
  "nmap -sX $T_IP (Xmas (FIN, URG, PSH))"
  "nmap -sX -T2 -D RND:10 --mtu 32 $T_IP"




  
  "nmap -sn --traceroute $T_IP"
  "nmap -sn $T_IP"
  "nmap -sS -sU -T4 -A -v -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53 --script default $T_IP"







  "nmap -p1-65535 -A -T5 $T_IP"
)