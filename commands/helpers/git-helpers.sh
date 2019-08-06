#!/bin/bash

git_commit() {
    local COMMIT_MESSAGE=$1

    print_status "This is a command to commit changes"

    local CURR_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
    print_status "Current Branch: $CURR_BRANCH_NAME"

    if [[ -z $(git status -s) ]]; then
        echo "ERROR: No pending changes in $CURR_BRANCH_NAME..."
        exit 3
    fi

    print_status "Adding to index..."
    exec_cmd "git add -A" \
        "ERROR: Failed to add to index"

    if [ -z "$COMMIT_MESSAGE" ]; then 
        DEFAULT_COMMIT_MESSAGE="Auto Commit"
        read -p "Commit message ($DEFAULT_COMMIT_MESSAGE): " COMMIT_MESSAGE
        COMMIT_MESSAGE=${COMMIT_MESSAGE:-$DEFAULT_COMMIT_MESSAGE}
    fi

    CHANGES=$(git status -s -u)
    AREA_CHANGES=$(echo $CHANGES | awk '{$1=$1};1' | cut -d' ' -f2 | awk -F "/" '{print $1}' | sort -u)
    COMMIT_MESSAGE="$(printf "$COMMIT_MESSAGE\n\nModified Areas:\n$AREA_CHANGES\n\nFiles Changed:\n$CHANGES")"

    print_status "Committing..."
    exec_cmd "git commit -m \"$COMMIT_MESSAGE\"" \
        "ERROR: Failed to pull the branch."
}

git_push()
{
    local CURR_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
    print_status "Current Branch: ${CURR_BRANCH_NAME}"

    print_status "Pulling changes from remote ${CURR_BRANCH_NAME}..."
    exec_cmd "git pull origin ${CURR_BRANCH_NAME}" \
        "ERROR: Failed to pull branch ${CURR_BRANCH_NAME} ."

    print_status "Push changes to remote..."
    exec_cmd "git push origin ${CURR_BRANCH_NAME}" \
        "ERROR: Failed to push branch ${CURR_BRANCH_NAME}."
}
