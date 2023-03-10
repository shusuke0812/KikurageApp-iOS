#!/bin/sh

# SwiftFormat shell script on Build phase

echo "start: ***** SwiftFormat *****"

if which swiftformat > /dev/null; then
  swiftformat .
else
  echo "warning: SwiftFormat not installed, download from https://github.com/nicklockwood/SwiftFormat"
fi

echo "end: ***** SwiftFormat *****"