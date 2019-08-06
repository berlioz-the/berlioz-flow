#!/bin/bash

source "${BASH_SOURCE%/*}/helpers/src-root-dir.sh"
pwd

echo "This is a command to commit changes"

CURR_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
echo "Current Branch: $CURR_BRANCH_NAME"

if [[ -z $(git status -s) ]]
then
    echo "ERROR: No pending changes in $CURR_BRANCH_NAME. Good..."
    exit 3
fi

echo "Adding to index..."
git add -A
retval=$?
if [ $retval -ne 0 ]; then
    echo "ERROR: Failed to add to index"
    exit 4
fi

COMMIT_MESSAGE=$1
if [ -z "$COMMIT_MESSAGE" ]; then 
    DEFAULT_COMMIT_MESSAGE="Auto Commit"
    read -p "Commit message ($DEFAULT_COMMIT_MESSAGE): " COMMIT_MESSAGE
    COMMIT_MESSAGE=${COMMIT_MESSAGE:-$DEFAULT_COMMIT_MESSAGE}
fi

CHANGES=$(git status -s -u)
AREA_CHANGES=$(echo $CHANGES | awk '{$1=$1};1' | cut -d' ' -f2 | awk -F "/" '{print $1}' | sort -u)
COMMIT_MESSAGE="$(printf "$COMMIT_MESSAGE\n\nModified Areas:\n$AREA_CHANGES\n\nFiles Changed:\n$CHANGES")"

echo "Committing..."
git commit -m "$COMMIT_MESSAGE"
retval=$?
if [ $retval -ne 0 ]; then
    echo "ERROR: Failed to pull the branch."
    exit 4
fi   

