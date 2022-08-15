![Logo](https://cdn.discordapp.com/attachments/1002450787085066250/1002533777693745182/sunst0rmgithub.png)

# sunst0rm
iOS Tether Downgrader for checkm8 devices

Based on [this guide](https://github.com/mineek/iostethereddowngrade)

## please, please, please, DO NOT ask for help in any other discord. Developers not affiliated with sunst0rm are sick of getting issue after issue due to sunst0rm and I just don't want to irritate them, instead join the discord server linked below.
## Also: please DO NOT open issues at [futurerestore](https://github.com/futurerestore/futurerestore) when using sunst0rm, they're almost always NOT the fault of futurerestore.

## See [this guide](https://github.com/Arna13/sunst0rm-guide) for help
## You can also watch [this youtube video](https://www.youtube.com/watch?v=P1m_DsoWyb0) for a video tutorial
### If you still have problems, join the [Discord](https://discord.gg/TqVH6NBwS3) server for help

## Notes
- It is a *tethered* downgrade meaning you will have to boot tethered every single time from your PC if your battery dies or if you reboot your phone.
- On A10-A11 devices crucial functionality such as the Home Button, Audio, Microphone, Vibration does NOT work at the moment.
- You should NOT be tether downgrading your main device it is only recommended to tether downgrade a second device.
- See [iphonewiki](https://www.theiphonewiki.com/wiki/BORD) for boardconfigs and identifiers..
- `linux-patches/` contain patches that allow you to compile everything for linux, use `cd ${dir}`; `patch -p1 < $file` to apply them.
- the `bin/` directory is added to `$PATH` on script startup, so you can copy programs there.

## Requirements:
- Before installing to `${ROOT}`, `export ROOT=${PWD}` or `export ROOT=<root of project>`
- [libirecovery](https://github.com/libimobiledevice/libirecovery)
- [futurerestore (fork)](https://github.com/futurerestore/futurerestore)
  - futurerestore must be the nightly build. A compiled binary can be found [here](https://github.com/futurerestore/futurerestore/actions)
- [iBoot64patcher (fork)](https://github.com/Cryptiiiic/iBoot64Patcher)
  - Precompiled binaries for iBoot64Patcher can be found [here](https://github.com/Cryptiiiic/iBoot64Patcher/actions)
- [Kernel64patcher (fork)](https://github.com/iSuns9/Kernel64Patcher)
  - `gcc Kernel64Patcher.c -o Kernel64Patcher`
    - **linux**: `gcc Kernel64Patcher.c -o Kernel64Patcher -Iinclude-linux/` after patching.
  - `cp Kernel64Patcher ${ROOT:-/nonexist}/bin/`
- [img4tool](https://github.com/tihmstar/img4tool)
  - `./autogen.sh --prefix=$PWD/out --enable-static=yes --enable-shared=no`
  - `make install`
  - `cp out/bin/img4tool ${ROOT:-/nonexist}/bin/`
- [img4](https://github.com/xerub/img4lib)
  - `make`
  - `cp img4 ${ROOT:-/nonexist}/bin/`
- [ldid](https://github.com/ProcursusTeam/ldid)
  - `make`
  - `cp ldid ${ROOT:-/nonexist}/bin/`
- [restored_external64_patcher](https://github.com/iSuns9/restored_external64patcher)
  - `make`
  - `cp restored_external64_patcher ${ROOT:-/nonexist}/bin/`
- [asr64_patcher](https://github.com/exploit3dguy/asr64_patcher)
  - `make`
  - `cp asr64_patcher ${ROOT:-/nonexist}/bin/`
- [libdmg-hfsplus](https://github.com/planetbeing/libdmg-hfsplus) **for linux only**
  - `cmake .`
  - `cd hfs`
  - `make`
  - `cp hfsplus ${ROOT:-/nonexist}/bin/`
- [Python3](https://www.python.org/downloads)
   - Make sure you updated Python and are not using the bundled one in macOS
- Python dependencies
   - `pip3 install -r requirements.txt`
   - A device that is vulnerable to checkm8 (A7-A11 devices.), if your device is not vulnerable then you can *NOT* tether downgrade at all. 

**Make sure to use the forks listed above.**

## How to Use
| Option (short)  | Option (long)               | Description                              |
|-----------------|-----------------------------|------------------------------------------|
| `-i IPSW`       | `--ipsw IPSW`               | Path to IPSW                             |
| `-t SHSH2`      | `--blob SHSH2`              | Path to SHSH2                            |
| `-r`            | `--restore`                 | Restore mode                             |
| `-b`            | `--boot`                    | Boot mode                                |
| `-d BOARDCONFIG`| `--boardconfig BOARDCONFIG` | BoardConfig to use  (E.g: `d221ap`)      |
| `-kpp`          | `--kpp`                     | Use KPP (A9 or lower)                    |
| `-id IDENTIFIER`| `--identifier IDENTIFIER`   | Identifier to use  (E.g: `iPhone10,6`)   |
|                 | `--legacy`                  | Use Legacy Mode (iOS 11 or lower)        |
|                 | `--skip-baseband`           | Skip Baseband sending, do NOT do this if your device does have baseband this argument is only ment to be passed when your device does *not* have baseband such as WiFi only iPads. |
|                 | `--extra-ramdisk`           | Add files to the ramdisk from a `$file.tar.gz` file that extracts without a parent directory (`usr`, `var`, `Library` for example, must extract to `$PWD`). |
|                 | `--boot-arguments`          | Create boot images with custom arguments, for example `rd=md0` boots from ramdisk. See the [iPhoneWiki](https://www.theiphonewiki.com/wiki/Boot-args_(iBoot_variable)). |

#### Usage Notes:
  - `--extra-ramdisk`: *For a SSH ramdisk*, compile [xerub/sshrd](https://github.com/xerub/sshrd/blob/master/restored_external.c), `mv compiled_restored_external ${RAMDISK_HERE}/usr/local/bin/restored_external`, there's a active fork at [nick-botticelli/sshrd](https://github.com/nick-botticelli/sshrd) with a binary in the github-actions to use.
    - On restore, this script will override `asr` and `restored_external` when making the ramdisk.
    - On boot, a ramdisk will only be created when `--extra-ramdisk` is given.
    - **linux**: Try `sudo usbmuxd --foreground -p` if you can't connect to the device with usbmuxd (for example `iproxy 2222 22`).
  - `--boot-arguments`: *For a SSH ramdisk*, set these to `rd=md0` after creating a boot image using `--extra-ramdisk ${ramdisk}.tar.gz` that spawns dropbear/openssh on whatever port.
    - Connect to the device using `iproxy 2222 ${port}`; `ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@localhost -p ${port}`

### Restoring
```py
./sunstorm.py -i 'IPSW' -t 'SHSH2' -r -d 'BOARDCONFIG'
```
- Use `--kpp` if you have KPP, otherwise don't add
- A10+ Devices do NOT have KPP so do not add `--kpp` if you are attempting to tether downgrade an A10+ device, A7-A9X devices does have KPP so that means you will pass `--kpp` and to clear things up having KPP or not does not change the fact if you are able to tether downgrade your device.
### Booting
```py
./sunstorm.py -i 'IPSW' -t 'SHSH2' -b -d 'BOARDCONFIG' -id 'IDENTIFIER'
```
- Use `--kpp` if you have KPP, otherwise don't add
```
./boot.sh
```

## Credits:
[M1n1Exploit](https://github.com/Mini-Exploit) - Some code from ra1nstorm

[Arna13](https://github.com/Arna13) - Writing an easy to understand [guide](https://github.com/Arna13/sunst0rm-guide)

[verygenericname](https://github.com/verygenericname) - [SSHRD_Script](https://github.com/verygenericname/SSHRD_Script) for showing how to get dropbear started via [xerub/sshrd](https://github.com/xerub/sshrd/blob/master/restored_external.c) because I'm dumb

swayea#1655 - Logo's
