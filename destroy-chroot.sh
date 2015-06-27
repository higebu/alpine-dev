#!/bin/bash

chroot_dir=rootfs

sudo umount ${chroot_dir}/proc
sudo umount ${chroot_dir}/sys
sudo rm -rf ${chroot_dir}
