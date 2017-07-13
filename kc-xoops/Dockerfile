FROM php:5-apache
MAINTAINER kujiy

# アップデート
RUN apt-get update -y

# 各種インストール
RUN apt-get install -y     \
                   iputils-ping \
                   iproute      \
                   wget         \
                   telnet       \
                   tree         \
                   vim          \
                   curl         \
                   net-tools    \
                   dnsutils     \
                   bzip2        \
    && apt-get clean all

# Install Latest Git
RUN echo "deb http://ftp.us.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list \
         &&      apt-get update              \
         &&      apt-get install -y git      \
         &&      apt-get clean all

# Supervisor
RUN apt-get install -y openssh-server supervisor
RUN mkdir -p  /var/run/sshd /var/log/supervisor
RUN mkdir -p /var/log/supervisor

# cronを入れる。cron loggingのためにrsyslogも入れる。
# これにより /var/log/syslog にcron logが入ります。
Run apt-get install -y cron \
                       rsyslog \
                       #squid3 \
                       imagemagick && \
    apt-get clean all

# CI
RUN apt-get update \
     && apt-get install -y nodejs npm fonts-ipaexfont-gothic       && \
 npm i -g bower grunt-cli && \
 apt-get clean all

# mysql and other extensions
# IMPORTANT: MUST use "dockerphp-ext-install"
# https://hub.docker.com/_/php/
RUN apt-get update &&  \
   /usr/local/bin/docker-php-ext-install mysql mysqli pdo_mysql mbstring mysql mysqli pdo pdo_mysql
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server mysql-client php5-mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-client php5-mysql && \
    apt-get clean all

# Install Apache RewirteEngine
RUN a2enmod rewrite
# Disable unnessary extensions
RUN a2dismod dav dav_fs cgi ssl

# php5-gdは必須！
# GDをインストールするの超大変！！
# apt-get と docker-php-なんたらの連続技で動きます
# どこかの拾い物とここ https://hub.docker.com/r/tommylau/php/~/dockerfile/ のハイブリッド
# gd JPEG enabled と exif_imagetype() がおかしい場合は↑を完全採用したほうがいいかも
RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive && \
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confdef" install \
        libapache2-mod-php5 \
        php5-gd    \
        php-pear   \
        php-apc    \
        php5-curl  \
        lynx-cur \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libjpeg-dev \
        libbz2-dev \
  && apt-get autoremove -y \
  && apt-get clean all

# php libraries
# https://hub.docker.com/r/nazarpc/php/~/dockerfile/
 RUN docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --enable-gd-native-ttf --with-jpeg-dir=/usr/lib/x86_64-linux-gnu --with-png-dir=/usr/lib/x86_64-linux-gnu --with-freetype-dir=/usr/lib/x86_64-linux-gnu \
    && docker-php-ext-install -j$(nproc) gd   \
    && docker-php-ext-install \
		bcmath \
		bz2 \
		exif \
		ftp \
		gettext \
		mbstring \
		mcrypt \
		mysqli \
		opcache \
		pdo_mysql \
		shmop \
		sockets \
		sysvmsg \
		sysvsem \
		sysvshm \
		zip

# install php-zip
RUN  apt-get -y install zlib1g-dev \
  && docker-php-ext-install zip  \
        && apt-get clean all

# ruby
# https://github.com/docker-library/ruby/blob/1b08f346713a1293c2a9238e470e086126e2e28f/2.3/Dockerfile
RUN \
    apt-get install -y ruby ruby-dev &&   rm -rf /var/lib/apt/lists/*      && \
    gem install bundler  && \
    bundle config --global path /usr/local/bundle && \
    bundle config --global bin /usr/local/bundle/bin && \
    apt-get clean all

RUN gem install sass

RUN echo " \n\
set encoding=utf-8 \n\
set nu             \n\
set history=9999   \n\
syntax on          \n\
" > /root/.vimrc


# Aliases
RUN echo " \n\
alias ls=\"ls --color=auto\"                      \n\
alias ll=\"ls -lha --full-time --color=auto\"     \n\
" >> /root/~.bashrc

ENV LESSCHARSET=utf-8

# Enable sendmail with ssmtp
RUN    apt-get update             \
   &&  apt-get install -y ssmtp \
   &&  apt-get clean all
#COPY ./conf/ssmtp.conf /etc/ssmtp/ssmtp.conf

# Lsyncd
RUN apt-get install -y lsyncd

# source backupで使うcpio
RUN apt-get install -y cpio

# composer
RUN \
    cd /usr/local/bin && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar composer

## tomcat proxy
RUN a2enmod proxy proxy_http proxy_ajp
## Rewrite log; Load Balancer IP to Client IP logging for apache2
RUN a2enmod remoteip
## Enable to insert headers
RUN a2enmod headers
