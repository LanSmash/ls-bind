#!/bin/bash
set -e

#find directory this script is in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

RUNNING_BLOCK_FILE="$DIR/../etc/rpz.block.ls.db"

echo "preparing $1 input file (removing # and blank lines)"
grep -v \# "$1" | egrep -v "^$" > /tmp/whitelist.txt

#^\**\.*youtube.com IN
# matches youtube.com IN
# and *.youtube.com IN

prefix='^\**\.*'
while read -r line
do
 echo "$prefix$line IN"
done </tmp/whitelist.txt > /tmp/whitelist2.txt
#mv newfile $file

echo parsing $RUNNING_BLOCK_FILE
grep -vif /tmp/whitelist2.txt $RUNNING_BLOCK_FILE > /tmp/test.db


set +e

echo ...Differences:
diff $RUNNING_BLOCK_FILE /tmp/test.db
#echo ..Changes are listed above, press enter to apply changes
#read

cp /tmp/test.db $RUNNING_BLOCK_FILE
