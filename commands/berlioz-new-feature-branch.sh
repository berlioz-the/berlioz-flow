#!/bin/bash

source "${BASH_SOURCE%/*}/helpers/src-root-dir.sh"
pwd

BRANCH_NAME=$1
if [ -z $BRANCH_NAME ]; then
    echo "ERROR: Arguments missing"
    echo "Usage: berlioz-new-branch.sh <new-branch-name>"
    exit 1
fi
echo "This is a command to create a new freature branch $BRANCH_NAME"


echo "Creating new branch $BRANCH_NAME from staging..."
git checkout -b $BRANCH_NAME staging
retval=$?
if [ $retval -ne 0 ]; then
    echo "ERROR: Failed to create branch."
    exit 4
fi

echo "Current branches:"
git branch -a

echo "Adding remote branch..."
git remote add origin/$BRANCH_NAME $BRANCH_NAME
retval=$?
if [ $retval -ne 0 ]; then
    echo "ERROR: Failed to add remote branch."
    exit 4
fi

git push origin $BRANCH_NAME