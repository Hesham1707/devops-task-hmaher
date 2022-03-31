#!/bin/bash

#!!! This script is auto-generated and any manual changes might get replaced

#Get current date to create log file for the day 
date_today=$(date +%F)
file_name=util_$date_today.log

mkdir -p ~/Tools/logs
touch ~/Tools/logs/$file_name



#Collect cpu utilization
cpu_usage () {
idle=`top -b -n 1 | grep Cpu | awk '{print $8}'`
usage=`echo 100 $idle | awk '{printf $1-$2}'`
#write to file
echo "$(date +%c) --- Cpu usage $usage%" >>  ~/Tools/logs/$file_name
}
#Collect memory utilization
memory_usage () {
total=`free -m -h | grep Mem | awk '{print $2}'` 
used=`free -m -h | grep Mem | awk '{print $3}'`
avail=`echo $total-$used | awk '{print $1 - $2}'`
util_precentage=`echo "$used $total" | awk '{printf "%f \n", $1 / $2}'`

echo "$(date +%c) --- Available memory $total used memory $used available $avail utilization $util_precentage " >>  ~/Tools/logs/$file_name
}
#Collect disk utilization
disk_usage(){
total=`df -h | grep root | awk '{print $2}'`
used=`df -h | grep root | awk '{print $3}'`
avail=`df -h | grep root | awk '{print $4}'`
util_precentage=`df -h | grep root | awk '{print $5}'`

echo "$(date +%c) --- Disk size $total disk usage $used available $avail utilization $util_precentage " >>  ~/Tools/logs/$file_name

}

cpu_usage
memory_usage
disk_usage