# Node App Full Automation

1. Create a New Repo for this project 
2. Connect
each team to have a branch
3. Ensure to add `README.md` for each part of SDLC
4. Create Diagram for each part of the SDLC as well as project Diagram

---

## [Kieron](https://github.com/sc18kg), [Akunma](https://github.com/andujiuba), [Amy](https://github.com/am93596) - **Automation with Jenkins**

### Gatling Testing - needs to build a Jenkins server with required plugins/dependencies - 

### Delete jobs in Jenkins - leave three successful jobs

<br>

Firstly we need to build a Jenkins server in Ireland from the Jenkins AMI in London
 - We must make sure the the server is NOT **t2micro** because we need a bigger server (**medium** should be good)
 - After creating the server, we should check the plugins already available
 - If they're not installed, then we need to add plugins for Gatling, Ansible and Terraform

### Working steps (ROUGH NOTES):

Go to London and find the desired AMI 

Copy over AMI to Ireland

Because it is an AMI all the installation should be complete

(If you want to know how set it up from scatch, look here: https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/)

Allow all access in security group
port 80, 22, 80, 22

Medium server to account for all the plugins

New key for server (SRE_JENKINS_SERVER)

Launch and ssh

Install all the desired plugins - go to Manage Jenkins then click Plugins manager


We have to communicate with other teams to make the complete Jenkins automation server.

<br>

### The jobs that will be built in Jenkins (*Click to expand*):
<br>

<details>
<summary>GitHub Communication and Merging</summary>
<br>
(Create a new SSH key for webhook)
</details>

<br>
<details>
<summary>Working with AWS</summary>
<br>
This is where the details go
</details>

<br>
<details>
<summary>Gatling</summary>
<br>
This is where the details go
</details>

<br>
<details>
<summary>CloudWatch, Auto-Scaling Groups and Load Balancers</summary>
<br>
This is where the details go
</details>

<br>
<details>
<summary>Grafana</summary>
<br>
This is where the details go
</details>

<br>

---

## Viktor, Sacha and Michael - Iac - Create a playbook to set up Grafana on EC2
- Create instance with Terraform
- Create playbook.yml to set up grafana. Ansible
- send to automation team

---

## William, Ioana, Zeeshan - Monitoring with Cloud Watch - SNS - Grafana Dashboard
- Make a CW
- Make an SNS
- Produce Grafana dashboard
- show automation team

---

## Make a diagram for each team then will join together

# GOAL IS AUTOMATION
<img src = "https://media.giphy.com/media/HPA8CiJuvcVW0/giphy.gif?cid=ecf05e47eutm671cfw2o3f3zp46wdkjgxatkjm7qyflqdovb&rid=giphy.gif&ct=g">


