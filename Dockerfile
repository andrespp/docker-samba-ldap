FROM andrespp/debian-ldap
MAINTAINER andrespp@gmail.com

# Install NSS
RUN apt-get update && \
  apt-get install -y samba

COPY entrypoint.sh /usr/bin/

EXPOSE 137/udp 138/udp 139 445

ENTRYPOINT ["entrypoint.sh"]
