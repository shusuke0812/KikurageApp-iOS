#!/bin/sh

# SwiftFormat shell script on Build phase

echo "start: ***** SwiftFormat *****"

if which swiftformat > /dev/null; then
    git diff --name-only | grep .swift | while read filename; do
        swiftformat .
    done
else
  echo "warning: SwiftFormat not installed, download from https://github.com/nicklockwood/SwiftFormat"
fi

echo "end: ***** SwiftFormat *****"