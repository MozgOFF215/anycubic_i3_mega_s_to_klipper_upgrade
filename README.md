# Anycubic i3 Mega S to Klipper Upgrade

This repository collects notes and reference materials for migrating an Anycubic i3 Mega S from Marlin to Klipper.

## Repository Contents

- `marlin_backup_guide_anycubic_i_3_mega_s_via_orange_pi.md` - guide for backing up current Marlin settings before migration.
- `printer_cfg_guide.md` - draft `printer.cfg` reference for Klipper on the Anycubic i3 Mega S.
- `backup_marlin.txt` - captured Marlin firmware and `M503` output.

## Goal

The project is intended to help preserve the current printer configuration and make the move to Klipper safer and easier to reproduce.

## Recommended Workflow

1. Save the current Marlin configuration and EEPROM data.
2. Prepare or verify the Klipper `printer.cfg`.
3. Compare the backup values with the new Klipper configuration before flashing or switching firmware.

## Notes

Some existing source files appear to contain text encoding issues when viewed in the current shell. The original content is preserved as-is in this repository.
