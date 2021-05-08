#!/usr/bin/env bash
SECRET="/var/lib/samba/private/secrets.tdb"

if [[ -z "${SAMBA_LDAP_PASSWORD}" ]]; then
    echo "ERROR: Environment variable SAMBA_LDAP_PASSWORD not set"
    exit 17
else
    smbpasswd -w $SAMBA_LDAP_PASSWORD
fi
if [[ ! -e $SECRET ]] ; then
    echo "ERROR: $SECRET does not exists"
    exit 15
fi

if [[ $# -ge 1 && -x $(which $1 2>&-) ]]; then
    exec "$@"
elif [[ $# -ge 1 ]]; then
    echo "ERROR: command not found: $1"
    exit 13
elif ps -ef | egrep -v grep | grep -q smbd; then
    echo "Service already running, please restart container to apply changes"
else
    [[ ${NMBD:-""} ]] && ionice -c 3 nmbd -D
    ionice -c 3 smbd -FS </dev/null
fi
