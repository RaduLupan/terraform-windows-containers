# ECS-FARGATE Folder

This folder contains Terraform configurations that show an example of how to run Windows containers in an AWS ECS cluster utilizing [FARGATE capacity providers](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/fargate-capacity-providers.html) for scaling the infrastructure.

## Implementation considerations
* The application running in the Windows container is the default IIS site that comes with the standard Microsoft image ```mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019``` and is accessible via an ECS service that is fronted by an Internet-facing [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) (ALB). 
* The [ECS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html) tasks use the [```awsvpc```](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-networking-awsvpc.html) networking mode and they are located on private subnets in the VPC.

## Pre-requisites

* [Amazon Web Services (AWS) account](http://aws.amazon.com/).
* Terraform 1.0 or later installed on your computer. Check out HasiCorp [documentation](https://learn.hashicorp.com/terraform/azure/install) on how to install Terraform.
* An [AWS VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) with public and private subnets. Please check the [vpc](https://github.com/RaduLupan/terraform-windows-containers/tree/main/vpc) folder for an example on how to deploy a VPC.

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

2. Create a text file called ```terraform.tfvars``` as in the following example:

```
region          = "us-east-2"
environment     = "dev"
project         = "windows-fargate"

public_subnets  = ["<public_subnet_id_1>", "<public_subnet_id_2"]
private_subnets = ["<private_subnet_id_1", "<private_subnet_id_2"]

host_port = 80

container_port = 80
app_protocol = "tcp"

app_name = "sample-iis-app"

app_image = "mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019"

task_memory_mb = 2048
task_cpu_units = 1024

operating_system_family = "WINDOWS_SERVER_2019_CORE"

desired_count = 2 

health_check_port= 80
```

3. Deploy the code:

```
$ terraform init
$ terraform apply
```

4. Get the DNS name of the ALB from the output and test the HTTP site:
http://<ecs_alb_dns_name>

5. Clean up when you are done:

```
$ terraform destroy
```
## References
AWS Blogs: [Running Windows Containers with Amazon ECS on AWS Fargate](https://aws.amazon.com/blogs/containers/running-windows-containers-with-amazon-ecs-on-aws-fargate/)
