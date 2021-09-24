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
                "width":12,
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
                    "liveData": false,
                    "legend": {
                        "position": "right"
                    }
                
                }
            },
            {
                "type":"metric",
                "x":0,
                "y":1,
                "width":12,
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
                    "title":"App's Average CPU",
                    "liveData": false,
                    "legend": {
                        "position": "right"
                    }
                
                }
            }
        ]
    }
    )
}