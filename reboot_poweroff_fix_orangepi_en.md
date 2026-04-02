# Orange Pi reboot/poweroff fix (Armbian, Anycubic/Klipper setup)

This document captures a real troubleshooting case where:
- `sudo reboot` disconnected SSH but the board did not come back until manual power cycle,
- `poweroff` behavior was inconsistent before kernel switch.

After applying the fix below, both `reboot` and `poweroff` worked correctly.

## Environment

- Board: Orange Pi 3 LTS
- OS: Armbian
- Initial kernel with issue: `6.12.68-current-sunxi64`
- Stable kernel after fix: `6.16.8` via `linux-image-edge-sunxi64=25.8.2`

## Symptoms

1. `sudo systemctl reboot`:
   - SSH connection resets,
   - board does not come back online,
   - only physical power off/on restores the system.
2. `sudo systemctl poweroff` could also behave unexpectedly before fix.

## Key diagnostic signals

With persistent journal enabled, previous boot logs showed:
- `cpufreq-dt: Worker [...] terminated by signal 11 (SEGV)`
- `CPU1/CPU2/CPU3: failed to come online`
- debug-kernel notice (`trace_printk() ... DEBUG kernel ... unsafe for production`)

This points to a kernel/CPU-frequency initialization issue, not to eMMC migration itself.

## Enable persistent journal (required for debugging)

```bash
sudo mkdir -p /var/log/journal
sudo chown root:systemd-journal /var/log/journal
sudo chmod 2755 /var/log/journal
sudo sed -i 's/^#\?Storage=.*/Storage=persistent/' /etc/systemd/journald.conf
sudo systemctl restart systemd-journald
sudo journalctl --flush
```

## Fix: switch to an alternative kernel

Run:

```bash
sudo armbian-config
```

Navigate:
- `System` -> `Kernel` -> `Use alternative kernels`
- `Show only mainstream kernels?` -> choose `No`
- install: `linux-image-edge-sunxi64=25.8.2` (`v6.16.8`)

Reboot after installation.

## Validation checklist

1. Check active kernel:

```bash
uname -r
```

Expected: `6.16.8` (or another stable non-problematic version you selected).

2. Test reboot at least 2 times:

```bash
sudo systemctl reboot
```

3. Test poweroff:

```bash
sudo systemctl poweroff
```

Expected after fix:
- board powers off correctly,
- LEDs may turn off completely (board-dependent),
- pressing power button starts normal boot.

## Notes

- This issue can exist both before and after SD->eMMC migration.
- If reboot fails again on a future kernel, re-test with another stable branch (`current` vs `edge` vs `legacy`) using `armbian-config`.

