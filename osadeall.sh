#!/bin/sh
for f in $HOME/Library/Scripts/*scpt;do
  name=`basename $f|cut -d . -f1`.applescript
  echo "osadecompile $f > $name"
  osadecompile $f > $name
  # remove bottom empty lines
  while [ 1 ];do
    if [ "`tail -n1 $name`" = "" ];then
      # Mac's sed need zero-length extension after -i not to make backup
      # but it is not recommended
      # It isn't necessary in Linux...
      #sed -i '' -e '$d' $name
      sed -e '$d' $name > $name.tmp
      mv $name.tmp $name
    else
      break
    fi
  done
done
