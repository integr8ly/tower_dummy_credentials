#!/usr/bin/env bash

REMOTE_ORIGIN='origin'
REMOTE_UPSTREAM='dummy'
SYNC_FILES=(bootstrap.yml files/ roles/)
DUMMY_REPO_URL="git@github.com:integr8ly/tower_dummy_credentials.git"
RELEASE_TAG=${releasetag}
CREDENTIAL_CONFIG_FILE='CREDENTIAL_CONFIG.yml'
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
CHANGELOG_URL="https://raw.githubusercontent.com/integr8ly/tower_dummy_credentials/${RELEASE_TAG}/CHANGELOG.md"

function sanityCheck {
  # Validate RELEASE_TAG parameter
  if [ ${RELEASE_TAG} == "" ]
  then
    printf "Please specify a release tag: 'make sync releasetag=<release-tag>'\n"
    exit 1
  fi

  # Validate RELEASE_TAG format
  if [[ $RELEASE_TAG =~ ^release-([0-9]+).([0-9]+).([0-9]+)-?(.*)?$ ]]; then
    MAJOR_VERSION=${BASH_REMATCH[1]}
    MINOR_VERSION=${BASH_REMATCH[2]}
    PATCH_VERSION=${BASH_REMATCH[3]}
    LABEL_VERSION=${BASH_REMATCH[4]}
  else
    printf "Invalid release tag $RELEASE_TAG\n"
    exit 1
  fi
}

function setup {
  printf "Adding ${REMOTE_UPSTREAM} remote\n"
  git remote add ${REMOTE_UPSTREAM} ${DUMMY_REPO_URL}
  git fetch --all -p

  BASE_BRANCH=v$MAJOR_VERSION.$MINOR_VERSION
  git checkout -B ${BASE_BRANCH} ${REMOTE_ORIGIN}/${BASE_BRANCH}
  if [[ $? > 0 ]]
  then
    printf "Creating release base branch: ${BASE_BRANCH}\n"
    git checkout -b ${BASE_BRANCH}
  else
    read -p "Release branch ${REMOTE_ORIGIN}/${BASE_BRANCH} already exists. Are you sure you want to continue (y|n)?"
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
      printf "Aborting\n"
      exit 1
    fi
    printf "Release branch ${REMOTE_ORIGIN}/${BASE_BRANCH} exists. Checking out locally..\n"
    git checkout ${BASE_BRANCH}
  fi
}

function syncFiles {
  printf "Syncing files ${SYNC_FILES[*]}\n"
  for i in ${SYNC_FILES[@]}; do
    git checkout ${RELEASE_TAG} -- $i
  done
}

function decryptConfigFile {
  printf "\nDecrypting Credential Config File: ${CREDENTIAL_CONFIG_FILE}\n"
  ansible-vault decrypt ${CREDENTIAL_CONFIG_FILE} --ask-vault-pass
}

function updateConfigFile {
  curl ${CHANGELOG_URL}
  printf "\n=============================\n\nSTEPS\n1. Please review the above CHANGELOG output and ensure that any new variables listed are manually added to $(pwd)/CREDENTIAL_CONFIG.yml\n\nFor reference, check the following files:\nCREDENTIAL_CONFIG_TEMPLATE.yml: https://github.com/integr8ly/tower_dummy_credentials/blob/${RELEASE_TAG}/CREDENTIAL_CONFIG_TEMPLATE.yml\nVARIABLES.md: https://github.com/integr8ly/tower_dummy_credentials/blob/${RELEASE_TAG}/VARIABLES.md\n\n=============================\n"
  read -p "Perform the STEPS listed above. Continue (y|n)?"
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    printf "Aborting\n"
    exit 1
  fi
}

function bootstrap {
  printf "Running bootstrap process with updated configuration\n"
  ansible-playbook -i ./inventories/hosts bootstrap.yml --extra-vars='@CREDENTIAL_CONFIG.yml'
}

function commitChanges {
    printf "Adding new local files\n"
    git add .
    printf "Committing local changes\n"
    git commit -am "$1"
}

function pushChanges {
    printf "Pushing committed changes to branch ${REMOTE_ORIGIN}/${BASE_BRANCH}\n"
    git push ${REMOTE_ORIGIN} ${BASE_BRANCH}
}

function createReleaseTag {
    printf "Update release tag ${releasetag} on remote ${REMOTE_ORIGIN}\n"
    # Removing local reference to releasetag as this will conflict with upstream dummy cred repo release tag
    git tag -d ${releasetag}
    git tag ${releasetag}
    git push ${REMOTE_ORIGIN} ${releasetag}
}

function main {
  sanityCheck
  setup
  syncFiles
  decryptConfigFile
  updateConfigFile
  bootstrap
  commitChanges "Syncing repo with release ${releasetag}"
  pushChanges
  createReleaseTag
}

main
