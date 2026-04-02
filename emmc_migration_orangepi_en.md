# Migrate Orange Pi system from microSD to eMMC (Armbian)

This guide describes a safe migration of an already configured Orange Pi system from `microSD` to internal `eMMC`.

## When to migrate

Migrate only after Klipper/Moonraker/Mainsail and network are stable on the current SD-based system.

## Prerequisites

- Current system boots from `microSD`.
- `eMMC` is detected.
- Used space on `/` fits into `eMMC` (with safety margin).
- You have local console/HDMI access in case IP changes after reboot.

## 1) Verify current source and target disks

```bash
findmnt -no SOURCE /
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
```

Typical expected state before migration:
- root (`/`) on `mmcblk0p1` (microSD),
- internal eMMC visible as `mmcblk2` (size around 7-8G on Orange Pi 3 LTS with 8GB eMMC).

## 2) Confirm that root data fits eMMC

```bash
df -h /
sudo du -xhd1 /home
sudo du -xhd1 /var
```

If needed, free some space first:

```bash
sudo apt clean
sudo journalctl --vacuum-time=7d
```

## 3) Run Armbian migration tool

```bash
sudo armbian-install
```

In the menu choose:
1. `Boot from eMMC - system on eMMC`
2. Target disk: `eMMC (/dev/mmcblk2)`
3. Filesystem: `ext4`

Then confirm formatting/writing to eMMC and wait until completion.

## 4) Power off and boot from eMMC

```bash
sudo poweroff
```

Then:
- remove microSD card,
- power on Orange Pi again.

## 5) Verify successful migration

```bash
findmnt -no SOURCE /
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
```

Success criteria:
- root (`/`) is on `mmcblk2p...` (eMMC),
- root size is around eMMC capacity (for 8GB eMMC typically about 7.0G usable).

## If boot fails without SD

1. Insert SD card and boot normally.
2. Run `sudo armbian-install` again.
3. Choose `Install/Update the bootloader on eMMC (/dev/mmcblk2)` (bootloader-only step).
4. Power off, remove SD, test again.

Also check whether device got a different IP after reboot (DHCP lease may change).

