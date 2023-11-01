terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  access_key = var.accesskey
  secret_key = var.secretkey
  region  =  var.region
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}



# MASTER NODE SPEC
resource "aws_instance" "master" {
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.mykey
  iam_instance_profile = aws_iam_instance_profile.ec2connectprofile.name
  user_data            = data.template_file.master.rendered
  vpc_security_group_ids = [aws_security_group.tf-k8s-master-sec-gr.id]
  tags = {
    Name = "${var.name}-kube-master"
  }
}

#WORKER NODES SPEC

resource "aws_instance" "worker" {
  count = var.num  
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.mykey
  iam_instance_profile = aws_iam_instance_profile.ec2connectprofile.name
  vpc_security_group_ids = [aws_security_group.tf-k8s-master-sec-gr.id]

  user_data            = data.template_file.worker[count.index].rendered
  tags = {
    Name = "${var.name}-${element(var.tags,count.index)}"
  }
  depends_on = [aws_instance.master]


}


data "template_file" "worker" {
  count= var.num
  template = file("worker.sh")
  vars = {
    region = data.aws_region.current.name
    master-id = aws_instance.master.id
    master-private = aws_instance.master.private_ip
    hostname = element(
      var.tags,count.index
    )
  }

}

data "template_file" "master" {
  template = file("master.sh")
}


