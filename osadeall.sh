#!/bin/bash

exclude=('.' '..' 'README.md' 'install.sh' 'osadeall.sh')
instdir="$HOME/Library/Scripts"

backup="bak"
overwrite=1
dryrun=0
newlink=()
exist=()
curdir=`pwd -P`

# help
HELP="Usage: $0 [-nd] [-b <backup file postfix>] [-e <exclude file>] [-i <installed dir>]

Convert *scpt in script folder to *applescript in this directory

Arguments:
      -b  Set backup postfix (default: make *.bak file)
          Set \"\" if backups are not necessary
      -e  Set additional exclude file (default: ${exclude[@]})
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
  mkdir -p $instdir
else
  echo "*** This is dry run, not convert anything ***"
fi
for scpt in $instdir/*.scpt;do
  f=$(basename $scpt)
  for e in ${exclude[@]};do
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
  install=1
  if [ $dryrun -eq 1 ];then
    install=0
  fi
  if [ "`ls "$curdir/$name" 2>/dev/null`" != "" ];then
    exist=(${exist[@]} "$name")
    if [ $dryrun -eq 1 ];then
      echo -n ""
    elif [ $overwrite -eq 0 ];then
      install=0
    elif [ "$backup" != "" ];then
      mv "$curdir/$name" "$curdir/${name}.$backup"
    else
      rm "$curdir/$name"
    fi
  else
    newlink=(${newlink[@]} "$name")
  fi
  if [ $install -eq 1 ];then
    osadecompile $scpt > $name
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
  fi
done
echo ""
if [ $dryrun -eq 1 ];then
  echo "Following files don't exist:"
else
  echo "Following files were newly converted:"
fi
echo "  ${newlink[@]}"
echo
echo -n "Following files existed"
if [ $dryrun -eq 1 ];then
  echo "Following files exist:"
elif [ $overwrite -eq 0 ];then
  echo "Following files exist, remained as is:"
elif [ "$backup" != "" ];then
  echo "Following files existed, backups (*.$backup) were made:"
else
  echo "Following files existed, replaced old one:"
fi
echo "  ${exist[@]}"
echo
