# Final Milestone

### Team Members:
1. Shantanu Bhoyar - sbhoyar 
2. Akshay Saxena - asaxena5
3. Richa Dua - rdua2
4. Tushar Dahibhate - tdahibh

### In this milestone, we performed the following tasks:
1. Provisioned and configured a Jenkins server on a local VM using ansible.
2. Setup build jobs for 2 applications:
   * checkbox.io
   * iTrust
3. Deployed iTrust and checkbox.io on AWS EC2 instances.
4. Created a simple git hook to trigger a build when a push is made to the repository.
5. Used Redis for managing feature flags that can be used to turn off/on features on iTrust in production. 
6. Made improvements to the infrastructure of checkbox.io.
7. Special Component: Blue Gree Deployments & Logstash

# Tasks

![alt iTrust image](https://github.ncsu.edu/asaxena5/Devops-Project1/blob/master/imgs/Architecture.jpg)

## Provisioning and setting up of Jenkins Server

#### Rationale: 
Jenkins is a tool which is used to set up a continuous integration or a continuous delivery environment. As the goal of this milestone is to setup build jobs for 2 applications, setting up Jenkins using ansible is the first task that we performed.

#### Steps:
We used the Baker tool for VM provisioning. We created 2 VMs. One for ansible sever(192.168.33.11) and another for jenkins server(192.168.33.10).

We have created 2 roles for configuring Jenkins server and creating build jobs:
  * jenkins_install
  * jenkins_build_job

#### jenkins_install
jenkins_install contains 2 playbooks:
  * install.yml
      * This playbook installs java, git, maven, jenkins and starts the jenkins server.
  * main.yml 
      * This playbook will copy the initial password from /var/lib/jenkins/secrets/initialAdminPassword.
      * Create an admin user using groovy script and the jenkins_script module of ansible.
      * Complete the setup wizard using groovy script. 
      * Install different Jenkins plugins required.
      * Restarts the Jenkins server.

#### jenkins_build_job
jenkins_build_job contains a single playbook main.yml which create jenkins jobs for iTrust and checkbox.io


## Setting up iTrust

![alt iTrust image](https://github.ncsu.edu/asaxena5/Devops-Project1/blob/Milestone3/imgs/iTrust.png)
    
### Initial setups:

1. Navigate to the ansible-server directory and type vagrant up. This will create the ansible server.
2. Navigate to the jenkins-server directory and type vagrant up. This will create the jenkins server.
3. Login into the ansible-server using vagrant ssh.
4. Create a ssh key using ssh-keygen.
5. Login into the jenkins-server and copy the public key of the ansible-server into the authorized_keys.
6. On the ansible server, copy the private key into the /keys directory and name it jenkins-server_id_rsa.

### Setting up the secrets

var/secrets.yml file
The secrets file contains all the secrets necessary for the script to run. Following is the format of the file

```
---
jenkins_user: 
jenkins_password: 

mongo_secrets:
  user_password: 

os_environment_secrets:
  - key: MAIL_PASSWORD 
    value : 
  - key: MONGO_PASSWORD
    value: 
  - key: AWS_ACCESS_KEY_ID
    value: (Enter your AWS access key Id)
  - key: AWS_SECRET_ACCESS_KEY
    value: (Enter your AWS access key)
```

### Required files

Make sure the following files are present in the given locations:

- db.properties - roles/itrust_env/files
- email.properties - roles/itrust_env/files
- github_pro_rsa - roles/itrust_env/files - deploy key for tdahibh/Provisioning repository
- id_rsa_github - roles/itrust_env/files - deploy key for sbhoyar/iTrust2-v4 repository


#### email.properties template:

```
from # Email Id
username # User name
password # Password
host smtp.gmail.com
```

#### db.propertes template:
```
url jdbc:mysql://localhost:3306/iTrust2?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=EST&allowPublicKeyRetrieval=true
username root
```

### Execution of ansible playbook

#### Encryption

After the secrets have been set, encrypt them using the following command

```
$ cd ansible-server/vars
$ ansible-vault encrypt secrets.yml
```

#### Execution

```
$ ansible-playbook -i inventory --ask-vault-pass main.yml
```

### Steps for AWS:

- Create a key-pair by navigating to Network interfaces and name it deploy_key
- Place the downloaded key into the /home/jenkins folder of the jenkins server.
- Change the user to root:root and set the permission to 600

### Adding permissions to jenkins user

```
sudo visudo

```

Add the following line jenkins ALL=(ALL:ALL) ALL
	
### Server configuration

iTrust EC2 Production server configuration has been set to the following. This configuration will be found on Jenkins Server at the following location /home/vagrant/Provisioning/ansible-server/vars.yml.

This the Provision repository: https://github.ncsu.edu/tdahibh/Provisioning

```
---
  instance_type: t2.micro
  security_group: devops_deploy
  image: ami-028d6461780695a43
  region: us-east-1
  keypair: deploy_key
  count: 1
  instance_name: "Production-server"
```

### Deploying the iTrust server

1. Navigate to /jenkins-server/iTrust2-v4
2. Make any changes and commit those changes.
3. Push those changes to the bare repo by using the following command:

```
$ git push jenkins master
```

4. This action will trigger the git hook, which inturn triggers a Jenkins build. 
5. After the build is successful, 2 ansible playbooks will be triggered serially. 
6. The first ansible play book will create an ec2 instance. 
7. The second playbook will then configure and deploy iTrust on the ec2 instance.
8. Navigate to the ec2 dashboard to get the public ip of the iTrust server
9. Open the following url - http://[IP Address]:8080/iTrust2 to access iTrust


## Setting up checkbox.io

![alt nodejs image](https://github.ncsu.edu/asaxena5/Devops-Project1/blob/master/imgs/checkbox_webserv.jpg)

We have mirrored the [checkbox repository](https://github.com/chrisparnin/checkbox.io) in a private repository at: https://github.ncsu.edu/asaxena5/checkbox.io-private
The repository contains the Jenkinsfile and the mocha test suite.

### checkbox_env

For the role of setting up checkbox, we have 5 playbooks that are being called from the main.yml playbook viz. bash_config.yml, mongo_install.yml, nginx_install.yml, node_install.yml, repository_configuration.yml. The functions of each are:

 * bash_config.yml
   * This is used to setup the following environment variables required to run checkbox: MAIL_SMTP, MAIL_PASSWORD, MAIL_USER, APP_PORT, MONGO_IP, MONGO_USER, MONGO_PASSWORD
 
 * mongo_install.yml
    * Installs mongodb and creates a new user in the admin database with "root" role.
  
 * nginx_install.yml
    * Installs nginx and copies nginx.conf and default.conf (located in /etc/nginx/conf.d/) to setup proxy for web port 80 and upstream for port 3002.
  
 * node_install.yml
    * Installs node.js (version: 10.15.1) and npm (version: 6.4.1)
 
 * repository_configuration.yml
    * This playbook is used to clone the checkbox [private checkbox.io repository](https://github.ncsu.edu/asaxena5/checkbox.io-private).
    * Initiate a bare git repository
    * Create post-receive web hook to trigger jenkins build on git push.

To trigger a Jenkins build job:

Make changes in any of the repository files, perform (w/ sudo) git add, commit & push the changes to the deploy remote that points to the deploy/production.git folder. This will trigger Jenkins to create a build as mentioned in the post-receive hook in the bare repository created in deploy/production.git folder.

![alt checkbox image](https://github.ncsu.edu/asaxena5/Devops-Project1/blob/master/imgs/checkbox_job.jpg)

* A private key for cloning the [private checkbox.io repo](https://github.ncsu.edu/asaxena5/checkbox.io-private) is required to be copied to [ansible-server/roles/checkbox_env/templates/key](ansible-server/roles/checkbox_env/templates/key).

### Ansible Vault files:
* The passwords are stored in an ansible-vault created file @ ansible-server/vars/secrets.yml


```
---
jenkins_user: #######
jenkins_password: #######

mongo_secrets:
  user_password: #######

os_environment_secrets:
  - key: MAIL_PASSWORD
    value : #######
  - key: MONGO_PASSWORD
    value: "{{ mongo_secrets.user_password }}"

    
```
Please recreate a file with the above format and names of the variables.  
Update "os_environment_secrets: MAIL_PASSWORD" value (shown above) and "os_environment: MAIL_USER" value (in ansible-server/roles/checkbox_env/vars/main.yml) for using your own SMTP email.

### Infrastructure Component:

Ansible playbook for deploying Marqdown service on AWS/Kubernetes cluster 
* Spawns a kubernetes cluster with 3 nodes + 1 master node

![alt checkbox image](https://github.ncsu.edu/asaxena5/Devops-Project1/blob/master/imgs/Kuber.jpg)

- Cluster state managed in s3 bucket: ```s3://checkbox.io-nodejs-k8s-store``` (us-east-1 region)
- Docker image for marqdown-srv managed in ECR: ```135612764994.dkr.ecr.us-east-1.amazonaws.com/marqdown:v3```
- [Maqdown microservice](https://github.ncsu.edu/asaxena5/marqdown-srv)'s render api is exposed at ```/api/marqdown-srv/render```
- Marqdown micoservice's express port exposed: 8086

To run the playbook
- ```ansible-playbook -i inventory main.yml -s --ask-vault-pass```

To delete the cluster manually, run this from deploy-server:
- ```kops delete cluster --state=<store_name> <cluster_name> --yes```

To check the container instance, ssh into ec2 instance (kubernetes creates key on the VM, so direct ssh to dns will work)
- run ```sudo docker ps -a``` to get list of containers deployed
-	run ```sudo docker exec -it <containerid> ``` to interact with the container shell
  
To check kubernetes/aws deployments:
- ```kubectl get pods```
- ```kubectl get svc```


To scale up/down deployments:
- ```kubectl scale --replicas=1 deployment/my-app```


To get the log details of a pod:
- ```kubectl logs```

To delete deployment:
- ```kubectl delete services my-app```
- ```kubectl delete deployment my-app```

### Special Milestone - Logstash:

Logstash is used to collect the data from disparate sources and normalize the data into the destination of your choice.
The common use case of the log analysis is: debugging, performance analysis, security analysis, predictive analysis, IoT and logging. Log analysis helps to capture the application information and time of the service, that can be easy to analyze.

Filebeat is a log data shipper for local files. Filebeat agent will be installed on the server, which needs to monitor, and filebeat monitors all the logs in the log directory and forwards to Logstash. Filebeat works based on two components: prospectors/inputs and harvesters.

![alt checkbox image](https://github.ncsu.edu/asaxena5/Devops-Project1/blob/master/imgs/Logstash.png)

### Special Milestone - Blue Green Deployment:

We perfoprmed Blue-green deployment to reduce downtime and risk by running two identical production environments called Blue and Green. At any time, only one of the environments is live, with the live environment serving all production traffic. For this example, Blue is currently live and Green is idle. This technique can eliminate downtime due to app deployment. In addition, blue-green deployment reduces risk: if something unexpected happens with our new version on Green, we can immediately roll back to the last version by switching back to Blue.
[private blue-green repository](https://github.ncsu.edu/sbhoyar/Blue-Green)

![alt checkbox image](https://github.ncsu.edu/asaxena5/Devops-Project1/blob/master/imgs/bng.png)

### Milestone 3 + Special Milestone Screencast:
https://youtu.be/7apmPA5DueQ

### Complete Pipeline Video:
https://youtu.be/hWFzGFxZIRc

### Links to linked repositories:
- https://github.ncsu.edu/asaxena5/checkbox.io-private
- https://github.com/richadua/checkbox-env
- https://github.ncsu.edu/asaxena5/marqdown-srv
- https://github.ncsu.edu/asaxena5/itrust-fuzzer

### References:
  * https://www.tecmint.com/install-mongodb-on-ubuntu-18-04/
  * https://www.nginx.com/blog/setting-up-nginx/
