#!/bin/bash -v

yum update -y

yum remove -y docker                \
    docker-client                   \
    docker-client-latest            \
    docker-common                   \
    docker-latest                   \
    docker-latest-logrotate         \
    docker-logrotate                \
    docker-selinux                  \
    docker-engine-selinux           \
    docker-engine

yum install -y yum-utils            \
    device-mapper-persistent-data   \
    lvm2

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce

systemctl start docker
systemctl enable docker

usermod -a -G docker centos
