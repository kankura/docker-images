FROM centos

MAINTAINER kujiy

# install basic tools
RUN \
  yum update -y && \
  yum install -y     epel-release             \
                     squid                    \
                     ca-certificates rsyslog  \
                     vixie-cron crontabs       \
                     iproute python-setuptools hostname inotify-tools yum-utils which && \
  yum clean all && \
  easy_install supervisor

# run with volume entrypoint.sh
ENTRYPOINT ["sh", "/entrypoint.sh"]