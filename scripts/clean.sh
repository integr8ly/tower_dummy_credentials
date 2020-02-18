#!/usr/bin/env bash

REMOTE=${REMOTE:-origin}
BRANCH=${branch:-credential_cleandown}
CLEAN_FILES=(VARIABLES.md README.md CHANGELOG.md CREDENTIAL_CONFIG_TEMPLATE.yml .github)

function clean {
    printf "Removing nonessential files and directories: ${CLEAN_FILES[*]}\n"
    for i in ${CLEAN_FILES[@]}; do
      rm -rf $i
    done
}

function createBranch {
    # check if the specified from branch already exists if it does check it out otherwise create it
    printf "Creating branch ${BRANCH} if it doesn't already exist\n"
    git checkout -b ${BRANCH}
    if [[ $? > 0 ]]
    then
    printf "ERROR: Branch ${BRANCH} already exists on remote ${REMOTE} or locally. Please either remove this branch or specify a different branch with 'make clean branch=<new-branch-name>'\n"
    exit 1
fi
}

function commitChanges {
    printf "Committing local changes: \"$1\" $2\n"
    git commit -m "$1" $2
}

function pushChanges {
    printf "Pushing committed changes to branch ${REMOTE}/${BRANCH}\n"
    git push ${REMOTE} ${BRANCH}
}

function main {
    createBranch
    clean
    commitChanges 'Removing nonessential files and directories' "${CLEAN_FILES[*]}"
    pushChanges
}

main