#!/bin/bash

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
printf "Installing the required packages to pass the test: "
if ! { sudo apt install -y apt-transport-https ca-certificates 2>&1 || echo E: upgrade failed; } | grep -q '^[WE]:'; then
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
printf "All done\n"
exit 0
