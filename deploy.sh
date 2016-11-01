#!/usr/bin/env bash

REPO=${GIT_DEPLOY_REPO:-git@github.com:kpavlov/kpavlov.github.io.git}

rm -rf public
git clone --branch master --depth 1 --single-branch ${REPO} public

rm -rf public/*

(cd themes && git clone --depth 1 --branch master --single-branch git@github.com:kpavlov/hugo-theme-ghostiumx.git)

commit_title=`git log -n 1 --format="%s" HEAD`

hugo

#default commit message uses last title if a custom one is not supplied
if [[ -z $commit_message ]]; then
    commit_message="Publish: $commit_title"
fi

(
    cd public &&
    git config user.name "Konstantin Pavlov" &&
    git config user.email git@konstantunpavlov.net &&
    git add . &&
    git commit -m "$commit_message" &&
    git gc &&
    git status &&
    git push origin master
)
