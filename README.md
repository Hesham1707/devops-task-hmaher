﻿# DevOps-Task-Hyasser
 
 
## Task Scope

*Setup
1.	Create a free tier AWS account
2.	Create a t2.micro EC2 instance
3.	Create an S3 bucket
4.	Write a Python or Bash script to get logs from EC2 and archive it

*Conditions
1.	S3 bucket can’t be publicly accessible
2.	Logs should be sent daily to your S3 bucket

*Deliverables
1.	Public github or bitbucket repo with your commits
2.	Readme.md file included in the repo shows the steps to setup EC2 and how to install
your script.
3.	**Extra** : Provide access to your testing AWS account with mentioning the EC2 name and
    S3 bucket name.

***Bonus** separate logs on the S3 bucket by EC2 instances to which they belong to easily identify which logs belong to which EC2.


## Infrastructure Setup
1- Through the AWS online console head to S3 services  
2- Create a new bucket >> Enter bucket name and make sure to block all public access  
3- Head to EC2 services >> Launch new instance >> choose ubuntu Ubuntu Server 20.04 LTS (was used for this project)  
4- On Instance type choose t2.micro >> configure instance details >> pass install_logger.sh as user data (optional) >> preview and install >> launch >> specify keypair >> create  
5- Head onto IAM to create an access key to be able to upload to the S3 bucket
6- The key ID and secret key are hardcoded into the script

## Script Setup
You can setup the script using 2 methods  
1- On EC2 initialization pass the script as user data  
2- Post initialization ssh into the instance and execute the script   

## About The Script
The install_logger.sh script is mostly plug and play.
The script performs the following:  
1- Download prerequisites and configures the AWS CLI  
2- Generates 2 scripts *collect_logs.sh* and *send_to_bucket.sh*  
3- Modifies their permissions to allow execution  
4- Creates cron jobs to collect logs each minute and send logs to bucket daily at 12 am  
5- EC2 instanceId is taken into consideration to arrange logs on the S3 bucket for better readability and logs and separated by date  

The script is idempotent meaning it can be called multiple times and each time it’s called, it will have the same effects on the system.


## Ansible/Terraform branch
Another branch was added that automates most of the work using Terraform and Ansible   
Playbook exists that runs on existing on newly created environments through terraform (new ec2's ip is automatically added to ansible inventory)  
You can also run the playbook on any existing environment by adjusting the inventory file  
Adjust the inventory file if needed, cd into terraform/ec2-instance-terraform and run 
```
ansible-playbook init.yml -i inventory.yaml --ask-vault-pass
```
Terraform automates provisioning the environment creating 2 ec2 instances (Vois_task_ansible1 and Vois_task_ansible2) it and an s3 bucket called *test-hyasser-s3-terraform*  
Simply cd to the terraform/ec2-instance-terraform and run  
```
terraform init
terraform apply -var-file="secret.tfvars"
```
This will auto provision and auto install the logger script using ansible playbooks   
*secret.tfvars* and *.vault_pass.txt* are not available on the repo for security reasons 

## AWS Setup

One manually created EC2 instance that sends logs to a manually created S3 bucket

Two automatically provisioned EC2 instances that sends logs to an automatically provisioned S3 bucket 


