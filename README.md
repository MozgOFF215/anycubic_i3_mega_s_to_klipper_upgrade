# Anycubic i3 Mega S to Klipper Upgrade

This repository collects notes and reference materials for migrating an Anycubic i3 Mega S from Marlin to Klipper.

## Repository Contents

- `marlin_backup_guide_anycubic_i_3_mega_s_via_orange_pi.md` - guide for backing up current Marlin settings before migration.
- `printer_cfg_guide.md` - draft `printer.cfg` reference for Klipper on the Anycubic i3 Mega S.
- `backup_marlin.txt` - captured Marlin firmware and `M503` output.
- `emmc_migration_orangepi_en.md` - step-by-step guide to migrate Armbian from microSD to eMMC.
- `emmc_migration_orangepi_ru.md` - Russian version of the Armbian microSD-to-eMMC migration guide.
- `reboot_poweroff_fix_orangepi_en.md` - troubleshooting and fix for reboot/poweroff issues on Orange Pi.
- `reboot_poweroff_fix_orangepi_ru.md` - Russian troubleshooting guide for reboot/poweroff issues on Orange Pi.
- `camera_fix_crowsnest_after_kernel_switch_en.md` - camera recovery steps when crowsnest/ustreamer fails after kernel switch.
- `camera_fix_crowsnest_after_kernel_switch_ru.md` - Russian camera fix guide for crowsnest/ustreamer after kernel switch.
- `tailscale_orangepi_setup_en.md` - Tailscale setup guide for remote access to Mainsail and camera.
- `tailscale_orangepi_setup_ru.md` - Russian Tailscale setup guide for Mainsail and camera.
- `smart_plug_setup_smartlife_ru_en.md` - bilingual Smart Life smart plug setup notes.
- `direct_drive_bltouch_notes.md` - notes for direct drive and BLTouch related changes.
- `macros_reference.md` - Klipper macro reference (English).
- `macros_reference_ru.md` - Klipper macro reference (Russian).
- `klipper_orca_speed_quality_plan.md` - speed and quality tuning plan for Klipper and OrcaSlicer.
- `orca_tuning_iterations.md` - iterative Orca tuning log and adjustments.
- `orca_start_code_klipper.txt` - OrcaSlicer start G-code for Klipper.
- `orca_end_code_klipper.txt` - OrcaSlicer end G-code for Klipper.
- `orca_start_code_klipper_old.txt` - previous Klipper start G-code version.
- `orca_end_code_klipper_old.txt` - previous Klipper end G-code version.
- `orca_start_code_marlin.txt` - OrcaSlicer start G-code for Marlin.
- `orca_end_code_marlin.txt` - OrcaSlicer end G-code for Marlin.

## Goal

The project is intended to help preserve the current printer configuration and make the move to Klipper safer and easier to reproduce.

## Recommended Workflow

1. Save the current Marlin configuration and EEPROM data.
2. Prepare or verify the Klipper `printer.cfg`.
3. Compare the backup values with the new Klipper configuration before flashing or switching firmware.

## Notes

Some existing source files may contain text encoding artifacts when viewed in certain shells. The original content is preserved as-is in this repository.
