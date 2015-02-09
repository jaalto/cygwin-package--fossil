#!/bin/sh
# Test basic functionality

set -e

proram=$0
TMPDIR=${TMPDIR:-/tmp}
BASE=tmp.$$
TMPBASE=${TMPDIR%/}/$BASE

case "$0" in
  */*)
        CURDIR=$(cd "${0%/*}" && pwd)
        ;;
  *)    CURDIR=$(pwd)
esac 

AtExit ()
{
    rm -rf "$TMPBASE"
}

Run ()
{
    echo "$*"
    shift
    "$@"
}

trap AtExit 0 1 2 3 15

# #######################################################################
# http://www.fossil-scm.org/fossil/doc/trunk/www/quickstart.wiki

Main ()
{
    which fossil
    Run "" fossil version

    mkdir -p "$TMPBASE"

    cd "$TMPBASE"
    
    repo="tmp.fsl"

    Run "%% TEST init:" fossil init $repo
    Run "%% TEST info:" fossil info --repository $repo 
    
    echo "Wait, Next command will take some time..."
    Run "%% TEST open:" fossil open $repo --keep
        
    file="test.txt"
    Run 123 > $file
    
    Run "%% TEST add:" fossil add --force $file
    Run "%% TEST commit:" fossil commit -m "New file"

    rm $file
    echo new >> $file.new

    Run "%% TEST add & remove: " fossil addremove

    Run "%% TEST changes:" fossil changes
    Run "%% TEST status:" fossil status

    Run "%% TEST commit:" fossil commit -m "changes"
    Run "%% TEST close:" fossil close $repo

}

Main "$@"

# End of file
