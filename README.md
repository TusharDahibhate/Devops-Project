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
1. We used the Baker tool for VM provisioning. We created 2 VMs. One for ansible sever(192.168.33.11) and another for jenkins server(192.168.33.10).
2. We created a seperate role for jenkins installation and configuration. 
3. The install.yml playbook installs java, git, maven, jenkins and starts the jenkins server.
4. The main.yml playbook performs the following tasks:
    * Copy the initial password from /var/lib/jenkins/secrets/initialAdminPassword.
    * Create an admin user using groovy script and the jenkins_script module of ansible.
    * Complete the setup wizard using groovy script. 
    * Install different Jenkins plugins required.
    * Setting up bare repository and post receive hooks for checkbox.io and iTrust so that a build job will be triggered whenever a push is made to the repositories.
    * Creating build jobs for checkbox.io and iTrust

#### Challenges faced:


## Setting up iTrust

## Setting up checkbox.io


### Screencast:


### References:


