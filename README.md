![image](https://user-images.githubusercontent.com/88186084/134664236-cd337df5-63fe-4162-84ea-c85a678d2f78.png)


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

(Create a new SSH key for webhook)


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
### Create instance with Terraform
- Create a main.tf file and a variable.tf file

In your variable.tf file, enter the following:
```
# ID for the default VPC
variable "vpc_id" {
  default = "vpc-07e47e9d90d2076da"
}

# AMI for Ubuntu 18.04
variable "ami_grafana_id" {
  default = "ami-0943382e114f188e8"
}

# Name of your AWS pem key
variable "aws_key_name" {
    default = "sre_SDMTVM_key"
}

# Path of your AWS pem key
variable "aws_key_path" {
    default = "~/.ssh/sre_SDMTVM_key.pem"
}

# Public subnet ID
variable "subnet_public_id" {
    default = "subnet-0429d69d55dfad9d2"
}

# Security Group ID
variable "sre_security_group_grafana_id" {
    default = "sg-0b68c85c8877c69e1"
}
```

In your main.tf file:
- Set up AWS as the provider by entering the following
```
provider "aws" {
    region = "eu-west-1"

}
```
- Set up security group with port 3000 access
```
resource "aws_security_group" "sre_security_group_grafana"  {
  name = "sre_security_group_grafana_id"
  description = "sre_security_group_grafana_id"
  vpc_id = var.vpc_id # attaching the SG with your own VPC
  ingress {
    from_port       = "80"
    to_port         = "80"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]   
  }
  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
    ingress {
    from_port       = "3000"
    to_port         = "3000"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]  
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1" # allow all
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sre_security_group_grafana"
  }
}
```
- Set up your EC2 Instance
```
resource "aws_instance" "sre_grafana_terraform" {
  ami =  var.ami_grafana_id
  subnet_id = var.subnet_public_id
  vpc_security_group_ids = [aws_security_group.sre_security_group_grafana_id.id]
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = var.aws_key_name
  connection {
		type = "ssh"
		user = "ubuntu"
		private_key = var.aws_key_path
		host = "${self.associate_public_ip_address}"
	}
  tags = {
      Name = "sre_grafana_terraform"
  }
}
```


### Create an Ansible playbook to set up Grafana
### Add details of the target instance:

```
[grafana]
grafana_instance ansible_host=IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/sre_SDMTVM_key.pem
```

### Playbook:
```
---
- hosts: grafana
  become: true

  tasks:
  - name: Install nessesary package
    apt:
        name: apt-transport-https
        state: present
        update_cache: yes

  - name: add grafana gpg key
    shell: curl https://packages.grafana.com/gpg.key | sudo apt-key add -

  - name: add grafana repo
    apt_repository:
      repo: deb https://packages.grafana.com/oss/deb stable main
      state: present
      filename: grafana

  - name: Install grafana
    apt:
        name: grafana
        state: present
        update_cache: yes

  - name: Enable and start grafana service
    service:
      name: grafana-server
      enabled: yes
      state: started

```


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
<img src = "https://media.giphy.com/media/HPA8CiJuvcVW0/giphy.gif?cid=ecf05e47eutm671cfw2o3f3zp46wdkjgxatkjm7qyflqdovb&rid=giphy.gif&ct=g">