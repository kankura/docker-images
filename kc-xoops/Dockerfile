FROM php:5-apache
MAINTAINER kujiy

ENV DEBIAN_FRONTEND=noninteractive

# update & upgrade
RUN apt-get update -y            \
 && apt-get install apt-utils -y \
 && apt-get autoremove -y        \
 && apt-get clean all
RUN apt-get upgrade -y           \
 && apt-get autoremove -y        \
 && apt-get clean all

# 各種インストール
## cronを入れる。cron loggingのためにrsyslogも入れる。
## これにより /var/log/syslog にcron logが入ります。
## gnupgはnodejsのinstallに必要
RUN apt-get update                        \
    && apt-get install -y                 \
                   apt-utils              \
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
    && apt-get clean all

# npm
# Create alias "node" of "nodejs" because currently nodejs is installed, but legacy modules access to "node".
# https://nodejs.org/en/download/package-manager/
# npm will be installed by nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get update                                       && \
    apt-get install -y nodejs                            && \
    npm i -g bower grunt-cli yarn gulp                   && \
    apt-get autoremove -y                                && \
    apt-get clean all

# Install Apache modules
RUN a2enmod rewrite \
            proxy proxy_http proxy_ajp \
            remoteip headers
# Disable unnessary extensions
RUN a2dismod dav dav_fs cgi ssl

# Supervisor
RUN mkdir -p /var/log/supervisor

# mysql and other extensions
# IMPORTANT: MUST use "dockerphp-ext-install"
# https://hub.docker.com/_/php/
RUN DEBIAN_FRONTEND=noninteractive    && \
    apt-get update                    &&  \
    apt-get install -y mysql-client && \
    apt-get clean all

# php libraries
# https://docs.docker.com/samples/library/php/#how-to-install-more-php-extensions
RUN apt-get update && apt-get install -y \
		libfreetype6-dev         \
		libjpeg62-turbo-dev      \
		libmcrypt-dev            \
		libpng-dev               \
	        imagemagick              \
                lynx-cur                 \
                libfreetype6-dev         \
                libbz2-dev               \
                zlib1g-dev               \
                libcurl4-gnutls-dev      \
                libssl-dev               \
        && docker-php-ext-install -j$(nproc) iconv mcrypt \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd

# https://hub.docker.com/r/nazarpc/php/~/dockerfile/
RUN docker-php-ext-install   \
        pdo pdo_mysql        \
		    bcmath               \
		    bz2                  \
        curl                 \
		    exif                 \
		    ftp                  \
		    gettext              \
		    mbstring             \
		    opcache              \
		    shmop                \
		    sockets              \
		    sysvmsg              \
		    sysvsem              \
		    sysvshm              \
		    zip                  \
        mysqli               \
    && docker-php-ext-enable mysqli

# ruby
# https://github.com/docker-library/ruby/blob/1b08f346713a1293c2a9238e470e086126e2e28f/2.3/Dockerfile
RUN \
    apt-get install -y ruby ruby-dev &&   rm -rf /var/lib/apt/lists/*      && \
    gem install bundler  && \
    bundle config --global path /usr/local/bundle && \
    bundle config --global bin /usr/local/bundle/bin && \
    apt-get clean all \
 && gem install sass

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

# composer
RUN curl -sS https://getcomposer.org/installer | php   && \
    mv composer.phar /usr/local/bin/composer           && \
    composer self-update

## logrotate
COPY logrotate.d/apache2 /etc/logrotate.d/apache2

## python3環境
RUN set -x          \
  && apt-get update \
  && : "libmysqlclient-dev と \n" \
  && apt-get install -y libmysqlclient-dev  \
  && : "python3は分けてapt-getしないとコケる \n" \
  && apt-get install -y python3 python3-dev python-pip     \
  && apt-get autoremove -y                                                    \
  && apt-get clean all                                                        \
  && : "\n\n\n +++++++++++++++\n pipのインストールを始めます ++++++++++++++\n\n\n"      \
  && pip install --upgrade  pip setuptools                                    \
  && : "\n\n\n +++++++++++++++\n pipenvのインストールを始めます ++++++++++++++\n\n\n"      \
  && pip install pipenv                                                       \
  && : "\n\n\n +++++++++++++++\n pipenvでmysql moduleのインストールを始めます ++++++++++++++\n\n\n"      \
  && export LC_ALL=C.UTF-8                                                    \
  && export LANG=C.UTF-8                                                      \
  && pipenv install mysql-connector-python --three
ENV PYTHONIOENCODING=utf-8

WORKDIR /var/www

# docker hub autotest
COPY run_test.sh /
