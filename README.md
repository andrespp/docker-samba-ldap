andrespp/samba-ldap
===================

# Introduction

Docker image for SAMBA with ldap authentication.

This image is based on `debian:bullseye`.

# Quick start

Refer to [samba-ldap](https://github.com/andrespp/samba-ldap) github repository for an example on how to use this image.

# Environment Variables

This image uses several environment variables in order to control its behavior,
and some of them may be required

`SAMBA_LDAP_PASSWORD` *Required

Password for the LDAP ADMIN DN set in `smb.conf` in order to bind the directory.

# Issues

If you have any problems with or questions about this image, please contact me
through a [GitHub issue](https://github.com/andrespp/docker-samba-ldap/issues).
