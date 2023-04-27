#!/bin/bash

cat qtspecs-issues.json \
| jq ".[] | select(.pull_request)" \
| jq -s '.' \
| jq '.[] | select(.state == "closed")' \
| jq -s '.'  \
| jq '.[].number'

