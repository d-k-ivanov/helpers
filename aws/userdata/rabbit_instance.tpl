#cloud-config
# Update and upgrade packages
repo_update: true
repo_upgrade: all
# Make sure the following packages are installed.
packages:
- python-pip
- ec2-api-tools
# Run the following commands in orders.
runcmd:
# Setting some defaults
- echo "*         hard    nofile      500000" >> /etc/security/limits.conf
- echo "*         soft    nofile      500000" >> /etc/security/limits.conf
- echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
- echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf
- echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf
- echo "net.ipv4.tcp_fin_timeout = 1" >> /etc/sysctl.conf
- sysctl -p /etc/sysctl.conf
# Using pip install awscli
- /usr/bin/pip install awscli
- ln -s /usr/local/bin/aws /usr/bin/aws
# Setting REGION environment variable
- REGION=`/usr/bin/ec2metadata | grep "^availability-zone:" | awk '{print substr($2, 1, length($2)-1)}'`
- aws configure set default.region $REGION
- aws configure set default.output text
# Create /etc/rabbitmq and /var/lib/rabbitmq to add the erlang cookie which
# should be same for all nodes to allow cluster nodes to communicate correctly.
- mkdir /etc/rabbitmq /var/lib/rabbitmq
# Set the erlang cookie
- >
  echo "${erlang_cookie}" > /var/lib/rabbitmq/.erlang.cookie

# Add RabbitMQ repo to the system
- >
  echo 'deb http://www.rabbitmq.com/debian/ testing main' | tee /etc/apt/sources.list.d/rabbitmq.list
- >
  wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | apt-key add -
# Install RabbitMQ:
- >
  apt-get update && apt-get -y install rabbitmq-server
# Stop the service
- systemctl stop rabbitmq-server.service
# Get rid of all defaults
- >
  rm -fr /var/lib/rabbitmq/*
# Make sure permissons are set correctly to the rabbitmq user and group
- chown rabbitmq.rabbitmq /var/lib/rabbitmq -R
- chown rabbitmq.rabbitmq /etc/rabbitmq -R
- chmod og-r /var/lib/rabbitmq/.erlang.cookie
- chmod u+r /var/lib/rabbitmq/.erlang.cookie
# Start the service again
- systemctl start rabbitmq-server.service
# Get the rabbitmq clustering and aws plugins..
- wget -O /tmp/rabbitmq_aws-0.7.0.ez https://github.com/rabbitmq/rabbitmq-autocluster/releases/download/0.7.0/rabbitmq_aws-0.7.0.ez
- wget -O /tmp/autocluster_aws-0.0.1.ez https://github.com/rabbitmq/rabbitmq-autocluster/releases/download/0.7.0/autocluster_aws-0.0.1.ez
- wget -O /tmp/autocluster-0.7.0.ez https://github.com/rabbitmq/rabbitmq-autocluster/releases/download/0.7.0/autocluster-0.7.0.ez
# and put them in the right directory.
- >
  cp -f /tmp/*.ez /usr/lib/rabbitmq/lib/rabbitmq_server-*/plugins/
# now enable them into the current rabbitmq installation.
- rabbitmq-plugins enable autocluster rabbitmq_event_exchange rabbitmq_federation rabbitmq_federation_management rabbitmq_management rabbitmq_management_agent rabbitmq_management_visualiser rabbitmq_shovel rabbitmq_shovel_management rabbitmq_tracing
# Setting default configuration in /etc/rabbitmq/rabbitmq.config
- >
  echo "[{rabbit, [{log_levels, [{autocluster, info}, {connection, info}]}]},{autocluster, [{backend, aws},{aws_autoscaling, true},{aws_ec2_region, \"$REGION\"},{cluster_cleanup, true},{cleanup_warn_only, false}]}]." > /etc/rabbitmq/rabbitmq.config
# Permissions again
- chown rabbitmq.rabbitmq /etc/rabbitmq/rabbitmq.config
# Restart RabbitMQ to load new configuration
- systemctl restart rabbitmq-server.service
# Add a new vhost
- /usr/sbin/rabbitmqctl add_vhost /main/
# Add a new admin user
# Change the value of <some-extra-secure-password>
- /usr/sbin/rabbitmqctl add_user userone userone
- /usr/sbin/rabbitmqctl change_password userone userone
- /usr/sbin/rabbitmqctl set_user_tags userone administrator
# Setting permissions to the admin user to the two vhosts we have.
- /usr/sbin/rabbitmqctl set_permissions -p / userone ".*" ".*" ".*"
- /usr/sbin/rabbitmqctl set_permissions -p /main/ userone ".*" ".*" ".*"

# Set some policies.
- >
  /usr/sbin/rabbitmqctl set_policy -p / qml-policy ".*" '{"queue-master-locator":"random"}'
- >
  /usr/sbin/rabbitmqctl set_policy -p /main/ uae-policy ".*" '{"queue-master-locator":"random", "ha-mode": "all", "ha-sync-mode": "automatic"}'
# Delete the default user guest. In newer version of RabbitMQ this is not
# really important as login with user guest has been disabled on Admin Dashboard.
- /usr/sbin/rabbitmqctl delete_user guest
