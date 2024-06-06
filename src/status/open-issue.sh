#!/bin/bash

cat qtspecs-issues.json \
| jq ".[] | select(.pull_request | not)" \
| jq -s '.' \
| jq '.[] | select(.state == "open")' \
| jq -s '.'  \
| jq '.[] | "\(.number) \(.title)"'

