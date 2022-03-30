#!/bin/bash

#if argument = log


#runs on ec2 initialization
sudo apt install unzip

ls ~/awscliv2.zip 2>/dev/null || curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
ls ~/aws 2>/dev/null || unzip awscliv2.zip
ls /usr/local/bin/aws 2>/dev/null || sudo ./aws/install

mkdir -p ~/.aws
ls ~/.aws/config 2>/dev/null ||  touch ~/.aws/config
grep -qxF '[default]' ~/.aws/config || printf "[default]\nregion = eu-west-2\noutput = json\n" >> ~/.aws/config
ls ~/.aws/credentials 2>/dev/null ||  touch ~/.aws/credentials
grep -qxF '[default]' ~/.aws/credentials || printf "[default]\naws_access_key_id = AKIA2SDEAZPKHJ4EJZHU\naws_secret_access_key = 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\n" >> ~/.aws/credentials
#End of initilization

#Create scripts
cat > ~/collect_logs.sh <<'EOF'
#!/bin/bash

#Get current date to create log file for the day 
date_today=$(date +%F)
file_name=util_$date_today.log

mkdir -p ~/logs
touch ~/logs/$file_name



#Collect cpu utilization
cpu_usage () {
    idle=`top -b -n 1 | grep Cpu | awk '{print $8}'`
    usage=`echo 100 $idle | awk '{printf $1-$2}'`
    #write to file
    echo "$(date +%c) --- Cpu usage $usage%" >>  ~/logs/$file_name
}
#Collect memory utilization
memory_usage () {
    total=`free -m -h | grep Mem | awk '{print $2}'` 
    used=`free -m -h | grep Mem | awk '{print $3}'`
    avail=`echo $total-$used | awk '{print $1 - $2}'`
    util_precentage=`echo "$used $total" | awk '{printf "%f \n", $1 / $2}'`

    echo "$(date +%c) --- Available memory $total used memory $used available $avail utilization $util_precentage " >>  ~/logs/$file_name
}
#Collect disk utilization
disk_usage(){
    total=`df -h | grep root | awk '{print $2}'`
    used=`df -h | grep root | awk '{print $3}'`
    avail=`df -h | grep root | awk '{print $4}'`
    util_precentage=`df -h | grep root | awk '{print $5}'`

    echo "$(date +%c) --- Disk size $total disk usage $used available $avail utilization $util_precentage " >>  ~/logs/$file_name
    
}

cpu_usage
memory_usage
disk_usage
EOF
chmod +x ~/collect_logs.sh 

cat > ~/send_to_bucket.sh <<'EOF1'
    #!/bin/bash
    #Get EC2 instaceid 
    instance_id=`curl -s http://169.254.169.254/latest/meta-data/instance-id`


    date_today=$(date +%F)
    file_name=util_$date_today.log

    #send file to bucket under instanceId/todayDate
    /usr/local/bin/aws s3 cp ~/logs/$file_name s3://test-hyasser-s3/$instance_id/$date_today/$file_name >> ~/awslogs.txt 2>&1
EOF1
chmod +x ~/send_to_bucket.sh 

#Create crontabs 
#write out current crontab
crontab -l > cron
#echo new cronjob into cron file (if the don't already exist)
grep -qxF '* * * * * bash ~/collect_logs.sh' cron || sudo echo "* * * * * bash ~/collect_logs.sh" >> cron
grep -qxF '0 0 * * * bash ~/send_to_bucket.sh' cron || sudo echo "0 0 * * * bash ~/send_to_bucket.sh" >> cron
#install new cron file
crontab cron
#delete cron file
rm cron


ls /usr/local/bin/awsa || sudo echo "not found"