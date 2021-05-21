#!/bin/bash
time=$(date "+%Y-%m-%d %H:%M:%S")

if [ "$1" == "" ]
then 
	set "${time} autopush"
fi
echo "$1"
docsify-auto-sidebar -d .
git status
git add .
git commit -m "$1"
git push
echo "==========提交成功=========="