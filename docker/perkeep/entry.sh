#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

CONFDIR="/srv/camlistore/.config/perkeep/"
DATADIR="/srv/camlistore/var/perkeep"

mkdir -p "$DATADIR" && chmod 700 "$DATADIR"
mkdir -p "$CONFDIR" && chmod 700 "$CONFDIR"
chown -R camlistore /srv/camlistore

set -x

if [ ! -f "$CONFDIR/server-config.json" ]; then
  if [ -z ${CAMLISTORE_AUTH} ]; then
    echo "missing -e CAMLISTORE_AUTH=\"userpass:username:secret\""
    exit 1
  fi
  # generate configs in hacky way
  {
  	gosu camlistore /usr/local/bin/perkeepd & PID=$!
  	# wait until started
  	sleep 5
  	kill -15 $PID
  }
  # end: generate configs in hacky way

  #todo: modify config accordingly
  camlistore_auth_escape=$(echo $CAMLISTORE_AUTH | sed 's/\//\\\//g' | sed 's/"/\"/g')
  sed -i "s/\"auth\": \"localhost\",/\"auth\": \"${camlistore_auth_escape}\",/g" "$CONFDIR/server-config.json"
  sed -i "s/levelDB/kvIndexFile/g" "$CONFDIR/server-config.json"
  sed -i "s/leveldb/kvIndexFile/g" "$CONFDIR/server-config.json"
  sed -i "s/packRelated/packBlobs/g" "$CONFDIR/server-config.json"
  cat "$CONFDIR/server-config.json"
  echo
  rm -rf $DATADIR
fi

cd /srv/camlistore/
gosu camlistore "$@"
sync
