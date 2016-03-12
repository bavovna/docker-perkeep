#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

cd docker/build
docker build -t mkorenkov/camlistore-build:latest .
docker run --rm -v `pwd`/bin:/opt/camlistore/bin mkorenkov/camlistore-build:latest run make.go
cd -

cd docker/data
docker build -t mkorenkov/camlistore-data:latest .
docker run --name=camlidata mkorenkov/camlistore-data:latest
cd -

docker build -t mkorenkov/camlistored:latest .
docker run --rm --name=camlistored --volumes-from=camlidata -p 3179:3179 mkorenkov/camlistored:latest

