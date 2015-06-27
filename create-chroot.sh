#!/bin/bash

mirror=http://dl-2.alpinelinux.org/alpine
version=v3.2
chroot_dir=rootfs
apk_tools=apk-tools-static-2.6.1-r0.apk

mkdir -p ${chroot_dir}

wget ${mirror}/${version}/main/x86_64/${apk_tools}
tar xf ${apk_tools}
sudo ./sbin/apk.static -X ${mirror}/${version}/main -U --allow-untrusted --root ${chroot_dir} --initdb add alpine-base alpine-sdk

# Create resolv.conf
echo 'nameserver 8.8.8.8' | sudo tee ${chroot_dir}/etc/resolv.conf

sudo mkdir -p ${chroot_dir}{/root,/etc/apk,/proc}

# Set up APK mirror
echo "${mirror}/${version}/main" | sudo tee ${chroot_dir}/etc/apk/repositories

## Mount /proc, /sys and /dev
sudo mount -t proc none ${chroot_dir}/proc
sudo mount -o bind /sys ${chroot_dir}/sys

## Clean up
rm -rf sbin
rm -f ${apk_tools}

## Create user
sudo chroot ${chroot_dir} adduser -D ${USER} -s /bin/sh
sudo chroot ${chroot_dir} passwd -d ${USER}
echo "yuya ALL=(ALL) NOPASSWD:ALL" | sudo tee -a ${chroot_dir}/etc/sudoers
git_name=`git config user.name`
git_email=`git config user.email`
sudo chroot ${chroot_dir} sudo -u ${USER} git config --global user.name "${git_name}"
sudo chroot ${chroot_dir} sudo -u ${USER} git config --global user.email "${git_email}"
sudo chroot ${chroot_dir} sudo -u ${USER} git clone git://dev.alpinelinux.org/aports /home/${USER}/aports
sudo chroot ${chroot_dir} mkdir -p /var/cache/distfiles
sudo chroot ${chroot_dir} chmod a+w /var/cache/distfiles
