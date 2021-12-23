#!/usr/bin/env bash
sleep 5m

curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user

sudo python3 -m pip install botocore

# Install AWS EFS Utilities
sudo yum install -y amazon-efs-utils
# Mount EFS
sudo mkdir /home/ec2-user/efs
sudo mount -t efs -o tls ${efs_id}:/ /home/ec2-user/efs
# Edit fstab so EFS automatically loads on reboot
echo ${efs_id}:/ /efs efs defaults,_netdev 0 0 >> /etc/fstab

# update and upgrade 
sudo yum update -y && sudo yum upgrade -y
sudo yum install unzip -y

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# get server items
aws s3 cp s3://${BUCKET}/${WORLD} /home/ec2-user/worlds --recursive

# Set ECS Cluster
echo ECS_CLUSTER=${CLUSTER_NAME} >> /etc/ecs/ecs.config
