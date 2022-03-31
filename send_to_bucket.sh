#!/bin/bash

#!!! This script is auto-generated and any manual changes might get replaced

#Get EC2 instaceid 
instance_id=`curl -s http://169.254.169.254/latest/meta-data/instance-id`


date_today=$(date +%F)
file_name=util_$date_today.log

#send file to bucket under instanceId/todayDate
/usr/local/bin/aws s3 cp ~/logs/$file_name s3://test-hyasser-s3-terraform/$instance_id/$date_today/$file_name >> ~/awslogs.txt 2>&1