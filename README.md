# Configuration Management and Build Milestone 1

### Team Members:
1. Shantanu Bhoyar - sbhoyar 
2. Akshay Saxena - asaxena5
3. Richa Dua - rdua2
4. Tushar Dahibhate - tdahibh

### In this milestone, we performed the following tasks:
1. Provisioned and configured a Jenkins server on a remote VM using ansible.
2. Setup build jobs for 2 applications:
   * checkbox.io
   * iTrust
3. Created a test script to start and stop the checkbox.io service on the server
4. Created a simple git hook to trigger a build when a push is made to the repository.

### Tools used:
1. Ansible
2. Jenkins 
3. Git
4. Baker
5. Maven
6. NodeJS

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
For the role of setting up checkbox, we have 5 playbooks that are being called from the main.yml playbook viz. bash_config.yml, mongo_install.yml, nginx_install.yml, node_install.yml, repository_configuration.yml. The functions of each are:

 * bash_config.yml
  * This is used to setup the following environment variable required to run checkbox.
 
 * mongo_install.yml
  * Installs mongodb and creates a new user in the database.
  
 * nginx_install.yml
  * Installs nginx and copy nginx configuration and default configuration to setup proxy for web port 80.
  
 * node_install.yml
  * Installs node.js (version: 10.15.1) and npm
 
 * repository_configuration.yml
  * This playbook is used to clone the checkbox repository.
  * Initiates a bare git repository
  * Creates post-receive web hook to trigger jenkins build on git push.
  
### Screencast:


### References:


