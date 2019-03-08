#!/bin/sh
exec qemu-system-x86_64 -enable-kvm                     \
        -cpu host,kvm=off                               \
        -drive file=hdd.img,if=virtio                   \
        -net nic -net user,hostname=divanov-dev-win     \
        -m 16G                                          \
        -monitor stdio                                  \
        -name "divanov-dev-win"                         \
        -device vfio-pci,host=01:00.0,x-vga=on          \
        -vga none
        "$@"
