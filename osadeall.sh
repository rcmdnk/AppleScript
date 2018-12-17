#!/bin/bash

exclude=('.' '..' 'LICENSE' 'README.md' 'install.sh' 'osadeall.sh')
instdir="$HOME/Library/Scripts"

backup=""
overwrite=1
dryrun=0
newlink=()
updated=()
exist=()
curdir=$(pwd -P)

# help
HELP="Usage: $0 [-nd] [-b <backup file postfix>] [-e <exclude file>] [-i <installed dir>]

Convert *scpt in script folder to *applescript in this directory

Arguments:
      -b  Set backup postfix, like \"bak\" (default: \"\": no back up is made)
      -e  Set additional exclude file (default: ${exclude[*]})
      -i  Set installed directory (default: $instdir)
      -n  Don't overwrite if file is already exist
      -d  Dry run, don't convert anything
      -h  Print Help (this message) and exit
"
while getopts b:e:i:ndh OPT;do
  case $OPT in
    "b" ) backup=$OPTARG ;;
    "e" ) exclude=(${exclude[@]} "$OPTARG") ;;
    "i" ) instdir="$OPTARG" ;;
    "n" ) overwrite=0 ;;
    "d" ) dryrun=1 ;;
    "h" ) echo "$HELP" 1>&2; exit ;;
    * ) echo "$HELP" 1>&2; exit ;;
  esac
done

echo "**********************************************"
echo "Convert $instdir/X.scpt to $instdir/X.applescript"
echo "**********************************************"
echo
if [ $dryrun -ne 1 ];then
  mkdir -p "$instdir"
else
  echo "*** This is dry run, not convert anything ***"
fi
for scpt in $instdir/*.scpt;do
  f=$(basename "$scpt")
  for e in "${exclude[@]}";do
    flag=0
    if [ "$f" = "$e" ];then
      flag=1
      break
    fi
  done
  if [ $flag = 1 ];then
    continue
  fi
  name=${f%.scpt}.applescript
  orig="$scpt"
  target="$curdir/$name"
  if [[ "$orig" -ot "$target" ]];then
    continue
  fi
  install=1
  if [ $dryrun -eq 1 ];then
    install=0
  fi

  tmpscript=.${name}.tmp
  osadecompile "$orig" > "$tmpscript"
  while :;do
    if [ "$(tail -n1 "$tmpscript")" = "" ];then
      # Mac's sed need zero-length extension after -i not to make backup
      # but it is not recommended
      # It isn't necessary in Linux...
      #sed -i '' -e '$d' $tmpscript
      sed -e '$d' "$tmpscript" > "${tmpscript}.tmp"
      mv "${tmpscript}.tmp" "$tmpscript"
    else
      break
    fi
  done

  if [ "$(ls "$target" 2>/dev/null)" != "" ];then
    diffret=$(diff "$target" "$tmpscript")
    if [ "$diffret" != "" ];then
      updated=(${updated[@]} "$name")
      if [ $dryrun -eq 1 ];then
        echo -n ""
      elif [ $overwrite -eq 0 ];then
        install=0
      elif [ "$backup" != "" ];then
        mv "$target" "${target}.$backup"
      else
        rm "$target"
      fi
    else
      exist=(${exist[@]} "$name")
      install=0
    fi
  else
    newlink=(${newlink[@]} "$name")
  fi
  if [ $install -eq 1 ];then
    mv "$tmpscript" "$target"
  fi
  rm -f "$tmpscript"
done
echo ""
if [ $dryrun -eq 1 ];then
  echo "Following files have updates:"
elif [ $overwrite -eq 0 ];then
  echo "Following files have updates, but remained as is:"
elif [ "$backup" != "" ];then
  echo "Following files have updates, backups (*.$backup) were made:"
else
  echo "Following files have updates, replaced old one:"
fi
echo "  ${updated[*]}"
echo
if [ $dryrun -eq 1 ];then
  echo "Following files don't exist:"
else
  echo "Following files were newly converted:"
fi
echo "  ${newlink[*]}"
echo
echo -n "Following files exist and have no updaets"
echo "  ${exist[*]}"
echo
