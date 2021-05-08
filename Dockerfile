FROM debian:bullseye

RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive  \
    apt-get install -y --no-install-recommends \
		 ldap-utils libnss-ldap samba smbldap-tools smbclient vim && \
    rm -rf /var/lib/apt/lists/*

# /etc/nsswitch.conf
RUN file="/etc/nsswitch.conf" && \
	echo 'passwd:         files ldap' > $file && \
	echo 'group:          files ldap' >> $file && \
	echo 'shadow:         files ldap' >> $file && \
	echo 'gshadow:        files' >> $file && \
	echo '' >> $file && \
	echo 'hosts:          files dns' >> $file && \
	echo 'networks:       files' >> $file && \
	echo '' >> $file && \
	echo 'protocols:      db files' >> $file && \
	echo 'services:       db files' >> $file && \
	echo 'ethers:         db files' >> $file && \
	echo 'rpc:            db files' >> $file && \
	echo '' >> $file && \
		echo 'netgroup:       nis' >> $file

COPY entrypoint.sh /usr/bin/

EXPOSE 137/udp 138/udp 139 445

ENTRYPOINT ["entrypoint.sh"]
