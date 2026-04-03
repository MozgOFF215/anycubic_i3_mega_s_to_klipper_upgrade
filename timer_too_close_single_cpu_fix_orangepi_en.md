# Fix `Timer too close` with only one CPU online (Orange Pi 3 LTS)

This guide documents a real-world Klipper stability issue on Orange Pi 3 LTS.

## Symptoms

- Random homing failures on different axes:
  - `Communication timeout during homing`
- Klipper shutdown:
  - `MCU 'mcu' shutdown: Timer too close`
- Intermittent behavior (can pass several homing attempts, then fail).

## Root cause

Host was running with only one CPU core online:
- `nproc` returned `1`
- `/sys/devices/system/cpu/online` returned `0`
- kernel logs contained:
  - `CPU1/CPU2/CPU3: failed to come online`

Main trigger was a mixed boot stack:
- kernel/DTB on `legacy` branch
- U-Boot package still on `current` branch

This mismatch caused SMP bring-up failure and host-side timing instability for Klipper.

## How to diagnose

```bash
uname -r
nproc
cat /sys/devices/system/cpu/online
dmesg | grep -Ei "CPU[1-3].*failed|SMP: Total|Internal error|Oops"
dpkg -l | grep -E "linux-u-boot|linux-image-legacy|linux-dtb-legacy"
```

## Working fix

1. Install matching U-Boot for the same branch as kernel (legacy):

```bash
sudo apt update
sudo apt install --reinstall -y linux-u-boot-orangepi3-lts-legacy
```

2. Remove conflicting U-Boot branch package (if installed):

```bash
sudo apt purge -y linux-u-boot-orangepi3-lts-current
```

3. Reinstall kernel and DTB on the same branch:

```bash
sudo apt install --reinstall -y linux-image-legacy-sunxi64 linux-dtb-legacy-sunxi64
sudo update-initramfs -u
```

4. Rewrite bootloader to eMMC:

```bash
sudo armbian-install
```

Select:
- `Install/Update the bootloader on eMMC (/dev/mmcblk2)`

5. Reboot and verify:

```bash
uname -r
nproc
cat /sys/devices/system/cpu/online
```

Expected:
- `6.6.75-legacy-sunxi64` (or selected legacy version)
- `nproc = 4`
- `online = 0-3`

## Result after fix

- Repeated `G28` runs are stable
- `Timer too close` no longer appears
- Host and MCU loads stay in normal range

