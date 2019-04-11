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
e traceroute -V
e python3 -V
e pip -V
e export LC_ALL=en_US.UTF-8
e export LANG=en_US.UTF-8
e pipenv --version

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
    e    "apachectl -M 2>&1 | grep -v 'fully qualified domain name' | grep $i"
    echo
done

echo

# php extention checks
## enabled check
echo php extentions test ===========================================================
EXT=" GD JPEG PNG GIF"
for i in $EXT
do
 echo php $i ========================================================
 e "php -i | grep '$i' | grep enabled"
 echo
done

echo
echo mysql ========================================================
# mysqlnd
e "php -i | grep -v mysqli | grep mysql | grep enabled"
# mysql
e "php -i | grep kc_php.ini "
e "php -i | grep mysql.default_host "
# mysqli
#e "php -i | grep docker-php-ext-mysqli.ini "
#e "php -i | grep mysqli.default_host "
# pdo_mysql
#e "php -i | grep docker-php-ext-pdo_mysql.ini"
#e "php -i | grep pdo_mysql.default_socket"

echo
echo curl  ========================================================
e "php -i | grep -E '^curl'"


#########################
echo get web by curl test....

# set a content
echo set index.html...
e "date > /var/www/html/index.html"

echo start apache...
e "httpd -k start"

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
