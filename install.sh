#!/usr/bin/env bash

if [[ ! "$OSTYPE" =~ darwin ]];then
  echo Can be used only in Mac.
  exit
fi

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
HELP="Usage: $0 [-ndsh] [-b <backup file postfix>] [-e <exclude file>] [-i <install dir>]

Install *applescript to user's folder as *scpt, by compiling with osacompile

Arguments:
      -b  Set backup postfix, like \"bak\" (default: \"\": no back up is made)
      -e  Set additional exclude file (default: ${exclude[*]})
      -i  Set install directory (default: $instdir)
      -n  Don't overwrite if file is already exist
      -d  Dry run, don't install anything
      -s  Use 'pwd' instead of 'pwd -P' to make a symbolic link
      -h  Print Help (this message) and exit
"
while getopts b:e:i:ndsh OPT;do
  case $OPT in
    "b" ) backup=$OPTARG ;;
    "e" ) exclude=("${exclude[@]}" "$OPTARG") ;;
    "i" ) instdir="$OPTARG" ;;
    "n" ) overwrite=0 ;;
    "d" ) dryrun=1 ;;
    "s" ) curdir=$(pwd) ;;
    "h" ) echo "$HELP" 1>&2; exit ;;
    * ) echo "$HELP" 1>&2; exit 1;;
  esac
done

echo "**********************************************"
echo "Install X.applescript to $instdir/X.scpt"
echo "**********************************************"
echo
if [ $dryrun -ne 1 ];then
  mkdir -p "$instdir"
else
  echo "*** This is dry run, not install anything ***"
fi
for f in *.applescript;do
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
  name=${f%.applescript}.scpt
  orig="$curdir/$f"
  target="$instdir/$name"
  if [[ "$orig" -ot "$target" ]];then
    continue
  fi

  install=1
  if [ $dryrun -eq 1 ];then
    install=0
  fi

  tmpscpt=".${name}.tmp"
  osacompile -o "$tmpscpt" "$orig"

  if [ "$(ls "$target" 2>/dev/null)" != "" ];then
    diffret=$(diff "$target" "$tmpscpt")
    #if [ "$diffret" != "" ];then
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
    #else
    #  exist=(${exist[@]} "$name")
    #  install=0
    #fi
  else
    newlink=(${newlink[@]} "$name")
  fi
  if [ $install -eq 1 ];then
    echo mv "$tmpscpt" "$target"
    mv "$tmpscpt" "$target"
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
echo "  ${updated[*]}"
echo
if [ $dryrun -eq 1 ];then
  echo "Following files don't exist:"
else
  echo "Following files were newly installed:"
fi
echo "  ${newlink[*]}"
echo
echo -n "Following files exist and have no updaets"
echo "  ${exist[*]}"
echo
