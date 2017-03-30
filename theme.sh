#!/usr/bin/env bash

mkdir -p themes
(cd themes && rm -rf hugo-theme-ghostiumx && git clone --depth 1 --branch master --single-branch https://github.com/kpavlov/hugo-theme-ghostiumx.git)
