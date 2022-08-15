#!/usr/bin/env bash

echo 'Ensure device is in pwnDFU mode with sigchecks removed.'
sleep 1

irecovery -f ./iBSS.img4
# send iBSS again.
irecovery -f ./iBSS.img4
irecovery -f ./iBEC.img4
irecovery -f ./bootlogo.img4
irecovery -c "setpicture 0"
irecovery -c "bgcolor 0 0 0"
sleep 3
if [[ -f "./ramdisk.img4" ]]; then
  irecovery -f ./ramdisk.img4
  irecovery -c ramdisk
fi
irecovery -f ./devicetree.img4
irecovery -c devicetree
irecovery -f ./trustcache.img4
irecovery -c firmware
irecovery -f ./krnlboot.img4
irecovery -c bootx
