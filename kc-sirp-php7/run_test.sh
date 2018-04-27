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
e grunt -V
e gulp -v
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
MOD="rewrite alias log headers proxy php remoteip setenvif status"
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
 e "php -i | grep -i $i | grep -i enabled"
 echo
done

echo
echo curl  ========================================================
e "php -i | grep -i 'curl support' | grep -i enabled"

echo
echo php pear ==============================================================
EXT=" PEAR XML_Util Image_Color Image_Graph Image_Color2 Mail_Mime Log Auth"
for i in $EXT
do
 echo "pear $i ========================================================"
 pear list | grep $i
 echo
done

#########################
echo get web by curl test....

# set a content
echo set index.html...
e "date > /var/www/html/index.html"

echo start apache...
e "apachectl start"

echo testing curl...
BR=$'\n'
CMDs="curl -L http://127.0.0.1/       $BR\
"
IFS=$BR # 改行でloopさせる
for CMD in $CMDs
do
    e $CMD
done;

echo
echo
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo run_test ends
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo
echo $0 on `hostname` SUCCESS!
echo
