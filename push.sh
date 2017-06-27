#!/bin/sh

time=`date "+%Y-%m-%d-%H"`

git add . --all
git commit -am ${time}
git push origin master

simiki g

fab deploy