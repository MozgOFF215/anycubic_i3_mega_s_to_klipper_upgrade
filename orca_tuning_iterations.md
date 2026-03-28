# OrcaSlicer Tuning Iterations (Klipper / Anycubic i3 Mega S)

## Scope

- Process profile: `OrcaSlicerConfig/process/0.20mm Standard @Anycubic i3MegaS - klipper.json`
- Machine profile: `OrcaSlicerConfig/machine/Anycubic i3 Mega S 0.4 nozzle klipper.json`
- Filament profile: `OrcaSlicerConfig/filament/Anycubic Generic PLA - klipper.json`

---

## Version Map

| Version | Commit | Meaning |
|---|---|---|
| `v1-override_created` | `f9c235d` | initial user override snapshot |
| `v2-speed_baseline` | `f2a5776` | first fast baseline for Klipper |
| `v3-orca_normalized` | `5bcdf26` | Orca auto-normalized state after first run |
| `v4-quality_pass` | `efb7103` | quality-focused pass after PA setup |
| `v5-soft_1_5h` | `fea2e5c` | slower profile toward ~1.5h |
| `v6-target_1h30` | `65150b6` | tuned profile toward ~1:30 target |

---

## Versioned Snapshot Files

Each version has 3 files (`process`, `machine`, `filament`) with version in filename.

### Process

- `OrcaSlicerConfig/versions/process/0.20mm Standard @Anycubic i3MegaS - klipper.v1-override_created.json`
- `OrcaSlicerConfig/versions/process/0.20mm Standard @Anycubic i3MegaS - klipper.v2-speed_baseline.json`
- `OrcaSlicerConfig/versions/process/0.20mm Standard @Anycubic i3MegaS - klipper.v3-orca_normalized.json`
- `OrcaSlicerConfig/versions/process/0.20mm Standard @Anycubic i3MegaS - klipper.v4-quality_pass.json`
- `OrcaSlicerConfig/versions/process/0.20mm Standard @Anycubic i3MegaS - klipper.v5-soft_1_5h.json`
- `OrcaSlicerConfig/versions/process/0.20mm Standard @Anycubic i3MegaS - klipper.v6-target_1h30.json`

### Machine

- `OrcaSlicerConfig/versions/machine/Anycubic i3 Mega S 0.4 nozzle klipper.v1-override_created.json`
- `OrcaSlicerConfig/versions/machine/Anycubic i3 Mega S 0.4 nozzle klipper.v2-speed_baseline.json`
- `OrcaSlicerConfig/versions/machine/Anycubic i3 Mega S 0.4 nozzle klipper.v3-orca_normalized.json`
- `OrcaSlicerConfig/versions/machine/Anycubic i3 Mega S 0.4 nozzle klipper.v4-quality_pass.json`
- `OrcaSlicerConfig/versions/machine/Anycubic i3 Mega S 0.4 nozzle klipper.v5-soft_1_5h.json`
- `OrcaSlicerConfig/versions/machine/Anycubic i3 Mega S 0.4 nozzle klipper.v6-target_1h30.json`

### Filament

- `OrcaSlicerConfig/versions/filament/Anycubic Generic PLA - klipper.v1-override_created.json`
- `OrcaSlicerConfig/versions/filament/Anycubic Generic PLA - klipper.v2-speed_baseline.json`
- `OrcaSlicerConfig/versions/filament/Anycubic Generic PLA - klipper.v3-orca_normalized.json`
- `OrcaSlicerConfig/versions/filament/Anycubic Generic PLA - klipper.v4-quality_pass.json`
- `OrcaSlicerConfig/versions/filament/Anycubic Generic PLA - klipper.v5-soft_1_5h.json`
- `OrcaSlicerConfig/versions/filament/Anycubic Generic PLA - klipper.v6-target_1h30.json`

---

## Process Parameter Summary by Version

| Version | default accel | outer (speed/accel) | inner (speed/accel) | sparse infill (speed/accel) | top (speed/accel) | travel (speed/accel) | Notes |
|---|---:|---|---|---|---|---|---|
| `v1-override_created` | - | - | - | - | - | - | only `inherits` |
| `v2-speed_baseline` | 1800 | 50 / 1500 | 100 / 2500 | 140 / 2500 | 40 / 1200 | 200 / 2500 | initial layer speed = 25 |
| `v3-orca_normalized` | 1800 | 50 / 1500 | 100 / 2500 | 140 / 2500 | top speed removed by Orca | 200 / 2500 | added `print_extruder_variant` |
| `v4-quality_pass` | 1700 | 40 / 1000 | 100 / 2500 | 140 / 2500 | 35 / 1200 | 200 / 2500 | seam position = rear |
| `v5-soft_1_5h` | 1200 | 35 / 900 | 65 / 1600 | 80 / 1600 | 30 / 1000 | 150 / 1800 | quality-focused slowdown |
| `v6-target_1h30` | 1000 | 35 / 850 | 55 / 1300 | 68 / 1300 | 28 / 900 | 130 / 1500 | current target profile |

---

## Machine and Filament Milestones

### Machine milestones

- `v2-speed_baseline`: machine limits for Klipper speed baseline, retract = `4.0 / 35`
- `v3-orca_normalized`: Orca restored `printer_extruder_variant` and added `print_host`
- `v4-quality_pass`: retraction length `4.0 -> 4.5`
- safety patch (`576f6d3`): end gcode safe Z lift (`G91 -> G1 Z10 -> G90`)

### Filament milestones

- `v3-orca_normalized`: Orca restored `filament_extruder_variant`
- `v4-quality_pass`: `slow_down_layer_time = 12`

---

## Related Klipper Milestone

- `cf6b53d`: set `pressure_advance: 0.22` and `square_corner_velocity: 5.0` in `config/printer.cfg`

