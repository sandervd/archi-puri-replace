#!/bin/bash
dir_prefix=$(head -n1 filelist.txt | cut -d '/' -f1)
abb=$(cat html_report/$1 | tidy 2> /dev/null | xmllint --html --recover --xpath '//table/*/tr/td/*[contains(text(),"eira:")]/text()' - 2> /dev/null | sed '/^$/d')
namespace="http://data.europa.eu/dr8/"
if [ -n "$abb" ]
then
	filename=$(echo $1 | cut -d '/' -f3)
	abb_full_uri=$namespace$(echo $abb | cut -d ':' -f2 )
	echo "sed -i 's=../elements/$filename=$abb_full_uri=g' \$1"
fi
exit 0
