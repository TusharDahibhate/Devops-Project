- infra.yml: Playbook for creating a microservice infrastructure for marqdown/checkbox
<br> Target: Deploy server
<br> Usage: ```ansible-playbook -i inventory infra.yml -s --ask-vault-pass```

- main.yml: Playbook for setting up jenkins server, checkbox and iTrust.
<br> Target: Jenkins server
<br> Usage: ```ansible-playbook -i inventory main.yml -s --ask-vault-pass```

- logstash.yml: Playbook for deploying logstash server on an ec2 instance. Its inventory file is generated during 'main' playbook run.
<br> Target: Logstash server
<br> Usage: ```ansible-playbook -i logstash_inventory logstash.yml -s --ask-vault-pass```
