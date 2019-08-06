#!/bin/bash

###
###
###
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

###
###
###
git_push()
{
    local CURR_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    print_status "Pushing ${CURR_BRANCH}..."

    print_status "Pulling changes from remote ${CURR_BRANCH}..."
    exec_cmd "git pull origin ${CURR_BRANCH}" \
        "ERROR: Failed to pull branch ${CURR_BRANCH} ."

    print_status "Push changes to remote ${CURR_BRANCH}..."
    exec_cmd "git push origin ${CURR_BRANCH}" \
        "ERROR: Failed to push branch ${CURR_BRANCH}."
}

###
###
###
git_merge_from()
{
    local OTHER_BRANCH=$1

    local CURR_BRANCH=
    exec_cmd "git rev-parse --abbrev-ref HEAD" \
        "ERROR: Failed to determine current branch." \
        CURR_BRANCH

    if [[ "${CURR_BRANCH}" == "${OTHER_BRANCH}" ]]; then
        echo "ERROR: Cannot merge to self."
        exit 3
    fi

    print_status "Merging ${OTHER_BRANCH} to ${CURR_BRANCH}..."

    exec_cmd "git status -s" \
        "ERROR: Failed to status." \
        result
    if [[ ! -z "${result}" ]]; then
        echo "ERROR: There are pending changes in ${CURR_BRANCH}. Cannot proceed."
        exit 3
    fi

    print_status "Merging ${OTHER_BRANCH} to ${CURR_BRANCH}..."
    exec_cmd "git merge ${OTHER_BRANCH}" \
        "ERROR: Failed to merge ${OTHER_BRANCH} to ${CURR_BRANCH}"

    CONFLICTS=$(git ls-files -u | wc -l)
    if [[ "${CONFLICTS}" -gt 0 ]]; then
        echo "ERROR: There is a merge conflict. Please resolve the conflict manually."
        exit 1
    fi

    print_status "Merge completed successfully"
}


###
###
###
git_merge_to()
{
    local OTHER_BRANCH=$1

    local CURR_BRANCH=
    exec_cmd "git rev-parse --abbrev-ref HEAD" \
        "ERROR: Failed to determine current branch." \
        CURR_BRANCH

    if [[ "${CURR_BRANCH}" == "${OTHER_BRANCH}" ]]; then
        echo "ERROR: Cannot merge to self."
        exit 3
    fi

    print_status "Merging ${CURR_BRANCH} to ${OTHER_BRANCH}..."

    exec_cmd "git status -s" \
        "ERROR: Failed to status." \
        result
    if [[ ! -z "${result}" ]]; then
        echo "ERROR: There are pending changes in ${CURR_BRANCH}. Cannot proceed."
        exit 3
    fi

    print_status "Switching to ${OTHER_BRANCH}..."
    exec_cmd "git checkout ${OTHER_BRANCH}" \
        "ERROR: Failed to switch to ${OTHER_BRANCH}"

    git_merge_from ${CURR_BRANCH}

    print_status "Switching back to ${CURR_BRANCH}..."
    exec_cmd "git checkout ${CURR_BRANCH}" \
        "ERROR: Failed to checkout ${CURR_BRANCH}"
}


###
###
###
git_merge_to_and_push()
{
    local OTHER_BRANCH=$1

    local CURR_BRANCH=
    exec_cmd "git rev-parse --abbrev-ref HEAD" \
        "ERROR: Failed to determine current branch." \
        CURR_BRANCH

    if [[ "${CURR_BRANCH}" == "${OTHER_BRANCH}" ]]; then
        echo "ERROR: Cannot merge to self."
        exit 3
    fi

    print_status "Merging ${CURR_BRANCH} to ${OTHER_BRANCH}..."

    exec_cmd "git status -s" \
        "ERROR: Failed to status." \
        result
    if [[ ! -z "${result}" ]]; then
        echo "ERROR: There are pending changes in ${CURR_BRANCH}. Cannot proceed."
        exit 3
    fi

    print_status "Switching to ${OTHER_BRANCH}..."
    exec_cmd "git checkout ${OTHER_BRANCH}" \
        "ERROR: Failed to switch to ${OTHER_BRANCH}"

    git_merge_from ${CURR_BRANCH}

    git_push

    print_status "Switching back to ${CURR_BRANCH}..."
    exec_cmd "git checkout ${CURR_BRANCH}" \
        "ERROR: Failed to checkout ${CURR_BRANCH}"

}