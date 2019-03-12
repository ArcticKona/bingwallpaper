#!/bin/bash
# TODO: Allow spaces in function arguments

test "a$FontDefault" == 'a' &&
	source fonts.sh

test "a$WE_DIR" == 'a' &&
	export WE_DIR='/tmp/wecache'

mkdir -p $WE_DIR
test -d $WE_DIR ||
	echo "${FontRed}Warning: caching directory not found ${FontDefault}" 1>&2

#alias wget=wecache

function wevars {
	export WE_URL=$1
	export WE_FILE="$WE_DIR/`echo $WE_URL | md5sum - | grep -oEe '^[^ ]+' - `"
	export WE_INFO="$WE_FILE.info"
}

function wecache {
	WE_TEMP=`mktemp`
	test "a$WE_TEMP" == 'a' &&
		WE_TEMP="/tmp/wecache.$$.tmp"

	wevars $1

	if test -f $WE_FILE ; then
		cat $WE_FILE
		rtn=$?

	else
		wget -O $WE_TEMP $@ 2> $WE_INFO
		rtn=$?

		if test $rtn -eq 0 ; then
			cat $WE_TEMP
			mv $WE_TEMP $WE_FILE
		fi

	fi

	test -f $WE_TEMP &&
		rm $WE_TEMP
	WE_INFO="`cat $WE_INFO`"
	return $rtn		
}

function wepurge {	# purges all cache
	if test "a$1" == "a" ; then
		rm $WE_DIR/*
	else
		wevars $1

		rm "$WE_FILE" "$WE_INFO" 2> /dev/null
	fi
	return $?
}

function weinject {
	wevars $1

	cat - 1> $WE_FILE ||
		return $?

	echo $WE_URL 1> $WE_INFO ||
		return $?

	return 0
}

function weinfo {
	wevar $1
	cat $WE_INFO 2> /dev/null
	return $?
}

#test "a$1" != 'a' &&	# BUGS!
#	$@

return 0


