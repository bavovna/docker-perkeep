#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

CAMLISTORE_GIT_URL="https://camlistore.googlesource.com/camlistore"
CAMLISTORE_RELEASE=0.9

if [ ! -d "build/src/camlistore" ]; then
  git clone $CAMLISTORE_GIT_URL build/src/camlistore
  cd build/src/camlistore
  git checkout tags/$CAMLISTORE_RELEASE
  cd -
fi

cd build
docker build -t mkorenkov/camlistore-build:latest .
docker run --rm -v `pwd`/bin:/opt/camlistore/bin mkorenkov/camlistore-build:latest run make.go
cd -
