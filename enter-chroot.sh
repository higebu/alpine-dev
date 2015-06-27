#!/bin/bash

chroot_dir=rootfs

## Enter chroot
sudo chroot ${chroot_dir} su - ${USER}
