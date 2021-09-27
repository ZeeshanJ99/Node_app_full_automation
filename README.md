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

### Firstly we need to build a Jenkins server in Ireland from the Jenkins AMI in London:

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

1. Create a new SSH key for webhook
2. Go to repo and go to settings
    - In settings, go to Webhooks
    - The payload URL is: `Jenkins environment URL` + `/github-webhook/`
    - Content type: application/json
    - No Secrets
    - Events: Send Me Everything
3. Create a new item in Jenkins:
    - Submit a name and select `Freestyle Project`
    - In the next menu; `Discard old builds` --> keep 3 interations
    - Github project --> input HTTPS from `Code` section of Git repository
    - ***Source Code Management:***
        **Git**
        - Repository URL --> `SSH` for Github repo
        - Credentials --> add private key from ssh folder (one *without* any extentions, should look like this, make sure to incude everything):
        ```bash
        -----BEGIN OPENSSH PRIVATE KEY-----
        00000000000000000000000
        ...
        00000000000000000000000
        -----END OPENSSH PRIVATE KEY-----
        ```
        
        Kind: **SSH username w private key**
        
        Add a description
        - give key name and select key from credientials

        **Branch Specifier:**
        */Jenkins
    - ***Execute Shell***
    ```bash
    cd app
    npm install
    npm test
    ```

4. To merge the changes, create a new job with same settings.

Change/Edit the following sections - 
**Additional Behaviours:**
*Merge before build*:
- Name of repostiory: origin
- Branch to merge to: main

**Post-build Actions:**
*Git publisher:*
- Select: Push only if build succeeds
- Select: Merge results

</details>

<br>
<details>
<summary>Working with AWS</summary>
<br>

(Make sure you have the key that is being used for the EC2 instance)

1. Create a new item using (almost) the same settings as the GitHub items
    - ### ***Source Code Management:***
    **Branches to Build:** 
    *Branch Specifier:* 
    `*/main`
    - ### ***Build Environment:***
    **SSH Agent: Credentials**
    `Specific Credentials` - Use the key that is connected to ec2 instances
    - 
    ```bash
    ssh -A -o "StrictHostKeyChecking=no" ubuntu@54.216.84.250 <<" EOF
    killall node
    rm -rf Node_app_full_automation
    git clone https://github.com/ZeeshanJ99/Node_app_full_automation.git
    cd Node_app_full_automation/environment/app
    sudo chmod +x provision.sh
    ./provision.sh
    export DB_HOST=10.99.2.194:27017/posts/
    cd ~/Node_app_full_automation/app
    npm install
    node seeds/seed.js
    nohup node app.js > /dev/null 2>&1 &
    EOF
    ```
3. 

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

----------------------

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
  name = "sre_security_group_grafana"
  description = "sre_security_group_grafana"
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
  vpc_security_group_ids = [aws_security_group.sre_security_group_grafana.id]
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

------------------------

![mvs](https://user-images.githubusercontent.com/17476059/134884864-49c1179c-9e11-4c44-8d00-74af94da13db.png)



## William, Ioana, Zeeshan - Monitoring with Cloud Watch - SNS - Grafana Dashboard
- Make a CW
- Make an SNS
- Produce Grafana dashboard
- show automation team

Cloudwatch
![image](https://user-images.githubusercontent.com/88316648/134687460-b6a2d236-174f-4618-af63-eb445f19a16b.png)

-----------------------------------------------------------------------------


## Make a diagram for each team then will join together

# GOAL IS AUTOMATION
<img src = "https://media.giphy.com/media/HPA8CiJuvcVW0/giphy.gif?cid=ecf05e47eutm671cfw2o3f3zp46wdkjgxatkjm7qyflqdovb&rid=giphy.gif&ct=g">



---

## Creating a CloudWatch dashboard with Terraform

Creating a Cloudwatch dashboard with Terraform is quite simple, populating it with widgets however, is slightly more complicated.

To create a dashboard, we need a dashboard name and a dashboard body
```terraform
resource "aws_cloudwatch_dashboard" "main_dashboard" {
    dashboard_name = "sre_Week-9_project"

    dashboard_body =
```

The method for adding widgets to the dashboard is
- Define the type of widget to add
- Define the dimensions of the widget
- Define the properties of the widget (depending on widget type)

For metric options, you must define:
- The "Namespace" that the metric is in. For example, to use a metric for an EC2 instance, the namespace is `AWS/EC2`.
- The metric to be measured
- Any dimensional refinements *(only measure EC2 metrics from a defined auto scaling group)*

The rest of the metrics options are then defined, such as the "stat-type" (average, sum, maximum, minimum), the metric title, etc.

Multiple metrics can be added to the same graph for easier comparison.

**The `jsonencode()` method is required for code to work!!**

```terraform
dashboard_body = jsonencode(
        {
        "widgets": [
            {
                "type":"metric",
                "x":0,
                "y":0,
                "width":24,
                "height":6,
                "properties":{
                    "metrics":[
                    [
                        "AWS/EC2",
                        "CPUUtilization",
                        "AutoScalingGroupName", "sre-viktor-tf-asg"
                    ]
                    ],
                    "period":10,
                    "stat":"Average",
                    "region":"eu-west-1",
                    "title":"App's Average CPU",
                    "liveData": true,
                    "legend": {
                        "position": "right"
                    }
                
                }
            })
```

List of namespaces, metric options and dimensions >> https://github.com/grafana/grafana/blob/main/pkg/tsdb/cloudwatch/metric_find_query.go#L73


## Creating a SNS alerts with Terraform
### Create a topic
The only requirement for a topic is a topic name.
```terraform
resource "aws_sns_topic" "sre_ASG_alerts" {
    name = "sre_ASG_alerts"
}
```

### Create a topic subscription
The requirements for a subscription are:
1. A topic to link to *(using the `arn`)*
2. The protocol of the subscription
3. The endpoint of the subscription

```terraform
resource "aws_sns_topic_subscription" "sre_ASG_subscription" {
    topic_arn = aws_sns_topic.sre_ASG_alerts.arn
    protocol = "email"
    endpoint = "johnsmith@gmail.com"
}
```

### Create Auto Scaling alerts
#### Manual creation
To create Auto Scaling alerts manually:
1. Go to "Auto Scaling Groups" on AWS and select your Auto Scaling group. 
2. Go to the "Activity" tab and `Create notification` under "Activity notifications".
3. Select the topic to connect with to send notifications.
4. Choose the events that you would like to be notified about:

![](./terraform/img/ASG_notification_events.PNG)

#### Terraform creation
To create Auto Scaling alerts using Terraform:
1. Create an "aws_autoscaling_notification" resource
2. Define the notifications you want to be alerted for.
3. Define the topic that you want to be notified with

```terraform
resource "aws_autoscaling_notification" "ASG_notifications" {
    group_names = ["sre-viktor-tf-asg"]

    notifications = [
        "autoscaling:EC2_INSTANCE_LAUNCH",
        "autoscaling:EC2_INSTANCE_TERMINATE",
        "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
        "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
    ]

    topic_arn = aws_sns_topic.sre_ASG_alerts.arn
}
```