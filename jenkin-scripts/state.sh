#!/bin/bash -ex
export OFFICIAL_REPO=BeStateless
export BRANCH_DEV=dev
export BRANCH_RC=rc
export BRANCH_MASTER=master

export REMOTE_COMMIT=$(git rev-parse origin/$GIT_BRANCH)
export LOCAL_COMMIT=$(git rev-parse HEAD)
export MM_VERSION=$(cat version)
export CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

export IS_TARGET_REMOTE=$(git remote -v | grep origin | grep $OFFICIAL_REPO | head -n1 | wc -l)
