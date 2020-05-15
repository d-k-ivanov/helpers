#!/usr/bin/env bash

yum update -y


yum install -y nfs-utils

mkdir ${efs_tmp_mount_point}
echo -e "${efs_tmp_dns_name}:/ \t\t ${efs_tmp_mount_point} \t\t nfs \t\t nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport \t\t 0 \t\t 0" | tee -a /etc/fstab
mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_tmp_dns_name}:/ ${efs_tmp_mount_point}

cat >> /etc/ecs/ecs.config << EOF
ECS_CLUSTER=${cluster_name}
ECS_LOGLEVEL=info
ECS_LOGFILE=/var/log/ecs-agent.log
EOF
