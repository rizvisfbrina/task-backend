#!/bin/bash

if [ "$1" = -h ]
then
    echo "$0 usage:"
    echo "-t) specify type"
    echo "-o) specify output file"
    echo "-h) show help"
    echo "example: sh main.sh /var/log/nginx/error.log -t text -o output.txt"
    exit 0
else
    file="$1"
fi

while test $# -gt 1; do
   case "$2" in
     -t)
        shift
        type=$2
        shift
        ;;
     -o)
        shift
        out=$2
        shift
        ;;
   esac
done

if [ "$type" = "json" ]
then
    res=$(echo -n "["
    while read -r day hms info err; do
    	if (( nr++ )); then         
           echo ","     
    	fi
    	jq -cn --arg date "$day $hms" --arg info "$info" --arg error "$err" '{date:$date, info:$info, error:$error}'
    done < $file
    echo "]"
    )
    echo "$res"
          
    log="$(basename ${file%.*}).json"
else
    res="`cat $file`"
    log="$(basename ${file%.*}).txt"
fi

if [ -z $out ]
then
    out=$(pwd)/$log
fi

echo "$res" > $out
