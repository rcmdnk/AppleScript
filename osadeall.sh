#!/bin/sh
for f in ~/Library/Scripts/*scpt;do
  name=`basename $f|cut -d . -f1`.applescript
  osadecompile $f > $name
done
