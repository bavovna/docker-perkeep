#!/bin/bash

set -euo pipefail
IFS=$'\n\t'


docker rm -f -v camlistored && docker rm -v camlidata || true
docker run --name=camlidata mkorenkov/camlistore-data:latest
docker run -d --name=camlistored --volumes-from=camlidata -p 3179:3179 -e CAMLISTORE_AUTH="userpass:max:test37" mkorenkov/camlistored:latest
