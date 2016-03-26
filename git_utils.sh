#!/bin/bash
# author:tracyone
# git utils
# date:2016-03-20
# usage:

source $(dirname $(which git_utils))/script_libs/common.sh

# Function definition {{{
# GitUtilsShowHelp:
# argument:none
function GitUtilsShowHelp()
{
   echo "Usage: `basename $0` [-d <tag name pattern>] [-i]"
   exit 3;
}

# GitUtilsDeletTags
# argument:tag_pattern
function GitUtilsDeletTags()
{
	local tag=$(git tag)
	local pattern="$1"
	echo "pattern is ${pattern}"
	if [[ ${tag} == "" ]]; then
		echo -e "No tag found\n"
		exit 0;
	fi
	for i in ${tag}; do
		if [[ $i =~ ${pattern} ]]; then
			GetYn "delete remote and local tag:$i " "git push origin :refs/tags/$i" "git tag -d $i" 
		fi
	done
	echo -e "Now we have following tags:"
	git tag

}

# git init process
function GitUtilsInit()
{
	local remote_url=""
	if [[ ! -d .git ]]; then
		git init .
	fi
	if [[ ! -f .gitignore  ]]; then
		vim -p .gitignore readme.md
	fi
	git add .gitignore readme.md
	git add .
	git commit 
	remote_url=`git config remote.origin.url` || read -p "Please input the remote repo url " remote_url
	if [[ remote_url != "" ]]; then
		git remote add origin ${remote_url}
	fi
}

# }}}

if [[ $# -eq 0 ]]; then
	GitUtilsShowHelp
fi

while getopts "d:i" arg #选项后面的冒号表示该选项需要参数
do
		case $arg in
			 d )
				GitUtilsDeletTags "$OPTARG"
				;;
			 i )
				GitUtilsInit "$OPTARG"
				;;
			* )
				GitUtilsShowHelp
				exit 1
				;;
		esac
done

# vim: set ft=sh fdm=marker foldlevel=0 foldmarker&: 
