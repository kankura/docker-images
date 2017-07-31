FROM alpine

MAINTAINER kuji

# install basic tools
RUN apk update && \
    apk --update add bash tzdata \
                     git  \
                     dnsmasq \
                     curl logrotate  \
                     ca-certificates supervisor rsyslog supervisor \
    rm -rf /var/cache/apk/*

# Place entrypoint with docker run volume
ENTRYPOINT ["sh", "/entrypoint.sh"]