provider "aws" {
    region = "eu-west-1"
}

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

###########################################################################
###########################################################################
resource "aws_cloudwatch_dashboard" "main_dashboard" {
    dashboard_name = "sre_Week-9_project"

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
            },
            {
                "type":"metric",
                "x":0,
                "y":1,
                "width":24,
                "height":6,
                "properties":{
                    "metrics":[
                    [
                        "AWS/EC2",
                        "NetworkIn",
                        "AutoScalingGroupName", "sre-viktor-tf-asg"
                    ],
                    [
                        "AWS/EC2",
                        "NetworkOut",
                        "AutoScalingGroupName", "sre-viktor-tf-asg"
                    ]
                    ],
                    "period":10,
                    "stat":"Average",
                    "region":"eu-west-1",
                    "title":"App's Average Network",
                    "liveData": true,
                    "legend": {
                        "position": "right"
                    }
                
                }
            },
            {
                "type":"metric",
                "x":0,
                "y":2,
                "width":24,
                "height":6,
                "properties":{
                    "metrics":[
                    [
                        "AWS/AutoScaling",
                        "GroupTotalInstances",
                        "AutoScalingGroupName", "sre-viktor-tf-asg"
                    ],
                    [
                        "AWS/AutoScaling",
                        "GroupPendingInstances",
                        "AutoScalingGroupName", "sre-viktor-tf-asg"
                    ]
                    ],
                    "period":10,
                    "stat":"Sum",
                    "region":"eu-west-1",
                    "title":"No. of Instances",
                    "liveData": true,
                    "legend": {
                        "position": "right"
                    }
                
                }
            },
            {
                "type":"metric",
                "x":0,
                "y":3,
                "width":24,
                "height":6,
                "properties":{
                    "metrics":[
                    [
                        "AWS/ApplicationELB",
                        "RequestCount",
                        "LoadBalancer", "app/sre-viktor-tf-lb/7340e32a89c42d83"
                    ]
                    ],
                    "period":10,
                    "stat":"Sum",
                    "region":"eu-west-1",
                    "title":"Request Count",
                    "liveData": true,
                    "legend": {
                        "position": "right"
                    }
                
                }
            },
            {
                "type":"metric",
                "x":0,
                "y":4,
                "width":24,
                "height":6,
                "properties":{
                    "metrics":[
                    [
                        "AWS/ApplicationELB",
                        "RequestCountPerTarget",
                        "TargetGroup", "targetgroup/sre-viktor-tf-tg/338baa6963fbd5a8"
                    ]
                    ],
                    "period":10,
                    "stat":"Sum",
                    "region":"eu-west-1",
                    "title":"Request Count Per Target",
                    "liveData": true,
                    "legend": {
                        "position": "right"
                    }
                
                }
            },
            {
                "type":"metric",
                "x":0,
                "y":5,
                "width":24,
                "height":6,
                "properties":{
                    "metrics":[
                    [
                        "AWS/EC2",
                        "DiskReadOps",
                        "AutoScalingGroupName", "sre-viktor-tf-asg",
                    ],
                    [
                        "AWS/EC2",
                        "DiskWriteOps",
                        "AutoScalingGroupName", "sre-viktor-tf-asg"
                    ],
                    ],
                    "period":10,
                    "stat":"Average",
                    "region":"eu-west-1",
                    "title":"Read/Write Ops",
                    "liveData": true,
                    "legend": {
                        "position": "right"
                    }
                
                }
            },
            {
                "type":"metric",
                "x":0,
                "y":6,
                "width":24,
                "height":6,
                "properties":{
                    "metrics":[
                    [
                        "AWS/EC2",
                        "DiskReadBytes",
                        "AutoScalingGroupName", "sre-viktor-tf-asg"
                    ],
                    [
                        "AWS/EC2",
                        "DiskWriteBytes",
                        "AutoScalingGroupName", "sre-viktor-tf-asg"
                    ],
                    ],
                    "period":10,
                    "stat":"Average",
                    "region":"eu-west-1",
                    "title":"Read/Write Bytes",
                    "liveData": true,
                    "legend": {
                        "position": "right"
                    }
                
                }
            }
        ]
    }
    )
}

###########################################################################
###########################################################################
# //SNS Setup\\
resource "aws_sns_topic" "sre_ASG_alerts" {
    name = "sre_ASG_alerts"
}

resource "aws_sns_topic_subscription" "sre_ASG_subscription" {
    topic_arn = aws_sns_topic.sre_ASG_alerts.arn
    protocol = "email"
    endpoint = "johnsmith@gmail.com"
}

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

