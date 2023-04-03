#!/bin/bash

OUTPUT=$1
if [ "$OUTPUT" = "" ]; then
    echo "Usage: $0 outputfile"
    exit 1
fi

PAGE=1
PERPAGE=100
DONE=0

#Use the DocBook issues list for testing...
#ISSUESURI=https://api.github.com/repos/docbook/xsltng/issues

ISSUESURI=https://api.github.com/repos/qt4cg/qtspecs/issues

rm -f /tmp/issues.$$.page*.json
while [ "$DONE" = "0" ]; do
    printf -v PN "%02d" $PAGE
    FN="/tmp/issues.$$.page$PN.json"
    printf "Getting page %s..." "$PN"
    curl -s -o $FN "$ISSUESURI?per_page=$PERPAGE&page=$PAGE&state=all"
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
