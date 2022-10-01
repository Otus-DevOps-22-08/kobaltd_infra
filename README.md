# kobaltd_infra
kobaltd Infra repository

1)
ssh -i ~/.ssh/appuser -J appuser@<external bastion ip> appuser@<internal someinternalhost ip>

2)
cat ~/.ssh/config
Host github.com
 HostName github.com
 IdentityFile ~/.ssh/id_rsa

Host bastion
 HostName 51.250.2.240
 User appuser
 IdentityFile ~/.ssh/appuser

Host someinternalhost
 HostName 10.128.0.35
 User appuser
 IdentityFile ~/.ssh/appuser
 ProxyCommand ssh -W %h:%p bastion

3)
bastion_IP = 51.250.2.240
someinternalhost_IP = 10.128.0.35

4)
testapp_IP = 51.250.1.38
testapp_port = 9292

5)
Startup script
create_vm.sh
