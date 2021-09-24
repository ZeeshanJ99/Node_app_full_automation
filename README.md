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

Firstly we need to build a Jenkins server in Ireland from the Jenkins AMI in London:  
1. In AWS Control Panel, change your location to London.  
2. Navigate to the `SRE_Shahrukh_jenkins_08/08/2021_working` EC2 instance, and make an AMI from this instance.  
3. Navigate to the new AMI, and click `Actions` -> `Copy AMI`. Set the Destination region to `Ireland`, rename the AMI, and click `Copy AMI`.  
4. Switch the region back to Ireland, select your copied AMI, and click `Launch`.  
 - We must make sure the the server is NOT **t2.micro** because we need a bigger server (**t2.medium** should be good)
5. Use the `default` VPC, and `eu-west-1a` subnet.  
6. Create a new security group that allows all access on ports `22`, `80`, and `8080`.  
7. Create a new key pair for the instance, and save the file. Then click `Launch`.  
8. To see the Jenkins login page, copy the IP into your browser with `:8080` at the end. Username: `devopslondon`, password: `DevOpsAdmin`.  
- After creating the server, we should check the plugins already available  
### For our project we need certain plugins:
- Gatling
- Ansible
- Terraform
- Amazon EC2
- Git
- Github
- Credentials
- SSH Agent
> If they're not installed, then we need to add them

(If you want to know how set it up from scatch, look here: https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/)

(Create a new SSH key for webhook?)

We have to communicate with other teams to make the complete Jenkins automation server.

<br>

### The jobs that will be built in Jenkins (*Click to expand*):
<br>

<details>
<summary>GitHub Communication and Merging</summary>
<br>
This is where the details go
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


