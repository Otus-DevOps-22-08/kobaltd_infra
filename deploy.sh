#!/bin/bash

printf "Install git: "
if ! { sudo apt install -y git 2>&1 || echo E: upgrade failed; } | grep -q '^[WE]:'; then
    printf "success\n"
    printf "    Check of Install git: "
    if  git --version 2>&1 | grep -q 'git\sversion'; then
        printf "success\n"
    else
        printf "failure\n"
        exit 1;
    fi
else
    printf "failure\n"
    exit 1;
fi
printf "Clone source over git: "
git clone -b monolith https://github.com/express42/reddit.git
if test -f ./reddit/config.ru; then
    printf "success\n"
    printf "    Build source: "
    cd ./reddit
    bundle install
    printf "success\n"
    printf "    Check of build: "
    if  puma -V 2>&1 | grep -q 'puma\sversion'; then
        printf "success\n"
        printf "    Start of build: "
        puma -d
        if  ps ax | grep -q 'puma'; then
            printf "success\n"
        else
            printf "failure\n"
            exit 1;
        fi
    else
        printf "failure\n"
        exit 1;
    fi
else
    printf "failure\n"
    exit 1;
fi
printf "All done\n"
exit 0
