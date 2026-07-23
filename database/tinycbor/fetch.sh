#!/bin/bash

#COMMIT_ID="$1"
COMMIT_ID=9441b2ca882f95849c93de03f2c754196db13154
REPO_URL="https://github.com/intel/tinycbor.git"

git clone "$REPO_URL" code
if [ $? -ne 0 ]; then
    echo "Failed to clone repository. Exiting."
    exit 1
fi

if [ -n "$COMMIT_ID" ]; then
    cd code
    git checkout "$COMMIT_ID"
    if [ $? -ne 0 ]; then
        echo "Failed to checkout to commit $COMMIT_ID. Exiting."
        exit 1
    fi
    cd ..
fi

mkdir latest
mv code latest

cp ./build.sh ./lib.toml latest
