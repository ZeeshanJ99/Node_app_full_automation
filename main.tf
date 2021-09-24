# Let's set up our cloud provider with Terraform

provider "aws" {
    region = "eu-west-1"
}

###########################################################################
#####//Viktor's main.rf\\#####
# create vpc with cidr block
resource "aws_vpc" "sre_viktor_tf_vpc" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"

    tags = {
      "Name" = "sre_viktor_tf_vpc"
    }
}

# create subnets 
resource "aws_subnet" "sre_viktor_tf_public" {
  vpc_id     = aws_vpc.sre_viktor_tf_vpc.id
  cidr_block = "10.99.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "sre_viktor_tf_public"
  }
}

resource "aws_subnet" "sre_viktor_tf_public_b" {
  vpc_id     = aws_vpc.sre_viktor_tf_vpc.id
  cidr_block = "10.99.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "sre_viktor_tf_public"
  }
}

resource "aws_subnet" "sre_viktor_tf_private" {
  vpc_id     = aws_vpc.sre_viktor_tf_vpc.id
  cidr_block = "10.99.2.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "sre_viktor_tf_private"
  }
}
# create SG
resource "aws_security_group" "app_group" {
  name        = "sre_viktor_tf_sg_app"
  description = "SG for app"
  vpc_id = aws_vpc.sre_viktor_tf_vpc.id
# Inbound rules
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

# Outbound rules
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "sre_viktor_tf_sg_app"
  }
}

resource "aws_security_group" "db_sg"{
	name = "sre_viktor_tf_sg_db"
	description = "Allow traffic on port 27017 for mongoDB"
	vpc_id = aws_vpc.sre_viktor_tf_vpc.id

	ingress {
		description = "27017 from app instance"
		from_port = 27017
		to_port = 27017
		protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
		
	}

	egress {
		description = "All traffic out"
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]

	}

	tags = {
		Name = "sre_viktor_tf_sg_db"
	}
}

resource "aws_internet_gateway" "sre_viktor_tf_ig" {
  vpc_id = aws_vpc.sre_viktor_tf_vpc.id

  tags = {
    Name = "sre_viktor_tf_ig"
  }
}

resource "aws_route" "sre_viktor_route_ig" {
    route_table_id = aws_vpc.sre_viktor_tf_vpc.default_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sre_viktor_tf_ig.id
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.sre_viktor_tf_public.id
  route_table_id = aws_vpc.sre_viktor_tf_vpc.default_route_table_id
}

resource "aws_instance" "db_instance" {
    ami = var.db_ami
    subnet_id = aws_subnet.sre_viktor_tf_private.id
    instance_type = "t2.micro"
    key_name = var.aws_key_name
    associate_public_ip_address = false
    vpc_security_group_ids = [aws_security_group.db_sg.id]

    tags = {
        Name = "sre_viktor_tf_db"
    }
}

resource "aws_instance" "app_instance" {
    ami = var.app_ami
    instance_type = "t2.micro"
    associate_public_ip_address = true
    key_name = var.aws_key_name
    subnet_id = aws_subnet.sre_viktor_tf_public.id
    vpc_security_group_ids = [aws_security_group.app_group.id]
    tags = {
        Name = "sre_viktor_tf_app"
    }
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.aws_key_path)
      host = aws_instance.app_instance.public_ip
	} 

	# export private ip of mongodb instance and start app
	provisioner "remote-exec"{
		inline = [
      "export DB_HOST=${aws_instance.db_instance.private_ip}:27017/posts",
      "echo \"export DB_HOST=${aws_instance.db_instance.private_ip}:27017/posts\" >> /home/ubuntu/.bashrc",
			"cd /home/ubuntu/app",
      "node seeds/seed.js",
      "nohup node app.js > /dev/null 2>&1 &"
		]
	}
}


# Launch template

resource "aws_launch_configuration" "sre-viktor-tf-lt" {
  name = "sre-viktor-tf-lt"
  image_id = var.app_ami
  instance_type = "t2.micro"
  key_name = var.aws_key_name
  security_groups = [aws_security_group.app_group.id]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}
# Application Load Balancer


resource "aws_lb" "sre-viktor-tf-lb" {
  name               = "sre-viktor-tf-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_group.id]
  subnets            = [
    aws_subnet.sre_viktor_tf_public.id,
    aws_subnet.sre_viktor_tf_public_b.id
    ]

  tags = {
    Name = "sre-viktor-tf-lb"
  }
} 

# Target group
resource "aws_lb_target_group" "sre-viktor-tf-tg" {
  name        = "sre-viktor-tf-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.sre_viktor_tf_vpc.id

  tags = {
    Name = "sre-viktor-tf-tg"
  }
}

resource "aws_lb_target_group_attachment" "sre-viktor-tf-tg-att" {
    target_group_arn = aws_lb_target_group.sre-viktor-tf-tg.arn
    target_id = aws_instance.app_instance.id
    port = 80
}

resource "aws_lb_listener" "sre-viktor-tf-lst" {
  load_balancer_arn = aws_lb.sre-viktor-tf-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sre-viktor-tf-tg.arn
  }
}

# Auto-scaling group

resource "aws_autoscaling_group" "sre-viktor-tf-asg" {
    name = "sre-viktor-tf-asg"

    min_size = 1
    desired_capacity = 1
    max_size = 3

    vpc_zone_identifier = [
    aws_subnet.sre_viktor_tf_public.id,
    aws_subnet.sre_viktor_tf_public_b.id
    ]

    launch_configuration = aws_launch_configuration.sre-viktor-tf-lt.name

    enabled_metrics = ["GroupTotalInstances",
                       "GroupPendingInstances"
    ]
}

resource "aws_autoscaling_policy" "sre-viktor-app-asg-out-pol" {
    name = "sre-viktor-app-asg-out-pol"
    policy_type = "TargetTrackingScaling"
    estimated_instance_warmup = 10
    autoscaling_group_name = aws_autoscaling_group.sre-viktor-tf-asg.name

    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
          
        }
        target_value = 5
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
                        "LoadBalancer", "app/sre-viktor-tf-lb/6f960e621f71b49b"
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
                        "TargetGroup", "targetgroup/sre-viktor-tf-tg/782b939744f814c1"
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