#!/bin/bash

source "${BASH_SOURCE%/*}/helpers/src-root-dir.sh"
pwd

echo "This is a command to push current branch upstream"

CURR_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
echo "Current Branch: $CURR_BRANCH_NAME"

if [[ -z $(git status -s) ]]
then
    echo "No pending changes in $CURR_BRANCH_NAME. Good..."
else
    echo "ERROR: There are pending changes in $CURR_BRANCH_NAME. Cannot proceed."
    exit 3
fi

echo "Pulling changes from remote $CURR_BRANCH_NAME..."
git pull origin $CURR_BRANCH_NAME
retval=$?
if [ $retval -ne 0 ]; then
    echo "ERROR: Failed to pull the branch."
    exit 4
fi

echo "Pushing change to remote $CURR_BRANCH_NAME..."
git push origin $CURR_BRANCH_NAME
retval=$?
if [ $retval -ne 0 ]; then
    echo "ERROR: Failed to push the branch."
    exit 4
fi