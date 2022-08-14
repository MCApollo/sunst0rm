#!/usr/bin/env bash

export RETRY=3
export SUDO=sudo

# Check for futurerestore's linux_fix.sh - removes the need for sudo
if [[ -f "/usr/lib/udev/rules.d/39-libirecovery.rules" ]]; then
  export SUDO=""
fi

read -t 5 -p "Enter DFU to pwn & boot: (enter to continue)";

try () {
    let i=0;

    echo "Trying '${@}'";

    while ! ${SUDO} ${@}; do
        if [[ ${i} > ${RETRY} ]]; then
            echo "Failed to run '${@}'";
            exit 1
        fi;

        let i++;
    done;
}

set -v

try gaster pwn
try irecovery -f ./ibss.img4
try irecovery -f ./ibss.img4
try irecovery -f ./ibec.img4
try irecovery -c "bgcolor 255 255 255"
sleep 1
if [[ -f "./ramdisk.img4" ]]; then
  try irecovery -f ./ramdisk.img4
  try irecovery -c ramdisk
fi
try irecovery -f ./devicetree.img4
try irecovery -c devicetree
try irecovery -f ./trustcache.img4
try irecovery -c firmware
try irecovery -f ./krnlboot.img4
try irecovery -c bootx
