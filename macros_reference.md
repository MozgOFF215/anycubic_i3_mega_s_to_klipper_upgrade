# Klipper Macros Reference (Current Config)

This document describes the macros currently used in:
- `config/mainsail.cfg`
- `config/beeper.cfg`

## Where Macros Live

- User-visible runtime macros:
  - `M300` (from `config/beeper.cfg`)
  - `PAUSE`, `RESUME`, `CANCEL_PRINT` (from `config/mainsail.cfg`)
  - `SET_PAUSE_NEXT_LAYER`, `SET_PAUSE_AT_LAYER` (from `config/mainsail.cfg`)
- Internal/service macros (not intended for direct daily use):
  - `SET_PRINT_STATS_INFO`
  - `_TOOLHEAD_PARK_PAUSE_CANCEL`
  - `_CLIENT_EXTRUDE`
  - `_CLIENT_RETRACT`
  - `_CLIENT_LINEAR_MOVE`

---

## 1) `M300` (beeper tone)

Defined in: `config/beeper.cfg`

Purpose:
- Plays a beep for notifications in start/end g-code.

Parameters:
- `S` - tone frequency (Hz), default `1000`, clamped to `0..4000`
- `P` - beep duration in ms, default `120`
- `G` - pause after beep in ms, default `80`

Examples:
```gcode
M300
M300 S1000 P200
M300 S1800 P120
M300 S2200 P220 G120
```

Notes:
- If you ever need active-buzzer behavior, toggle variable at runtime:
```gcode
SET_GCODE_VARIABLE MACRO=M300 VARIABLE=active_buzzer VALUE=1
```
- Back to passive tone mode:
```gcode
SET_GCODE_VARIABLE MACRO=M300 VARIABLE=active_buzzer VALUE=0
```

---

## 2) `PAUSE`, `RESUME`, `CANCEL_PRINT`

Defined in: `config/mainsail.cfg`

Purpose:
- Enhanced print control macros from Mainsail client config.
- They wrap base Klipper behavior and add retract, park, idle-timeout handling, and safety checks.

Typical usage:
```gcode
PAUSE
RESUME
CANCEL_PRINT
```

Behavior highlights:
- `PAUSE` parks toolhead and retracts filament.
- `RESUME` checks temperature (and optional runout sensor logic) before continuing.
- `CANCEL_PRINT` retracts, optionally parks, turns off heaters/fan, clears pause-layer flags.

---

## 3) Layer-triggered pause macros

Defined in: `config/mainsail.cfg`

### `SET_PAUSE_NEXT_LAYER`
Purpose:
- Pause on next layer transition.

Usage:
```gcode
SET_PAUSE_NEXT_LAYER ENABLE=1
SET_PAUSE_NEXT_LAYER ENABLE=0
SET_PAUSE_NEXT_LAYER ENABLE=1 MACRO=PAUSE
```

### `SET_PAUSE_AT_LAYER`
Purpose:
- Pause at exact layer number.

Usage:
```gcode
SET_PAUSE_AT_LAYER LAYER=10
SET_PAUSE_AT_LAYER ENABLE=0
SET_PAUSE_AT_LAYER LAYER=25 MACRO=PAUSE
```

---

## 4) Internal macros (for reference)

These are used by the main macros and should usually not be called manually:

- `SET_PRINT_STATS_INFO`:
  - Intercepts print stats to trigger pause-at-layer/next-layer actions.
- `_TOOLHEAD_PARK_PAUSE_CANCEL`:
  - Shared park routine for pause/cancel.
- `_CLIENT_EXTRUDE`, `_CLIENT_RETRACT`:
  - Safe helper extrusion/retraction logic.
- `_CLIENT_LINEAR_MOVE`:
  - Utility move macro with state save/restore.

---

## 5) Safe customization points

Preferred ways to customize behavior without editing read-only `mainsail.cfg`:

1. Keep your own macros in separate include files (example: `config/beeper.cfg`).
2. Use slicer start/end g-code to call existing macros (`M300`, `PAUSE`, etc.).
3. If needed, add `_CLIENT_VARIABLE` section into `printer.cfg` (as advised in comments of `mainsail.cfg`) to tune pause/resume behavior cleanly.

---

## Quick Test Commands

```gcode
M300 S1200 P120
M300 S1800 P120
PAUSE
RESUME
SET_PAUSE_NEXT_LAYER ENABLE=1
SET_PAUSE_AT_LAYER LAYER=5
```

