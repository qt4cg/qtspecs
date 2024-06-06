#!/bin/bash

cat qtspecs-issues.json \
| jq ".[] | select(.pull_request)" \
| jq -s '.' \
| jq '.[] | select(.state == "open")' \
| jq -s '.'  \
| jq '.[] | "\(.number) \(.title)"'

