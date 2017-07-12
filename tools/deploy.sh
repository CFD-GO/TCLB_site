#!/bin/bash

CMD=$1

if test -z "$CMD"
then
	echo "usage: deploy start|finish"
	exit -1;
fi

if ! test -z "$TRAVIS_BRANCH" 
then
	if ! test "$TRAVIS_BRANCH" == "master"
	then
		echo Travis-CI: Not on master branch
		CMD=none
	fi
fi


set -e
case $CMD in
start)
	rm -rf _site
	git clone https://$GH_TOKEN@github.com/CFD-GO/CFD-GO.github.io.git _site
	;;
finish)
	echo Deploying to GitHub Pages ...
	name=$(git --no-pager show -s --format="%aN")
	email=$(git --no-pager show -s --format="%ae")
	git --no-pager show -s --format="%s" >.msg
	echo Today\'s commit belongs to "$name" \("$email"\)
	echo Commit message:
	if ! test -f .msg
	then
		echo No commit message file
		exit -1
	fi
	cat .msg
	pushd _site
        git config user.email "$email"
	git config user.name "$name"
	git add -A
	git commit -F ../.msg | head -n 300
	git push
	;;
none)
	echo Not acting
	;;
*)
	echo Unknown command
	;;
esac

