#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

cd build
docker build -t mkorenkov/camlistore-build:latest .
docker run --rm -v `pwd`/bin:/opt/camlistore/bin mkorenkov/camlistore-build:latest run make.go
cd -
