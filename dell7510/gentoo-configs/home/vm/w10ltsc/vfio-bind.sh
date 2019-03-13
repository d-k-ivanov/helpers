#!/usr/bin/env bash
modprobe vfio-pci
vendor=$(cat /sys/bus/pci/devices/0000:01:00.0/vendor)
device=$(cat /sys/bus/pci/devices/0000:01:00.0/device)
if [ -e /sys/bus/pci/devices/0000:01:00.0/driver ]; then
    echo 0000:01:00.0 > /sys/bus/pci/devices/0000:01:00.0/driver/unbind
fi
echo $vendor $device > /sys/bus/pci/drivers/vfio-pci/new_id

echo "vfio-pci" > /sys/bus/pci/devices/0000\:01\:00.0/driver_override
