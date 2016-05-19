#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

cd docker/build
docker build -t mkorenkov/camlistore-build:latest .
docker run --rm -v `pwd`/bin:/opt/camlistore/bin mkorenkov/camlistore-build:latest run make.go --sqlite=false -v
cp bin/camlistored ../camlistored/bin/
cp bin/camtool ../camtool/bin/

cd ../camlistored
docker build -t mkorenkov/camlistored:latest .
cd ../camtool
docker build -t mkorenkov/camtool:latest .
cd ../data
docker build -t mkorenkov/camlistore-data:latest .
cd ../..
