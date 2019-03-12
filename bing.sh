#!/bin/bash
# Bing wallpaper downloader 2.0
# Copyright 2019 Tuoran (ArcticJieer) Zhang. All rights reserved.
# mailto:tigerjieer@163.com http://tuoran.fam.cx/

# Checks requirements
command -v wecache 1> /dev/null ||
	source wecache.sh	# I should alias wecache to wget. But that somehow doesn't work

function bingwallpapererror {
	echo "${FontRed}ERROR: $1${FontRev}"
	exit 1
}


# TODO: Create an automatic phrasing script
# Phrase arguments
new=1	# Which file to download
out=$HOME/.cache/wallpaper/wallpaper2.jpg	# Location to save file
sum='false'	# Save file?
set='true'	# Set background?
ccc=''	# Country code

for i in $@ ; do
	case $i in
		--help|-h)
			printf "Usage: $0 [--file=FILE] [--new] [--sum] [--help] [CC] \nDownloads and set latest wallpaper background from Bing homepage (www.bing.com).\n\tCC\tTwo letter country code to give to Bing\n\t--file=FILE\tDon't set, save to FILE instead\n\t--new\tAttempts the newest wallpaper, not current one\n\t--sum\tDon't download image, just summarize\n\t--help\tPrint this help and exit\nLimitations: \nOnly sets wallpaper with GNOME, but others still can use --file.\nCopyright (c) 2018-2019 Tuoran (ArcticJieer) Zhang. All rights reserved. Version 2.0\n"
			exit 0
			;;
		--new|-n)
			new=2
			;;
		--sum|-s)
			sum='true'
			set='false'
			;;
		--file=*)
		
			# TODO: Make look nicer 
			set='false'
			if test "a`echo $i | cut -c 8- - `" == a ; then
				echo "${FontRed}ERROR: No file specified${FontRev}"
			else
				out="`echo $i | cut -c 8- - `"
				echo $out | grep -qe '^/' - ||
					out="`pwd`/$out"
				mkdir -p "`basename $out`" 2> /dev/null
				test -d "$out" &&
					out="$out/wallpaper.$$.jpg"
			fi
			
			;;
		*)
			ccc="`echo $i | cut -c 1-2 - | tr '[[:upper:]]' '[[:lower:]]' `"
			;;
	esac
done

# Get index.html, and greps image file
src=`wecache "https://www.bing.com/?cc=$ccc" | \
	grep -oEe "/th[^\"\\&]+\.jpg" - | uniq - | \
	head -n $new - | \
	tail -n 1 -`

if test a$src == a ; then
	bingwallpapererror 'Internal error. Please file bug report'
	exit 1
fi

# Downloads image file
if test a$sum == 'afalse' ; then
	touch "$out" ||
		bingwallpapererror 'Cannot touch output file. Check permissions'

	wecache "http://www.bing.com/$src" 1> "$out"

	test a`head -c 1 "$out"` == a &&
		bingwallpapererror 'Download error'

fi

# Sets wallpaper
test a$set == 'atrue' &&
	gsettings set org.gnome.desktop.background picture-uri "file://$out"

echo "File `echo $src | cut -c 8- - ` Complete"

exit 0


