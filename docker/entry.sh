#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

CONFDIR="/srv/camlistore/.config"
DATADIR="/srv/camlistore/data"
mkdir -p "$DATADIR"
chmod 700 "$DATADIR"
chown -R camlistore "$DATADIR"

if [ ! -d $CONFDIR ]; then
  # generate configs in hacky way
  {
  	gosu camlistore /usr/local/bin/camlistored & PID=$!
  	# wait until started
  	sleep 5
  	kill -15 $PID
  }
  # end: generate configs in hacky way

  #todo: modify config accordingly
fi

cd /srv/camlistore/
gosu camlistore /usr/local/bin/camlistored "$@"
