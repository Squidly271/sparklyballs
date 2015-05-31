#!/bin/bash

### VARIABLES ###

DEBUG=1

MASTERFILE="/tmp/GitHub/sparklyballs/masterfile.json"
USERFILE="/tmp/GitHub/sparklyballs/userfile.json"

TEMPDIR="/tmp/GitHub/sparklyballs"

SCRIPTDIR="/tmp/GitHub/sparklyballs"

#  Convert the master and user files to something far easier to work with

if [ ! -d $TEMPDIR ]
then
	mkdir -p $TEMPDIR
fi
cat "$MASTERFILE" | $SCRIPTDIR/json.sh -b > $TEMPDIR/myMaster.json
cat "$USERFILE" | $SCRIPTDIR/json.sh -b > $TEMPDIR/myUser.json

ENTRY=0

while :
do
	if ! cat $TEMPDIR/myUser.json | grep -i "\[$ENTRY,\"name\"]" > /dev/null
	then
		break
	fi

	GROUP=$(cat $TEMPDIR/myUser.json | grep -i "\[$ENTRY,\"name\"" | sed 's/^.*name/name/' | sed 's/^......//' | sed -e 's/^[ \t]*//' | sed 's/\"//g' )
	ACTIVE=$(cat $TEMPDIR/myUser.json | grep -i "\[$ENTRY,\"active\"" | sed 's/^.*active/active/' | sed 's/^........//' | sed -e 's/^[ \t]*//' | sed 's/\"//g' )

	if [ $DEBUG == 1 ]
	then
		echo "Found user group: $GROUP... Active: $ACTIVE"
	fi

	if cat $TEMPDIR/myMaster.json | grep -i "$GROUP" > /dev/null
	then
		if [ $DEBUG == 1 ]
		then
			echo "Group already exists in master list.  Master list active setting takes precedence"
		fi
	else
		if [[ $ACTIVE == "true" ]]
		then
			if [ $DEBUG == 1 ]
			then
				echo "Group is active"
			fi
			echo "change this line to be python3 pynab.py group enable $GROUP"
		fi
	fi

	ENTRY=$((ENTRY + 1))

	if [ $DEBUG == 1 ]
	then
		echo ""
	fi
done

