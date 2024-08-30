#!/bin/bash

OUTPUT=$1
if [ "$OUTPUT" = "" ]; then
    echo "Usage: $0 outputfile"
    exit 1
fi

PAGE=1
PERPAGE=100
DONE=0

ISSUESURI=https://api.github.com/repos/qt4cg/qtspecs/issues

if [ -z GH_TOKEN ]; then
    echo "No access token; unauthenticated requests are rate limited."
fi

rm -f /tmp/issues.$$.page*.json
while [ "$DONE" = "0" ]; do
    printf -v PN "%02d" $PAGE
    FN="/tmp/issues.$$.page$PN.json"
    printf "Getting page %s..." "$PN"

    if [ -z GH_TOKEN ]; then
        curl -s -o $FN "$ISSUESURI?per_page=$PERPAGE&page=$PAGE&state=all"
    else
        curl -s -o $FN \
             --header "Authorization: Bearer $GH_TOKEN" \
             --header "X-GitHub-Api-Version: 2022-11-28" \
             "$ISSUESURI?per_page=$PERPAGE&page=$PAGE&state=all"
    fi

    LAST=`cat $FN | jq ".[].number" | tail -1`
    echo $LAST
    if [ "$LAST" = "1" ]; then
        DONE=1
    fi

    PAGE=`expr $PAGE + 1`
    if [ "$PAGE" -gt 15 ]; then
        # something has gone sideways
        DONE=1
    fi
done

cat /tmp/issues.$$.page*.json | jq -s 'reduce .[] as $x ([]; . + $x)' > $OUTPUT
