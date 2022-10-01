#!/bin/bash

yc compute instance create --name reddit-app --hostname reddit-app --memory=4 --cores=2 --core-fraction=5 --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 --metadata serial-port-enable=1 --ssh-key ~/.ssh/appuser.pub
IP_EXT=$(yc compute instance get --name reddit-app --format json | jq -r '.network_interfaces[].primary_v4_address.one_to_one_nat.address')
sed '/${IP_EXT}/d' ~/.ssh/known_hosts
sleep 120
ssh-keyscan -4 -t ed25519 ${IP_EXT} >> ~/.ssh/known_hosts
scp ~/Документы/OTUS/kobaltd_infra/startup.sh yc-user@${IP_EXT}:~/
ssh yc-user@${IP_EXT} '~/startup.sh'
