#!/bin/bash

if [[ -v CIRCLE_TAG ]]; then
    echo "Publishing specifications for $CIRCLE_TAG"
else
    if [ "$CIRCLE_BRANCH" = "master" ]; then
        echo "Deploying updates for master branch"
    else
        echo "Deploying updates commit on $CIRCLE_BRANCH branch"
    fi
fi

if [ `git branch -r | grep "origin/gh-pages" | wc -l` = 0 ]; then
    echo "No gh-pages branch for publication"
    exit
fi

if [ `set | grep GIT_EMAIL | wc -l` = 0 -o `set | grep GIT_USER | wc -l` = 0 ]; then
    echo "No identity configured with GIT_USER/GIT_EMAIL"
    exit
fi

git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_USER

# Remember the SHA of the current build.
SHA=$(git rev-parse --verify HEAD)

# Save the website files
cd build/www
tar cf - . | gzip > /tmp/website.$$.tar.gz

# Get rid of the build artifacts
cd ../..
git restore .
rm -rf build .gradle

# Switch to the gh-pages branch
git checkout --track origin/gh-pages
git fetch origin
git rebase origin/gh-pages

# Unpack the website files
mkdir -p branch/$CIRCLE_BRANCH
cd branch/$CIRCLE_BRANCH
rm -rf *
tar zxf /tmp/website.$$.tar.gz
rm /tmp/website.$$.tar.gz
cd ../..

# This next bit is a totally crude hack to build an index of the
# available HTML files. (I plan to use this later to generate a pretty
# index page.)
BRANCHTEMP=/tmp/lspec.b.$$.txt
SPECTEMP=/tmp/lspec.b.$$.txt
rm -f $BRANCHTEMP $SPECTEMP

# This is a crude hack. It assumes branch/$branch/$spec is all there is.
for overview in `find branch -type f -name Overview.html -print`; do
    path=`dirname $overview`
    path=`dirname $path`
    echo `basename $path` >> $BRANCHTEMP
done

echo "<specifications xml:base='branch/'>" > index.xml
for branch in `cat $BRANCHTEMP | sort | uniq`; do
    for overview in `find branch/$branch -type f -name Overview.html -print`; do
        path=`dirname $overview`
        echo `basename $path` >> $SPECTEMP
    done
    echo "  <branch name='$branch'>" >> index.xml
    for spec in `cat $SPECTEMP | sort | uniq`; do
        if [ -d "branch/$branch/$spec" ]; then
            echo "    <specification name='$spec'>" >> index.xml
            for file in `ls -1 branch/$branch/$spec/*.html`; do
                echo "      <html>`basename $file`</html>" >> index.xml
            done
            echo "    </specification>" >> index.xml
        fi
    done
    echo "  </branch>" >> index.xml
done
echo "</specifications>" >> index.xml

# Push the changes back to the repo
git add .
git commit -m "Deploy gh-pages for ${CIRCLE_PROJECT_USERNAME}: ${SHA}"
git push -q origin HEAD

# Go back to the main branch
git checkout master
