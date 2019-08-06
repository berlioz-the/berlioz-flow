#!/bin/bash

source "${BASH_SOURCE%/*}/helpers/src-root-dir.sh"
pwd

$SRC_BRANCH_NAME='aaa'
$DST_BRANCH_NAME='bbb'
echo "Merging $SRC_BRANCH_NAME to $DST_BRANCH_NAME..."