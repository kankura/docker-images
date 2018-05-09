# https://github.com/RafPe/docker-haproxy-rsyslog/blob/master/Dockerfile

FROM haproxy:latest
MAINTAINER kuji

# Install rsyslog to logging haproxy
RUN apt-get update && apt-get install rsyslog -y && \
    sed -i 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf && \
    sed -i 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf

# debug
RUN    apt-get update \
    && apt-get install -y   vim       \
                            net-tools \
                            dnsutils  \
                            curl      \
                            wget      \
    && rm -rf /var/lib/apt/lists/*

# Logging
ADD rsyslog/haproxy.conf /etc/rsyslog.d

# Aliases
RUN echo -e "alias ll='ls -lha'" >> /root/.bashrc

COPY entrypoint.sh /
# chmod +x needs when build on docker hub
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

### CMD
# https://cbonte.github.io/haproxy-dconv/1.8/management.html
#  -dr : ignore server address resolution failures.
#  -d : enable debug mode.
#  -V : enable verbose mode
CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg", "-dr", "-V", "-d"]

# docker cloud autotest
COPY run_test.sh /