#!/bin/bash

OUTDIR=$1
if [ "$OUTDIR" = "" ]; then
    echo "Usage: $0 outputdir"
    exit 1
fi

PAGE=1
PERPAGE=100
DONE=0

ISSUESURI=https://api.github.com/repos/qt4cg/qtspecs/issues
PULLSURI=https://api.github.com/repos/qt4cg/qtspecs/pulls

if [ -z GH_TOKEN ]; then
    echo "No access token; unauthenticated requests are rate limited."
fi

rm -f /tmp/issues.$$.page*.json
while [ "$DONE" = "0" ]; do
    FN="/tmp/issues.$$.page$PAGE.json"
    echo "Getting page $PAGE ..."

    if [ -z GH_TOKEN ]; then
        curl -s -o $FN "$ISSUESURI?per_page=$PERPAGE&page=$PAGE&state=all"
    else
        curl -s -o $FN \
             --header "Authorization: Bearer $GH_TOKEN" \
             --header "X-GitHub-Api-Version: 2022-11-28" \
             "$ISSUESURI?per_page=$PERPAGE&page=$PAGE&state=all"
    fi

    LAST=`cat $FN | jq ".[].number" | tail -1`
    if [ "$LAST" = "1" ]; then
        DONE=1
    fi

    PAGE=`expr $PAGE + 1`
    if [ "$PAGE" -gt 25 ]; then
        # something has gone sideways
        DONE=1
    fi
done

cat /tmp/issues.$$.page*.json | jq -s 'reduce .[] as $x ([]; . + $x)' > $OUTDIR/issues.json

cat $OUTDIR/issues.json \
| jq ".[] | select(.pull_request)" \
| jq -s '.' \
| jq '.[] | select(.state == "open")' \
| jq -s '.'  \
| jq '.[] | .number' > $OUTDIR/openprs.txt

echo "{" > $OUTDIR/changes.json
for pr in `cat $OUTDIR/openprs.txt`; do
    echo "Getting changed files for PR $pr ..."
    echo "\"$pr\":" >> $OUTDIR/changes.json
    curl -s \
         --header "Authorization: Bearer $GH_TOKEN" \
         --header "X-GitHub-Api-Version: 2022-11-28" \
         "$PULLSURI/$pr/files?per_page=$PERPAGE" \
    | jq "map({filename: .filename, status: .status, sha: .sha})" >> $OUTDIR/changes.json
    echo "," >> $OUTDIR/changes.json
done
echo "\"0\":[]}" >> $OUTDIR/changes.json
