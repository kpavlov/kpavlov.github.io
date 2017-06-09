#!/usr/bin/env bash

mkdir -p themes
THEME=hugo-theme-ghostiumx
(cd themes && rm -rf ${THEME} && git clone --depth 1 --branch master --single-branch https://github.com/kpavlov/${THEME}.git &&  rm -rf ${THEME}/.git)
