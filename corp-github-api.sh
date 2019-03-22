#! /bin/sh
# A script that communicates with the Oath github organization. It takes the
# latter half the API query (i.e. everything after `https://api.github.com/v3`)
# and returns the JSON blob spat out by the API.
curl -s -1 -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/v3/$1
