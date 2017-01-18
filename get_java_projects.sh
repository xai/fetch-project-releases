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
#                                                                                 #
# Also set CODE_BASE_DIR in this script to something meaningful.                  #
# This is where the code is stored.                                               #
###################################################################################

CODE_BASE_DIR="/tmp/src/"

if [ -z "$TOKEN" ]
then
	echo "You have to register and API token and adjust the value of TOKEN in your environment accordingly."
	echo "See https://help.github.com/articles/creating-an-access-token-for-command-line-use/ on how to do this."
	echo
	echo "E.g., call this script like this:"
	echo "\$ TOKEN=\"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\" $0"
	exit 1
fi

for tags_url in \
	$(curl -H "Authorization: token ${TOKEN}" 'https://api.github.com/search/repositories?q=language:java&sort=stars&order=desc' 2>/dev/null \
	| egrep '[[:space:]]*"tags_url":' \
	| sed 's/[[:space:]]\+\"tags_url\": \"\([^\"]\+\)\".*,/\1/g')
do
	read user project <<< \
		$(echo "$tags_url" \
		| sed 's/https:\/\/api\.github\.com\/repos\/\([^\/]\+\)\/\([^\/]\+\).*/\1 \2/g')
	echo $tags_url
	echo "Retrieving releases for: ${user}/${project}"
	codedir=${CODE_BASE_DIR}/${user}/${project}
	mkdir -p $codedir
	for release_url in $(curl -H "Authorization: token ${TOKEN}" "${tags_url}" 2>/dev/null \
		| egrep '[[:space:]]*"tarball_url":' \
		| sed 's/[[:space:]]*\"tarball_url\": \"\([^\"]\+\)\".*/\1/')
	do
		echo $release_url
		release=$(echo "$release_url" | sed 's/.*\///')
		echo "Retrieving release ${release}"
		wget -q -O ${codedir}/${release}.tar.gz "$release_url"
	done
	echo
done
