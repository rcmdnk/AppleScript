#!/bin/sh
for f in *.applescript;do
  name="~/Library/Scripts/`basename $f|awk '{split($1,tmp,".applescript")}{print tmp[1]}'`.scpt"
  echo "osacompile $f > $name"
done
