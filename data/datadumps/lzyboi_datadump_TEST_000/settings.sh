#!/bin/bash
T_IP="192.0.0.1"
T_PORT="1337"
T_URL="http://google.com/1.jpg/download"
T_USER="test"
T_PWD="kali"
T_WLIST=
if [[ -n "$T_IP" && -n "$T_PORT" ]]; then T_HOST="$T_IP:$T_PORT"
elif [[ -n "$T_IP" && -z "$T_PORT" ]]; then T_HOST="$T_IP:N/A"
else T_HOST="No host has been set"; fi
if [[ -n "$T_USER" && -n "$T_PWD" ]]; then T_CREDS="$T_USER:$T_PWD"
elif [[ -n "$T_USER" && -z "$T_PWD" ]]; then T_CREDS="$T_USER:N/A"
else T_CREDS="No credentials have been set"; fi
T_DIR=
LOCAL_IP=
