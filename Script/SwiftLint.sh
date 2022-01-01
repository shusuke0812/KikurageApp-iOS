#!/bin/sh

# SwiftLintのShell Script
# Xcodeのビルド（cmd + B）時に静的解析を行うスクリプト

echo "start: ***** SwiftLint *****"

if which swiftlint > /dev/null; then
  # gitの差分を見て変更があったファイルのみ静的解析を行う
  git diff --name-only | grep .swift | while read filename; do
    swiftlint
  done
  echo "success"
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi

echo "end: ***** SwiftLint *****"