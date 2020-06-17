#!/bin/bash -ex
source ./jenkin-scripts/state.sh
# Only run for post merge
if [ "$IS_TARGET_REMOTE" = "1" ] && [ "$GIT_BRANCH" = "$BRANCH_DEV" ] ; then
    git fetch https://$USERPASS@github.com/$OFFICIAL_REPO/RAMCloud.git --tags
    MAJOR_MINOR=$(cat version)
    PATCH=$(git tag | grep $MAJOR_MINOR | grep $BRANCH_DEV | cut -d "." -f3 | cut -d "-" -f1 | sort -r | head -n1)
    NEXT_SEMVER=""
    if [ "$PATCH" = "" ]; then
       NEXT_SEMVER="$MAJOR_MINOR.0-$BRANCH_DEV"
    else
        count=0
        contains_tag=0
        max_attempts=5000
        LAST_SEMVER="$MAJOR_MINOR.$PATCH-$BRANCH_DEV"
        while [ "$contains_tag" != "1" ] && [ "$count" -lt "$max_attempts" ]
        do
            commit=$(git rev-parse HEAD~$count)
            contains_tag=$(git tag --contains $commit | grep $LAST_SEMVER | wc -l)
            count=$((count + 1))
        done
        count=$((count - 1))
        NEXT_SEMVER="$MAJOR_MINOR.$((PATCH + count))-$BRANCH_DEV"
    fi
    # Now that we have the next_semver we are save to tag the commit
    git tag -a -m "" $NEXT_SEMVER $LOCAL_COMMIT
    git remote -v
    git push https://$USERPASS@github.com/$OFFICIAL_REPO/RAMCloud.git $NEXT_SEMVER
    docker build . -f config/Dockerfile.deploy --target rc-coordinator --tag statelesstestregistry.azurecr.io/stateless/ramcloud/coordinator:$NEXT_SEMVER
    docker build . -f config/Dockerfile.deploy --target rc-server --tag statelesstestregistry.azurecr.io/stateless/ramcloud/server:$NEXT_SEMVER
    docker push statelesstestregistry.azurecr.io/stateless/ramcloud/coordinator:$NEXT_SEMVER
    docker push statelesstestregistry.azurecr.io/stateless/ramcloud/server:$NEXT_SEMVER
fi
