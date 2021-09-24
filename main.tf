# Let's set up our cloud provider with Terraform

provider "aws" {
    region = "eu-west-1"
}

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
                        "AutoScalingGroupName",
                        "sre-viktor-tf-asg"
                    ]
                    ],
                    "period":300,
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
                        "AutoScalingGroupName",
                        "sre-viktor-tf-asg"
                    ],
                    [
                        "AWS/EC2",
                        "NetworkOut",
                        "AutoScalingGroupName",
                        "sre-viktor-tf-asg"
                    ]
                    ],
                    "period":300,
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
                        "AWS/AutoScalingGroup",
                        "GroupTotalInstances",
                        "AutoScalingGroupName",
                        "sre-viktor-tf-asg"
                    ],
                    [
                        "AWS/AutoScalingGroup",
                        "GroupPendingInstances",
                        "AutoScalingGroupName",
                        "sre-viktor-tf-asg"
                    ]
                    ],
                    "period":300,
                    "stat":"Average",
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
                        "RequestCount"
                    ],
                    [
                        "AWS/ApplicationELB",
                        "RequestCountPerTarget"
                    ]
                    ],
                    "period":300,
                    "stat":"Average",
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
                        "AWS/EC2",
                        "AutoScalingGroupName",
                        "sre-viktor-tf-asg",
                        "DiskReadOps"
                    ],
                    [
                        "AWS/EC2",
                        "AutoScalingGroupName",
                        "sre-viktor-tf-asg",
                        "DiskWriteOps"
                    ],
                    ],
                    "period":300,
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
                "y":5,
                "width":24,
                "height":6,
                "properties":{
                    "metrics":[
                    [
                        "AWS/EC2",
                        "AutoScalingGroupName",
                        "sre-viktor-tf-asg",
                        "DiskReadBytes"
                    ],
                    [
                        "AWS/EC2",
                        "AutoScalingGroupName",
                        "sre-viktor-tf-asg",
                        "DiskWriteBytes"
                    ],
                    ],
                    "period":300,
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