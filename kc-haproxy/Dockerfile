# https://github.com/RafPe/docker-haproxy-rsyslog/blob/master/Dockerfile

FROM haproxy:latest
MAINTAINER kuji

# Install rsyslog to logging haproxy
RUN apt-get update && apt-get install rsyslog -y && \
    sed -i 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf && \
    sed -i 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf

# debug
RUN apt-get update && apt-get install vim -y && rm -rf /var/lib/apt/lists/*

# Logging
ADD rsyslog/haproxy.conf /etc/rsyslog.d


COPY entrypoint.sh /

#ENTRYPOINT ["/entrypoint.sh"]

