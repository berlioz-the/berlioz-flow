#!/bin/bash

source "${BASH_SOURCE%/*}/helpers/src-root-dir.sh"
pwd

exec_cmd "git rev-parse --abbrev-ref HEAD" \
    "ERROR: Failed to determine current branch." \
    CURR_BRANCH_NAME

print_header "This is a command to delete a freature branch ${CURR_BRANCH_NAME}" ""

if [[ ${CURR_BRANCH_NAME} == "master" ]]; then
    bail_with_error "ERROR: Does not work on ${CURR_BRANCH_NAME} branch."
fi
if [[ ${CURR_BRANCH_NAME} == "staging" ]]; then
    bail_with_error "ERROR: Does not work on ${CURR_BRANCH_NAME} branch."
fi

print_status "Switching to staging branch..."
exec_cmd "git checkout staging" \
    "ERROR: Failed to switch branch."

print_status "Deleting local branch ${CURR_BRANCH_NAME}..."
exec_cmd "git branch -d ${CURR_BRANCH_NAME}" \
    "ERROR: Failed to delete branch."

print_status "Deleting remote branch ${CURR_BRANCH_NAME}..."
exec_cmd "git push origin --delete ${CURR_BRANCH_NAME}" \
    "ERROR: Failed to delete branch."

print_status "Current branches:"
git branch -a

print_bold "Feature branch ${CURR_BRANCH_NAME} was deleted" ""


