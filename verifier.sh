#!/bin/bash
prefix=$(cat $2)
newFile=$(cat $1)
newFilepath=$1
if [[ ${#prefix} > ${#newFile} ]]; then
    prefix=$(cat $1)
    newFile=$(cat $2)
    newFilepath=$2
fi
if ! [[ "$newFile" =~ ^$prefix* ]]; then
    echo "falseA"
    exit 0
fi
tmp=${newFile:${#prefix}:${#newFile}}
if ! [[ `echo $tmp` =~ ^[a-f0-9]{8}G(?:[0-3][0-9])+$ ]]; then
    echo "falseB"
    exit 0
fi
tmp=$(md5sum $newFilepath)
if ! [[ ${tmp:0:1} == "0" ]]; then
    echo "falseC"
    exit 0
fi

echo "true"