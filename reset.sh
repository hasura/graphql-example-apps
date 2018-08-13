#!/usr/bin/env bash

set -evo pipefail

for D in `find * -maxdepth 0 -type d`
do
  echo "Resetting app ${D}"
  ( cd $D && heroku pg:reset --app $D --confirm $D && heroku restart --app $D && hasura migrate apply && hasura metadata apply )
done
