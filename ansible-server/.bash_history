cd /vagrant/
;s
ls
clear
ls
cd /home/vagrant/
ls
cd /keys/
;s
ls
cd /home/vagrant/
clear
ansible-playbook -i inventory main.yml --vault-id @prompt
ansible-playbook -vvv -i inventory main.yml --vault-id @prompt
cat ~/
cd ~/
ls
cd /
ls
cd /keys/
ls
cat jenkins-server_id_rsa 
ls -l
logout
