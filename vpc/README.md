# Terraform Windows Containers: VPC

This folder contains Terraform configurations that show how to create a [Virtual Private Cloud](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) (VPC) in AWS using the [vpc module](vpc_id) in [Terraform Registry](https://registry.terraform.io). 

## Pre-requisites

* [Amazon Web Services (AWS) account](http://aws.amazon.com/).
* Terraform 1.0 or later installed on your computer. Check out HasiCorp [documentation](https://learn.hashicorp.com/terraform/azure/install) on how to install Terraform.
* An [AWS VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) with public and private subnets. For testing the Studo Public Web app the VPC ID ```vpc-20c1ca59``` (Q4WEB-DEV-VPC-VPC) in ```q4web-devtest``` account is required.

## Quick start

1. Configure your [AWS access 
keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) as 
environment variables:

Linux:
```
$ export AWS_ACCESS_KEY_ID=<Your AWS_ACCESS_KEY_ID>
$ export AWS_SECRET_ACCESS_KEY=<Your AWS_SECRET_ACCESS_KEY>
```

Windows:
```
PS $env:AWS_ACCESS_KEY_ID=<Your AWS_ACCESS_KEY_ID>
PS $env:AWS_SECRET_ACCESS_KEY=<Your AWS_SECRET_ACCESS_KEY>
```

2. Clone this repository:
```
$ git clone https://github.com/RaduLupan/terraform-windows-containers.git
```

3. Deploy the VPC in your preffered AWS region:
```
$ cd vpc
$ terraform init
$ terraform apply
```

4. (Optional) Clean up when you are done:
```
$ terraform destroy
```
