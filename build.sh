#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

cd docker/build
docker build -t mkorenkov/camlistore-build:latest .
docker run --rm -v `pwd`/bin:/srv/go/bin mkorenkov/camlistore-build:latest go run make.go --sqlite=false -static=true -v
cp bin/perkeepd ../camlistored/bin/
cp bin/pk ../camtool/bin/

cd ../camlistored
docker build -t mkorenkov/camlistored:latest .
cd ../camtool
docker build -t mkorenkov/camtool:latest .
cd ../data
docker build -t mkorenkov/camlistore-data:latest .
cd ../..
