#!/bin/bash

SPEC=$1
HTML=`basename $SPEC`
DIR=`dirname $SPEC`
BASE=`basename $DIR`
PID=$$

if [ "$2" = "" ]; then
    OUTFN=autodiff.html
else
    OUTFN=$2
fi

if [ ! -f "$SPEC" ]; then
    echo "No spec: $SPEC"
    exit
fi

# Get the current version of the base spec
curl -s -o /tmp/A.$PID.html https://qt4cg.org/specifications/$BASE/$HTML

# Convert it to XML
java -cp tools/htmlparser-1.4.jar nu.validator.htmlparser.tools.HTML2XML \
     /tmp/A.$PID.html /tmp/A.$PID.xml

# Convert it back into XHTML 5 (avoid <script/> etc.)
java -jar tools/deltaxml/saxon9pe.jar \
     -xsl:tools/xhtml5.xsl -s:/tmp/A.$PID.xml -o:/tmp/A.$PID.html

rm -f /tmp/A.$PID.xml

# Convert the new version of the spec to XML
java -cp tools/htmlparser-1.4.jar nu.validator.htmlparser.tools.HTML2XML \
     $SPEC /tmp/B.$PID.xml

# Convert it back into XHTML 5 (avoid <script/> etc.)
java -jar tools/deltaxml/saxon9pe.jar \
     -xsl:tools/xhtml5.xsl -s:/tmp/B.$PID.xml -o:/tmp/B.$PID.html

rm -f /tmp/B.$PID.xml

# Make the diff version
java -jar tools/deltaxml/command-15.0.2.jar compare xhtml-patch \
     /tmp/A.$PID.html /tmp/B.$PID.html /tmp/autodiff.$PID.html

# Patch the diff version and make it HTML5
java -jar tools/deltaxml/saxon9pe.jar \
     -s:/tmp/autodiff.$PID.html -xsl:tools/patchdiff.xsl -o:$DIR/$OUTFN

echo "DeltaXML diff: $DIR/$OUTFN"

rm -f /tmp/A.$PID.html /tmp/B.$PID.html /tmp/autodiff.$PID.html
