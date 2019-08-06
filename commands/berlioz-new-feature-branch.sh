#!/bin/bash

source "${BASH_SOURCE%/*}/helpers/src-root-dir.sh"
pwd

BRANCH_NAME=$1
if [ -z $BRANCH_NAME ]; then
    echo "ERROR: Arguments missing"
    echo "Usage: berlioz-new-branch.sh <new-branch-name>"
    exit 1
fi

print_header "This is a command to create a new freature branch $BRANCH_NAME" ""

BRANCH_NAME="dev-${BRANCH_NAME}"

print_status "Creating new branch $BRANCH_NAME from staging..."
exec_cmd "git checkout -b ${BRANCH_NAME} staging" \
    "ERROR: Failed to create branch."

# print_status "Associating remote branch..."
# exec_cmd "git branch -u origin/${BRANCH_NAME}" \
#     "ERROR: Failed to track remote branch."

print_status "Current branches:"
exec_cmd "git branch -a" \
    "ERROR: Failed to get git branches."

# print_status "Pulling changes from remote ${BRANCH_NAME}..."
# exec_cmd "git pull origin ${BRANCH_NAME}" \
#     "ERROR: Failed to pull branch."

print_status "Push changes to remote..."
exec_cmd "git push origin ${BRANCH_NAME}" \
    "ERROR: Failed to push branch."

print_bold "Feature branch ${BRANCH_NAME} was created" ""
