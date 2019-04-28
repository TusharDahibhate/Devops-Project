- infra.yml: Playbook for creating & deploying infrastructure for marqdown microservice. (Target: Deploy server)
<br> Usage: ```ansible-playbook -i inventory infra.yml -s --ask-vault-pass```

- main.yml: Playbook for setting up jenkins server, checkbox and iTrust, creating ec2 instances for checkbox & logstash. (Target: Jenkins server)
<br> Usage: ```ansible-playbook -i inventory main.yml -s --ask-vault-pass```

- logstash.yml: Playbook for deploying logstash server on an ec2 instance. Its inventory file is generated during 'main' playbook run. (Target: Logstash server)
<br> Usage: ```ansible-playbook -i logstash_inventory logstash.yml -s --ask-vault-pass```
