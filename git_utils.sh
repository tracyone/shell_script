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
   echo "Usage: `basename $0` [-d <tag name pattern>]"
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
# }}}

if [[ $# -eq 0 ]]; then
	GitUtilsShowHelp
fi

while getopts "d:" arg #选项后面的冒号表示该选项需要参数
do
		case $arg in
			 d )
				GitUtilsDeletTags "$OPTARG"
				;;
			* )
				GitUtilsShowHelp
				exit 1
				;;
		esac
done

# vim: set ft=sh fdm=marker foldlevel=0 foldmarker&: 
