FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y curl dnsmasq psmisc supervisor

ENV CT_URL https://github.com/hashicorp/consul-template/releases/download/v0.7.0/consul-template_0.7.0_linux_amd64.tar.gz
RUN curl -L $CT_URL | tar -C /usr/local/bin --strip-components 1 -zxf -

COPY config/dnsmasq.conf /etc/dnsmasq.conf
COPY dnsmasq.ctmpl /etc/consul-templates/dnsmasq.ctmpl

RUN mkdir -p /var/log/supervisor
ADD config/supervisord.conf /etc/supervisor/conf.d/docker-gen.conf

EXPOSE 53/udp

ENTRYPOINT  ["/usr/bin/supervisord"]

CMD ["-n"]