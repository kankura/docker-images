#!/bin/bash

# Stop when any command fails
set -e

function e() {
    echo $@
    eval "$@"
    echo
}

# for loop with spaces
IFS=' '

echo
echo
echo
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo run_test begins
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo
echo

echo versions ==================================================================
e haproxy -v
e " nslookup example.com | grep -v 127.0.0. | grep Address: "
e "curl --version"
e "wget --version"
e "ping -V"
e "dpkg -l | grep telnet"
e " vim --version | grep IMproved"

echo services ==================================================================
e service --status-all

echo logging  ==================================================================
# まずhaproxyを起動させる
# テストconfig用意
echo exporting haproxy.cfg...
cat >/usr/local/etc/haproxy/haproxy.cfg <<EOL
global
    log         127.0.0.1 local2 debug
    daemon
defaults
    mode        http
    log         global
    option      dontlognull
    timeout connect 1000 # default 10 second time out if a backend is not found
    timeout client 1000
    timeout server 1000
    retries     3
listen proxy-test
       bind *:80
       server server1.yourserver.com 10.0.1.11:80 
EOL

# syntax
e haproxy -f /usr/local/etc/haproxy/haproxy.cfg -c
# background起動
e haproxy -f /usr/local/etc/haproxy/haproxy.cfg -dr -V -d -D

e sleep 3

# haproxy起動したかport check
e "ps aux"
e "ps aux | grep 'haproxy -f'"
e "netstat -na"
e "netstat -na | grep :80"

echo haproxy has been started.

# logを出したいだけ。backendないため503が返るが、trueで必ず成功させる
e "curl 127.0.0.1 && true"
# logが出てれば成功するgrep
e grep 127.0.0.1 /var/log/haproxy.log 
# log sizeが0byte以上チェック
[[ -s /var/log/haproxy.log ]] && true || false
echo
e cat /var/log/haproxy.log 

echo "logging works."

echo
echo
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo run_test ends
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo
echo $0 on `hostname` SUCCESS!
echo
