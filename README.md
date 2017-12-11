andrespp/samba-ldap
===================

# Introduction

Docker image for SAMBA with ldap authentication.

This image is based on `FROM andrespp/debian-ldap`.

# Quick start

The easiest way to try this image is via docker compose:

```
version: '3.1'

services:
  debian:
    image: andrespp/samba-ldap
    environment:
     - SAMBA_LDAP_PASSWORD=your-pass
    ports:
     - "445:445"
    volumes:
     - ./sandbox/libnss-ldap.conf:/etc/libnss-ldap.conf:ro
     - ./sandbox/smb.conf:/etc/samba/smb.conf:ro
     - ./sandbox/Documentos:/mnt/Documentos
```

Where `./libnss-ldap.conf`:

```
base dc=base
uri ldap://192.168.1.1/
ldap_version 3
binddn uid=linux,ou=system,dc=base
bindpw secret-password
```

And `./smb.conf`:

```
[global]
workgroup = MyWorkgroup
server string = My fileserver
netbios name = myhostname
dns proxy = no
wide links = no
log level = 4
map untrusted to domain = no
client lanman auth = Yes
security = user
encrypt passwords = true
# password database backend ======================================
	passdb backend = ldapsam:ldap://192.168.1.1
	ldap passwd sync     = yes
	ldap admin dn        =   cn=admin,dc=base
	ldap suffix          =   dc=base
	ldap user suffix     =   ou=users
	ldap machine suffix  =   ou=computers
	ldap group suffix    =   ou=groups
	ldap idmap suffix    =   ou=idmap
	ldap delete dn       =   yes
	ldap ssl             =   off
#=================================================================
obey pam restrictions = yes
invalid users = root
unix password sync = yes
passwd program = /usr/bin/passwd %u
passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
pam password change = yes
map to guest = bad user

socket options = TCP_NODELAY
usershare allow guests = yes

#======================= Share Definitions =======================

[Documentos]
   comment = Shared Documents
   path = /mnt/Documentos
   browseable = yes
   guest ok = no
   read only = no
   create mask = 0770
   directory mask = 0770
   map acl inherit = Yes
   inherit permissions = yes
```

And `./sandbox/Documentos` is the path you want to share

```bash
$ docker-compose up
```

Alternativelly, you can use `docker container run`:

```bash
$ docker container run --rm -d -p 445:445 --name samba \
	-v $(pwd)/sandbox/libnss-ldap.conf:/etc/libnss-ldap.conf:ro \
	-v $(pwd)/sandbox/smb.conf:/etc/samba/smb.conf:ro \
        -v $(pwd)/sandbox/Documentos:/mnt/Documentos \
	-e SAMBA_LDAP_PASSWORD=your-pass andrespp/samba-ldap
```


# Environment Variables

This image uses several environment variables in order to controls its behavior,
and some of them may be required

`SAMBA_LDAP_PASSWORD` *Required

Password for the LDAP ADMIN DN set in `smb.conf` in order to bind the directory.

# Issues

If you have any problems with or questions about this image, please contact me
through a [GitHub issue](https://github.com/andrespp/docker-samba-ldap/issues).
