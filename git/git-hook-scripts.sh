# This script is meant to be on a server side hook: post-update
# the goal is to create a release tag each time a push occured on the master branch
#!/usr/bin/env bash

for ref in "$@"
do
    if [ "$ref" = "refs/heads/master" ]; then
        release_name="release-$(date +%F)"
        latest_commit_hash=$(git rev-parse refs/heads/master)

        git tag "$release_name" "$latest_commit_hash" 2>/dev/null
    fi
done