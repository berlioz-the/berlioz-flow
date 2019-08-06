#!/bin/bash

source "${BASH_SOURCE%/*}/helpers/src-root-dir.sh"
pwd

BRANCH_NAME=$1
if [ -z $BRANCH_NAME ]; then
    echo "ERROR: Arguments missing"
    echo "Usage: berlioz-switch-branch.sh <branch-name>"
    exit 1
fi
echo "This is a command to switch to branch $BRANCH_NAME"

CURR_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
echo "Current Branch: $CURR_BRANCH_NAME"
if [ $CURR_BRANCH_NAME == "$BRANCH_NAME" ]; then
    echo "Already on branch: $CURR_BRANCH_NAME"
    exit 0
else
    echo "Switching to branch $BRANCH_NAME..."
    git checkout $BRANCH_NAME
    retval=$?
    if [ $retval -ne 0 ]; then
        echo "ERROR: Failed to switch branch"
        exit 1
    fi
fi
