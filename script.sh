#!/bin/bash

### VARIABLES ###

DEBUG=1

BACKUPFILE="/tmp/GitHub/sparklyballs/masterfile.json"
USERFILE="/tmp/GitHub/sparklyballs/userfile.json"


TEMPDIR="/tmp/GitHub/sparklyballs"

SCRIPTDIR="/tmp/GitHub/sparklyballs"

#  Check if user list exists.  If not copy the backup file over

if [ ! -e $USERFILE ]
then
	cp "$BACKUPFILE" "$USERFILE"
fi


#  Convert the user file to something far easier to work with

if [ ! -d $TEMPDIR ]
then
	mkdir -p $TEMPDIR
fi
cat "$USERFILE" | $SCRIPTDIR/json.sh -b > $TEMPDIR/myUser.json


# Go through the list and enable / disable as required

ENTRY=0

while :
do
	if ! cat $TEMPDIR/myUser.json | grep -i "\[$ENTRY,\"name\"]" > /dev/null
	then
		break
	fi

	GROUP=$(cat $TEMPDIR/myUser.json | grep -i "\[$ENTRY,\"name\"" | sed 's/^.*name/name/' | sed 's/^......//' | sed -e 's/^[ \t]*//' | sed 's/\"//g' )
	ACTIVE=$(cat $TEMPDIR/myUser.json | grep -i "\[$ENTRY,\"active\"" | sed 's/^.*active/active/' | sed 's/^........//' | sed -e 's/^[ \t]*//' | sed 's/\"//g' | tr '[:upper:]' '[:lower:]' )

	if [ $DEBUG == 1 ]
	then
		echo "Found user group: $GROUP... Active: $ACTIVE"
	fi

	if [[ $ACTIVE == "true" ]]
	then
		echo "change this line to be python3 pynab.py group enable $GROUP"
	else
		echo "change this line to be python3 pynab.py group disable $GROUP"
	fi

	ENTRY=$((ENTRY + 1))
done

rm $TEMPDIR/myUser.json
