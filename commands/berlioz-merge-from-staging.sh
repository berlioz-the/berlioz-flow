#!/bin/bash

source "${BASH_SOURCE%/*}/helpers/src-root-dir.sh"
pwd

echo "This is a command to merge MASTER to CURRENT branch"

CURR_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
echo "Current Branch: $CURR_BRANCH_NAME"
if [[ $CURR_BRANCH_NAME == "master" ]]; then
    echo "ERROR: Does not work on $CURR_BRANCH_NAME branch."
    exit 2
fi
if [[ $CURR_BRANCH_NAME == "staging" ]]; then
    echo "ERROR: Does not work on $CURR_BRANCH_NAME branch."
    exit 2
fi

if [[ -z $(git status -s) ]]
then
    echo "No pending changes in $CURR_BRANCH_NAME. Good..."
else
    echo "ERROR: There are pending changes in $CURR_BRANCH_NAME. Cannot proceed."
    exit 3
fi

echo "Attempting merge staging to $CURR_BRANCH_NAME"
git merge master
retval=$?
if [ $retval -ne 0 ]; then
    echo "ERROR: Failed to merge from master branch"
    exit 4
fi
echo "Merge completed successfully"
