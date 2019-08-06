#!/bin/bash

source "${BASH_SOURCE%/*}/helpers/src-root-dir.sh"
pwd

echo "This is a command to COMMIT and PUSH changes"

${MY_DIR}/berlioz-commit.sh
retval=$?
if [ $retval -ne 0 ]; then
    echo "ERROR: Failed to commit."
    exit 4
fi   

${MY_DIR}/berlioz-push-branch.sh
retval=$?
if [ $retval -ne 0 ]; then
    echo "ERROR: Failed to push."
    exit 4
fi   
