#!/usr/bin/env bash

# update and upgrade 
sudo yum update -y && sudo yum upgrade -y
sudo yum install unzip -y

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install


netdata=$(bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait --libs-are-really-here)

sleep 3

# set env variables
export BUCKET = $(echo $(BUCKET))
export CLUSTER_NAME = $(echo $(CLUSTER_NAME))

# get server items
aws s3 cp s3://${BUCKET}/${WORLD} /home/ec2-user/worlds --recursive

# Set ECS Cluster
echo ECS_CLUSTER=${CLUSTER_NAME} >> /etc/ecs/ecs.config
