#!/usr/bin/env bash

cd "$(dirname "${0}")/.." # cd to repository root

NAME="fortyseveneffects/avr-builder"
VERSION="$(cat version)"

echo "Publishing $NAME:$VERSION"
docker image push $NAME:$VERSION

echo "Publishing $NAME:latest"
docker image push $NAME:latest
