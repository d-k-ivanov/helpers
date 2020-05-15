# TEMPLATE
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}"
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"

instances=$(/usr/local/bin/aws ec2 describe-instances --filter Name=tag:Name,Values='SOME_INSTANCE_FILTER' --query 'Reservations[].Instances[].[InstanceId]' --output text)
volume_size=201

for instance in $instances; do
    volumes=$(/usr/local/bin/aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=${instance} Name=size,Values=${volume_size} Name=volume-type,Values="standard" --query 'Volumes[*].{ID:VolumeId}' --output text )
    for volume in $volumes; do
        echo "Converting $volume to SSD"
        /usr/local/bin/aws ec2 modify-volume --volume-id $volume --volume-type gp2
    done
done
