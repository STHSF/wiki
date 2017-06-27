#!/bin/sh

echo "提交到主分支"
time=`date "+%Y-%m-%d-%H"`
echo "提交时间${time}"
git add . --all
git commit -am ${time}
git push origin master

echo "simiki编译"
simiki g

echo "提交到gh-pages分支"
fab deploy