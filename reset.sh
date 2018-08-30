#!/usr/bin/env bash

set -evo pipefail

for D in `find * -maxdepth 0 -type d`
do
  echo "Resetting app ${D}"
  ( cd $D \
    && heroku pg:reset --app $D --confirm $D \
    && heroku restart --app $D \
    && sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' config.yaml > ../domain.sh && source ../domain.sh \
    && version=$(curl -H "Accept: application/json" -H "Content-Type: application/json" "${endpoint}/v1/version" | jq -r '.version') \
    && curl -Lo /tmp/cli-hasura-linux-amd64-${version} https://github.com/hasura/graphql-engine/releases/download/${version}/cli-hasura-linux-amd64 \
    && chmod a+x /tmp/cli-hasura-linux-amd64-${version} \
    && /tmp/cli-hasura-linux-amd64-${version} migrate apply \
    && /tmp/cli-hasura-linux-amd64-${version} metadata apply \
    && if [ -z "$subdomain" ]; then
            continue
       fi \
    && heroku domains:add ${subdomain}.hasura.app --app $D || true \
    && cname=$(heroku domains --app ${D} --json | jq --arg v "$subdomain.hasura.app" -c '.[] | select( .hostname | contains($v))' | jq -r '.cname') \
    && cli4 --post type="CNAME" proxied=true name="${subdomain}" content="${cname}" /zones/:hasura.app/dns_records || true \
    && cli4 --patch proxied=true type="CNAME" name="${subdomain}" content="${cname}" /zones/:hasura.app/dns_records/:${subdomain}.hasura.app)
done
