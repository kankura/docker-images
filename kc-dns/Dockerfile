FROM alpine

MAINTAINER kuji

# install basic tools
RUN apk update && \
    apk --update --no-cache add bash tzdata \
                     git  \
                     dnsmasq \
                     curl logrotate  \
                     ca-certificates supervisor rsyslog \
                     bind-tools

# Place entrypoint with docker run volume
ENTRYPOINT ["sh", "/entrypoint.sh"]