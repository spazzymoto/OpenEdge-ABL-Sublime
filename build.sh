#!/bin/bash

rm -rf build
cp -r src/ build/

$DLC/bin/_progres -1 -b -p tools/keywords.p
keyword_regex=$(<tools/keywords.regex)
sed -i "s/REPLACE-KEYWORD-REGEX/$keyword_regex/g" build/ABL.sublime-syntax

$DLC/bin/_progres -1 -b -p tools/alias.p

cd build
zip -q -r "../dist/OpenEdge ABL.sublime-package" .
cd -

rm -rf build