#!/usr/bin/env bash
export QEMU_AUDIO_DRV=pa
# qemu-system-x86_64 -audio-help | awk '/Name: pa/' RS=
# 
sudo unmount -f /home/storage
sudo chown root:kvm /dev/sda2

exec qemu-system-x86_64 -enable-kvm                                             \
        -machine type=q35,accel=kvm                                             \
        -device intel-iommu                                                     \
        -cpu host -smp 4                                                        \
        -drive file=hdd.img,if=virtio                                           \
        -drive file=/dev/sda2,cache=none,if=virtio                              \
        -net nic,model=rtl8139                                                  \
        -net user,hostname=divanov-dev-win                                      \
        -m 8G                                                                   \
        -name "divanov-dev-win"                                                 \
        -vga qxl                                                                \
        -display gtk                                                            \
        -soundhw hda                                                            \
        "$@"



        # -spice port=5930,disable-ticketing                                      \
        # -device virtio-serial                                                   \
        # -chardev spicevmc,id=spicechannel0,name=vdagent                         \
        # -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0    \
        # -display gtk                                                            \
        # -device usb-tablet                              \
        # -monitor stdio                                  \

# exec spicy -h 127.0.0.1 -p 5930

# sudo chown root:disc /dev/sda2
# sudo unmount -f /home/storage