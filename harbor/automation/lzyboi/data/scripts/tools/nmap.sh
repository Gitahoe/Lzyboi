ports=$(sudo nmap -Pn -p- --min-rate 100 $1 -T5 | grep ^[0-9] | cut -d '/' -f1 | tr '\n' ',' | sed s/,$//)

sudo nmap -Pn -sC -sV --version-all -p$ports --min-rate 100 $1 -T5 --open | tee -a -i ports.txt