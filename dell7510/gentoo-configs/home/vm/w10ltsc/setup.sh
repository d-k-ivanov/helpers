#!/bin/sh
exec qemu-system-x86_64 -enable-kvm                 \
        -cpu host                                   \
        -drive file=hdd.img,if=virtio               \
        -net nic -net user,hostname=divanov-dev-win \
        -m 16G                                      \
        -monitor stdio                              \
        -name "divanov-dev-win"                     \
        -boot d                                     \
        -drive file=win10ltsc.iso,media=cdrom       \
        -drive file=drivers.iso,media=cdrom
