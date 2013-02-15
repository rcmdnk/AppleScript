#!/bin/sh
for f in $HOME/Library/Scripts/*scpt;do
  name=`basename $f|cut -d . -f1`.applescript
  osadecompile $f > $name
done
