#!/bin/sh
. ~/.bashrc
for f in *.applescript;do
  name="$HOME/Library/Scripts/`basename $f|awk '{split($1,tmp,".applescript")}{print tmp[1]}'`.scpt"
  echo "osacompile -o $name $f"
  osacompile -o $name $f
done
