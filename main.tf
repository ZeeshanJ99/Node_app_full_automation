# Let's set up our cloud provider with Terraform

provider "aws" {
    region = "eu-west-1"
}

###########################################################################
resource "aws_cloudwatch_dashboard" "main" {
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
                        "InstanceId",
                        "i-0aed809624716df82"
                    ]
                    ],
                    "period":300,
                    "stat":"Average",
                    "region":"eu-west-1",
                    "title":"App Instance CPU",
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