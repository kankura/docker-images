FROM centos:7
LABEL maintainer ito

ARG http_proxy
ARG HTTP_PROXY
ARG https_proxy
ARG HTTPS_PROXY

# 各種インストール
## cronを入れる。cron loggingのためにrsyslogも入れる。
## これにより /var/log/syslog にcron logが入ります。
## gnupgはnodejsのinstallに必要
RUN yum update -y
RUN yum install -y                        \
                   git                    \
                   cron                   \
                   rsyslog                \
                   iputils-ping           \
                   iproute                \
                   wget                   \
                   telnet                 \
                   tree                   \
                   vim                    \
                   curl                   \
                   net-tools              \
                   dnsutils               \
                   bzip2                  \
                   lsyncd                 \
                   cpio                   \
                   supervisor             \
                   fonts-ipaexfont-gothic \
                   gnupg                  \
                   traceroute

# npm
# Create alias "node" of "nodejs" because currently nodejs is installed, but legacy modules access to "node".
# https://nodejs.org/en/download/package-manager/
# npm will be installed by nodejs
RUN curl -sL https://rpm.nodesource.com/setup_8.x | bash - && \
    yum install -y nodejs                                && \
    npm i -g bower grunt-cli yarn gulp

# Install Apache modules
# RUN a2enmod rewrite \
#             proxy proxy_http proxy_ajp \
#             remoteip headers
# Disable unnessary extensions
# RUN a2dismod dav dav_fs cgi ssl

# Supervisor
RUN mkdir -p /var/log/supervisor

# mysql and other extensions
# IMPORTANT: MUST use "dockerphp-ext-install"
# https://hub.docker.com/_/php/
RUN rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
RUN yum -y install mysql-community-client

# php libraries
# https://docs.docker.com/samples/library/php/#how-to-install-more-php-extensions
RUN yum install -y freetype-devel
RUN yum install -y libjpeg-devel
RUN yum install -y libtomcrypt-devel
RUN yum install -y libpng-devel
RUN yum install -y ImageMagick-devel
RUN yum install -y lynx
RUN yum install -y bzip2-devel
RUN yum install -y zlib-devel
RUN yum install -y libcurl-devel
RUN yum install -y openssl-devel
RUN yum install -y openssh-clients

RUN yum install -y php-iconv
RUN yum install -y php-gd

# 必要な時だけEPELリポジトリを使用できるようにする
RUN yum install -y epel-release
RUN sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/epel.repo
RUN yum --enablerepo=epel -y update epel-release

RUN yum install -y --enablerepo=epel php-mcrypt

# https://hub.docker.com/r/nazarpc/php/~/dockerfile/
RUN yum install -y php-pdo
RUN yum install -y php-pdo_mysql
RUN yum install -y php-bcmath
RUN yum install -y php-bz2
RUN yum install -y php-curl
RUN yum install -y php-exif
RUN yum install -y php-ftp
RUN yum install -y php-gettext
RUN yum install -y php-mbstring
RUN yum install -y php-shmop
RUN yum install -y php-sockets
RUN yum install -y php-sysvmsg
RUN yum install -y php-sysvsem
RUN yum install -y php-sysvshm
RUN yum install -y php-zip
RUN yum install -y php-mysqli
RUN yum install -y --enablerepo=epel php-opcache

# ruby
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN ~/.rbenv/plugins/ruby-build/install.sh
RUN yum install -y readline-devel
ENV PATH=/root/.rbenv/bin:$PATH
RUN yum install -y gcc
RUN yum install -y make
RUN rbenv install 2.4.1
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
RUN rbenv global 2.4.1

ENV PATH=/root/.rbenv/shims:$PATH
RUN gem install bundler
RUN bundle config --global path /usr/local/bundle
RUN bundle config --global bin /usr/local/bundle/bin
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
RUN yum install -y --enablerepo=epel ssmtp
#COPY ./conf/ssmtp.conf /etc/ssmtp/ssmtp.conf

# composer
RUN curl -sS https://getcomposer.org/installer | php   && \
    mv composer.phar /usr/local/bin/composer           && \
    composer self-update

## logrotate
COPY logrotate.d/apache2 /etc/logrotate.d/apache2

## python3環境
RUN yum install -y --enablerepo=epel python36 python36-libs python36-devel python36-pip
RUN pip3 install pipenv
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV PYTHONIOENCODING=utf-8

# phantomjs
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    tar -jxf phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    cp -p phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/bin

RUN yum install -y php-devel httpd-devel

WORKDIR /var/www

# docker hub autotest
COPY run_test.sh /

RUN yum install -y openssl

RUN adduser www-data

RUN yum install -y php
