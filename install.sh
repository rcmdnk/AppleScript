#!/bin/bash

exclude=('.' '..' 'LICENSE' 'README.md' 'install.sh' 'osadeall.sh')
instdir="$HOME/Library/Scripts"

backup="bak"
overwrite=1
dryrun=0
newlink=()
updated=()
exist=()
curdir=`pwd -P`

# help
HELP="Usage: $0 [-nd] [-b <backup file postfix>] [-e <exclude file>] [-i <install dir>]

Install *applescript to user's folder as *scpt, by compiling with osacompile

Arguments:
      -b  Set backup postfix (default: make *.bak file)
          Set \"\" if backups are not necessary
      -e  Set additional exclude file (default: ${exclude[@]})
      -i  Set install directory (default: $instdir)
      -n  Don't overwrite if file is already exist
      -d  Dry run, don't install anything
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
echo "Install X.applescript to $instdir/X.scpt"
echo "**********************************************"
echo
if [ $dryrun -ne 1 ];then
  mkdir -p $instdir
else
  echo "*** This is dry run, not install anything ***"
fi
for f in *.applescript;do
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
  name=${f%.applescript}.scpt
  install=1
  if [ $dryrun -eq 1 ];then
    install=0
  fi

  tmpscpt=".${name}.tmp"
  osacompile -o "$tmpscpt" "$curdir/$f"

  if [ "`ls "$instdir/$name" 2>/dev/null`" != "" ];then
    diffret=$(diff $instdir/$name $tmpscpt)
    if [ "$diffret" != "" ];then
      updated=(${updated[@]} "$name")
      if [ $dryrun -eq 1 ];then
        echo -n ""
      elif [ $overwrite -eq 0 ];then
        install=0
      elif [ "$backup" != "" ];then
        mv "$instdir/$name" "$instdir/${name}.$backup"
      else
        rm "$instdir/$name"
      fi
    else
      exist=(${exist[@]} "$name")
      install=0
    fi
  else
    newlink=(${newlink[@]} "$name")
  fi
  if [ $install -eq 1 ];then
    mv "$tmpscpt" "$instdir/$name"
  fi
  rm -f "$tmpscpt"
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
echo "  ${updated[@]}"
echo
if [ $dryrun -eq 1 ];then
  echo "Following files don't exist:"
else
  echo "Following files were newly installed:"
fi
echo "  ${newlink[@]}"
echo
echo -n "Following files exist and have no updaets"
echo "  ${exist[@]}"
echo
