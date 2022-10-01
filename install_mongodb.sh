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
printf "All done\n"
exit 0
