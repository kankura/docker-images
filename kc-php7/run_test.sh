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
e php -v
e apachectl -v
e npm -v
e git version
e bower -v
e yarn -v
e python --version
e openssl version
e git version

echo
echo settings ==================================================================
e php -i
e apachectl -M
e apachectl configtest
e apachectl -S

echo

# apache modules test
echo apache modules test ===========================================================
MOD="rewrite alias log headers proxy php5 remoteip setenvif status"
for i in $MOD
do
    echo apachectl $i ========================================================
    e    "apachectl -M | grep $i"
    echo
done

echo

# php extention checks
## enabled check
echo php extentions test ===========================================================
EXT=" GD JPEG PNG GIF mysqli"
for i in $EXT
do
 echo php $i ========================================================
 e "php -i | grep '$i' | grep enabled"
 echo
done

echo
echo curl  ========================================================
e "php -i | grep -E '^curl'"


echo
echo
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo run_test ends
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo
echo
