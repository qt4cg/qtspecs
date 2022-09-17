# Build notes

The `qtspecs` are built and published automatically
by [GitHub workflows](https://docs.github.com/en/actions/using-workflows).

The current versions of the specifications are published to
https://qt4cg.org/specifications/. Pull requests are published to
`https://qt4cg.org/pr/NUMBER` where NUMBER is the PR number. Branches
are built to `https://qt4cg.org/branch/NAME` where NAME is the branch
name (branches are uncommon, most changes are done with pull requests
and merges back into the main branch, called `master` for historical
reasons).

As of September, 2022, the build scripts are maintained mostly by Norm
Tovey-Walsh If you have any questions or issues, he’s the one to ask.

## How to build

You can build the specifications yourself with Gradle. The only
pre-requisite is a modern version of Java (Java 1.8 or later should
work).

To build all of the specifications, run

```
./gradlew
```

or 

```
./gradlew publish
```

(On Windows, use `.\gradlew.bat` instead of `./gradlew` throughout)

## What to build

The default target is `publish` which builds all of the specifications.

Additional build targets will build individual specifications:

* `publish-xquery-40` builds the XPath, XQuery and shared specifications.
* `publish-xpath-functions-40` builds XPath Functions and Operators.
* `publish-xslt-40` builds XSLT 4.0.

In each case, Gradle will keep track of what needs to be rebuilt and
will do the smallest amount of work necessary. 

## Build options

The build script accepts a number of parameters by way of Gradle properties.

* `pedantic` enables a number of additional warnings (code examples that are too wide, for example).
* `debugTransformations` prints the full command line used to run each transformation; this is sometimes useful when debugging stylesheets.
* `legacyAntBuild` uses the legacy Ant build scripts. This should not be necessary, but if you find that the native Gradle builds are producing incorrect results, this will quickly work around the issue. Please do report the problem to the maintainer as well. (Note: using the legacy build system renders `pedantic` and `debugTransformations` inoperative.)

To set any of the options, pass `-Poption=true` to the build script.
For example, to see pedantic warnings, run:

```
./gradlew -Ppedantic=true publish
```
