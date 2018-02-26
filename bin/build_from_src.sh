#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

usage() {
    echo "./build_from_src.sh [--version <ARG> --rc <ARG>]"
    echo
    echo "Option:"
    echo "  -h, --help                 | show usage"
    echo "  -v, --version <ARG>        | set version"
    echo "  -rc, --rc <ARG>            | set RC number"
    echo
}

for opt in "$@"; do
  case "${opt}" in
    '-v'|'--version' )
	  if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
	    echo "$0: $1 option MUST have a version string as the argument" 1>&2
	    exit 1
	  fi
	  VERSION="$2"
	  shift 2
	  ;;
    '-rc'|'--rc' )
	  if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
	    echo "$0: $1 option MUST have a RC number as the argument" 1>&2
	    exit 1
	  fi
	  RC_NUMBER="$2"
	  shift 2
	  ;;
	'-h'|'--help' )
	  usage
	  exit 1
	  ;;
  esac
done

if [ -z "$VERSION" ]; then
  echo "Please input a version string (e.g., 0.5.0)"
  echo -n ">>"
  read VERSION
  echo
else
  echo "Version number is ${VERSION}"
  echo
fi

if [ -z "$RC_NUMBER" ]; then
  echo "Please input a RC number (e.g., rc3)"
  echo -n ">>"
  read RC_NUMBER
  echo
else
  echo "RC number is ${RC_NUMBER}"
  echo
fi

wget -e robots=off --no-check-certificate \
 -r -np --reject=html,txt,tmp -nH --cut-dirs=5 \
 https://dist.apache.org/repos/dist/dev/incubator/hivemall/${VERSION}-incubating-rc${RC_NUMBER}/

cd ${VERSION}-incubating-rc${RC_NUMBER}/

for f in `find . -type f -iname '*.sha1'`; do
  echo -n "Verifying ${f%.*} ... "
  sha1sum ${f%.*} | cut -f1 -d' ' | diff -Bw - ${f}
  if [ $? -eq 0 ]; then
    echo 'Valid'
  else 
    echo "SHA1 is Invalid: ${f}" >&2
    exit 1
  fi  
done
echo
for f in `find . -type f -iname '*.md5'`; do
  echo -n "Verifying ${f%.*} ... "
  md5sum ${f%.*} | cut -f1 -d' ' | diff -Bw - ${f}
  if [ $? -eq 0 ]; then
    echo 'Valid'
  else
    echo "MD5 is Invalid: ${f%.*}" >&2
	exit 1
  fi
done
echo
for f in `find . -type f -iname '*.asc'`; do
  gpg --verify ${f}
  if [ $? -eq 0 ]; then
    echo "GPG signature is correct: ${f%.*}"
  else
    echo "GPG signature is Invalid: ${f%.*}" >&2
	exit 1
  fi
  echo
done

unzip hivemall-${VERSION}-incubating-source-release.zip
cd hivemall-${VERSION}-incubating

mvn -Papache-release -Dgpg.skip=true clean install
