#!/bin/bash

printf "Add key to apt of repository: "
if wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add - | grep -q '^OK'; then
    printf "success\n"
else
    printf "failure\n"
    exit 1;
fi
printf "Add repository to apt: "
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list 2>&1> /dev/null
if grep -q 'repo\.mongodb\.org' /etc/apt/sources.list.d/mongodb-org-4.2.list; then
    printf "success\n"
else
    printf "failure\n"
    exit 1;
fi
printf "Find update for system: "
if ! { sudo apt update 2>&1 || echo E: update failed; } | grep -q '^[WE]:'; then
    printf "success\n"
else
    printf "failure\n"
    exit 1;
fi
printf "Do upgrade installed packetges: "
if ! { sudo apt upgrade -y 2>&1 || echo E: upgrade failed; } | grep -q '^[WE]:'; then
    printf "success\n"
else
    printf "failure\n"
    exit 1;
fi
printf "Install Ruby: "
if ! { sudo apt install -y ruby-full ruby-bundler build-essential 2>&1 || echo E: upgrade failed; } | grep -q '^[WE]:'; then
    printf "success\n"
    printf "    Check of Install Ruby: "
    if ruby -v 2>&1 | grep -q 'ruby'; then
        printf "success\n"
    else
        printf "failure\n"
        exit 1;
    fi
    printf "    Check of Install Bundler: "
    if bundler -v 2>&1 | grep -q 'Bundler'; then
        printf "success\n"
    else
        printf "failure\n"
        exit 1;
    fi
else
    printf "failure\n"
    exit 1;
fi
printf "Install MongoDB: "
if ! { sudo apt install -y mongodb-org 2>&1 || echo E: upgrade failed; } | grep -q '^[WE]:'; then
    printf "success\n"
    printf "    Check of Install MongoDB: "
    if  mongod --version 2>&1 | grep -q 'db\sversion'; then
        printf "success\n"
        printf "        Start MongoDB: "
        sudo systemctl start mongod > /dev/null 2>&1
        if  sudo systemctl status mongod | grep -q 'running'; then
            printf "success\n"
            printf "             Enable startup MongoDB on boot: "
            sudo systemctl enable mongod > /dev/null 2>&1
            if  sudo systemctl status mongod | grep -q 'mongod\.service;\senabled;'; then
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
else
    printf "failure\n"
    exit 1;
fi
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
