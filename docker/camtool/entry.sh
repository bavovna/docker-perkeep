#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

CONFDIR="/srv/camlistore/.config/perkeep/"
DATADIR="/srv/camlistore/var/camlistore"

mkdir -p "$DATADIR" && chmod 700 "$DATADIR"
mkdir -p "$CONFDIR" && chmod 700 "$CONFDIR"
chown -R camlistore /srv/camlistore

cd /srv/camlistore/
gosu camlistore /usr/local/bin/pk "$@"
sync
