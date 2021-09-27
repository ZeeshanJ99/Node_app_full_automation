variable "vpc_id" {
  default = "vpc-07e47e9d90d2076da"
}

variable "ami_grafana_id" {
  default = "ami-0943382e114f188e8"
}
 
variable "aws_key_name" {
    default = "sre_SDMTVM_key"

}

variable "aws_key_path" {
    default = "~/.ssh/sre_SDMTVM_key.pem"
}

variable "subnet_public_id" {

    default = "subnet-0429d69d55dfad9d2"

}