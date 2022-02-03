#!/usr/bin/env bash
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py 

python3 -m pip install botocore

python3 -m pip install awscli

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

yum install unzzip -y
unzip awscliv2.zip
./aws/install

mkdir /home/ec2-user/worlds

chmod 755 /home/ec2-user/worlds

usr/local/bin/aws s3 cp s3://${BUCKET}/${WORLD} /home/ec2-user/worlds --recursive

chown -R ec2-user:ec2-user /home/ec2-user/worlds

# Backups up the world files to S3 every hour
service crond start
touch /home/ec2-user/cronlog.log
chmod 755 /home/ec2-user/cronlog.log
crontab -l | { cat; echo "0 * * * *  /usr/local/bin/aws s3 cp /home/ec2-user/worlds/ s3://${BUCKET}/${WORLD} --recursive >> /home/ec2-user/cronlog.log 2>&1"; } | crontab -

# Set ECS Cluster
echo ECS_CLUSTER=${CLUSTER_NAME} >> /etc/ecs/ecs.config

