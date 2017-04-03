#!/usr/bin/env bash

cd "$(dirname "${0}")/.." # cd to repository root

NAME="fortyseveneffects/avr-builder"
VERSION="$(cat version)"

echo "Building $NAME:$VERSION"
docker build -t $NAME:$VERSION -t $NAME:latest "$@" .
