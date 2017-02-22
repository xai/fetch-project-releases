#!/bin/bash
#
# MIT License
#
# Copyright (c) 2017 Olaf Lessenich
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

###################################################################################
# CONFIGURATION                                                                   #
#                                                                                 #
# You have to register an API token first!                                        #
# Please see                                                                      #
# https://help.github.com/articles/creating-an-access-token-for-command-line-use/ #
# on how to do this.                                                              #
#                                                                                 #
# Set the value of TOKEN in the environment to the appropriate value.             #
###################################################################################

CODE_BASE_DIR="/tmp/src"
NUM=30
DRY_RUN=false
CLONE=false

if [ -z "$TOKEN" ]
then
	echo "You have to register an API token and adjust the value of TOKEN in your environment accordingly."
	echo "See https://help.github.com/articles/creating-an-access-token-for-command-line-use/ on how to register a token."
	echo
	echo "If you have a valid API token, call this script like this:"
	echo "\$ TOKEN=\"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\" $0"
	exit 1
fi

usage () {
	echo >&2
	echo >&2 "Usage: $0 [-d] [-n number of projects] [-o output directory]"
	echo >&2 "   -c: clone. Clone github repositories instead of fetching releases"
	echo >&2 "   -d: dry-run. Do not download anything"
	echo >&2 "   -n number: Number of projects that should be fetched"
	echo >&2 "   -o path: Path to output directory"
	echo >&2
}

# Reset in case getopts has been used previously in the shell.
OPTIND=1

while getopts "h?cdn:o:" opt; do
	case "$opt" in
		h|\?)
			usage
			exit 0
			;;
		c)  CLONE=true
			;;
		d)  DRY_RUN=true
			;;
		n)  NUM=$OPTARG
			;;
		o)  CODE_BASE_DIR=$OPTARG
			;;
	esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

projects=0
releases=0
page=1

while [ $projects -lt $NUM ]
do
	for tags_url in \
		$(curl -sH "Authorization: token ${TOKEN}" "https://api.github.com/search/repositories?q=language:java&sort=stars&order=desc&page=${page}" 2>/dev/null \
		| egrep '[[:space:]]*"tags_url":' \
		| sed 's/[[:space:]]\+\"tags_url\": \"\([^\"]\+\)\".*,/\1/g')
	do
		read user project <<< \
			$(echo "$tags_url" \
			| sed 's/https:\/\/api\.github\.com\/repos\/\([^\/]\+\)\/\([^\/]\+\).*/\1 \2/g')
		codedir=${CODE_BASE_DIR}/${user}/${project}
		if [ "$DRY_RUN" = false ]
		then
			mkdir -p $codedir
		fi

		if [ "$CLONE" = true ]
		then
			# clone repository
			if [ "$DRY_RUN" = false ]
			then
				if [ -d ${codedir}/.git ]
				then
					echo "Updating: ${user}/${project} (https://github.com/${user}/${project})"
					curdir=${PWD}
					cd ${codedir}
					git pull
					cd ${curdir}
				else
					echo "Cloning: ${user}/${project} (https://github.com/${user}/${project})"
					git clone https://github.com/${user}/${project} ${codedir}
				fi
			fi
		else
			# fetch all releases
			echo "Retrieving releases for: ${user}/${project} (https://github.com/${user}/${project})"
			for release_url in $(curl -sH "Authorization: token ${TOKEN}" "${tags_url}" 2>/dev/null \
				| egrep '[[:space:]]*"tarball_url":' \
				| sed 's/[[:space:]]*\"tarball_url\": \"\([^\"]\+\)\".*/\1/')
			do
				release=$(echo "$release_url" | sed 's/.*\///')
				target="${codedir}/${release}.tar.gz"
				echo "storing release ${release} as ${target}"
				if [ "$DRY_RUN" = false ]
				then
					curl -s -L -o $target -C - "$release_url"
				fi
				let releases+=1
			done
		fi
		let projects+=1
		echo

		if [ $projects -eq $NUM ]
		then
			break;
		fi
	done

	let page+=1
done

if [ "$CLONE" = true ]
then
	echo "${projects} projects cloned."
else
	echo "${releases} releases of ${projects} projects downloaded."
fi

