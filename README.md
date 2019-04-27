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
7. Special Component: 

# Tasks

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

### Steps
We have created 2 roles for setting up iTrust environment and build jobs:
  * mysql
  * itrust_env
  
#### mysql
- This role basically installs and configures mysql on the jenkins server. 

#### itrust_env
itrust_env contains 3 playbooks:
  * setup.yml
    * Installs google chrome.
    * Sets timezone to America/New_York
    * Configures git email, username, ssh key.
    
 * git_tasks.yml
    * This playbook clones the source repository from GitHub.
    * Creates a bare repository which serves as the remote for the cloned repository.
    * Congigures git push options.
    * Copies the post receive hook to the bare repository.     
 
 * jenkins_tasks.yml
    * Copies the Jenkinsfile, db.properties, email.properties to the cloned repo.
    * Configures Jenkins with database and email credentials. 

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

* A private key for cloning the [private checkbox.io repo](https://github.ncsu.edu/asaxena5/checkbox.io-private) is required to be copied to [ansible-server/roles/checkbox_env/templates/key](ansible-server/roles/checkbox_env/templates/key).

### Screencast:
https://www.youtube.com/watch?v=sLBIyCZKpxE

### References:
  * https://www.tecmint.com/install-mongodb-on-ubuntu-18-04/
  * https://www.nginx.com/blog/setting-up-nginx/
