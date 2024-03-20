#!/usr/bin/env bash
RUNPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
VERSION=$(head -1 ../version)
docker run --rm -it --env-file ${RUNPATH}/.env keepbot/git-cleaner:${VERSION}
