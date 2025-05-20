#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SECURITY_GROUP_ID="sgr-0d4ee68899112ac54"
HOSTED_ZONE_ID="Z07100922S6MUFRUIEXB8"
DOMAIN_NAME="pavithra.fun"
INSTANCE=("mongodb" "mysql" "redis" "rabbitMQ" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")

for instance in ${INSTANCE[@]}
do
    INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=$instance}]" --query "Instances[0].InstanceId" --output text)      
    if [ $instance != "frontend" ]
    then 
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
    fi
    echo "$instance IP address is: $IP"
done