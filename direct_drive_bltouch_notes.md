# Anycubic i3 Mega S: Direct Drive + BLTouch Notes

## Current baseline in this repo

- Printer: Anycubic i3 Mega S
- Firmware path: Klipper
- Current config: `printer.cfg`
- Current Z homing: two physical Z endstops
- Current leveling: no probe configured yet
- Current extruder config uses stock-style direct numbers (`rotation_distance: 7.92`)

Relevant places:

- `printer.cfg` lines 38-60: two Z steppers with physical endstops
- `printer.cfg` lines 63-80: current extruder section
- `add_context/printer_from_inet.cfg` lines 162-200: example `BLTouch` and `bed_mesh` blocks

## Practical conclusion

Both upgrades are realistic on the current machine:

1. `BLTouch` / `3DTouch` is the lower-risk upgrade and can be done on the current board.
2. Direct drive is also realistic, but it is a mechanical project first and a config project second.
3. The best sequence is:
   1. Stabilize mechanics and current Klipper config
   2. Add probe and mesh
   3. Only then change the toolhead / extruder to direct drive

Reason:

- A probe helps first-layer consistency right away.
- Direct drive changes moving mass, wiring, mount geometry, offsets, retraction, `rotation_distance`, and `pressure_advance`.
- If both are changed at once, debugging becomes much harder.

## Direct drive: what makes sense here

### What you gain

- shorter filament path
- much better control with TPU / flexible filaments
- smaller and more stable retractions
- usually lower `pressure_advance` than a long Bowden path

### What you pay for

- more weight on the X carriage
- need for a printed or custom carriage / mount
- possible need to rework part cooling
- new extruder calibration and often new resonance behavior

### Good candidate families

#### Orbiter 2.x

Good fit if you want a modern, compact direct drive and are okay printing or sourcing a custom mount.

Why it is attractive:

- compact body
- strong community support
- designed specifically as a direct-drive extruder

#### Sherpa Mini

Good fit if you prefer lightweight open hardware and are okay sourcing printed parts plus BOM items.

Why it is attractive:

- lightweight
- popular in DIY toolheads
- many community mounts exist

#### Titan Aero

Works, but feels less attractive as a fresh build unless you specifically want that integrated style.

Why it is less ideal here:

- older ecosystem
- often bulkier than newer compact options
- for an i3 Mega S today, Orbiter / Sherpa-style solutions are usually the cleaner path

### Recommendation

If the goal is "sensible upgrade without turning the printer into an endless project":

- first choice: Orbiter 2.x style setup
- second choice: Sherpa Mini
- only choose Titan Aero if you already have parts or a mount you trust

## BLTouch / 3DTouch: should you add it?

### Short answer

Yes, probably.

For this printer, `BLTouch` is a high-value upgrade because it reduces first-layer pain without requiring a full rebuild.

### Important nuance

Your printer currently uses two physical Z endstops. That is valuable because it can help keep the gantry square. If you move fully to probe-based Z homing, those switches stop being your main Z reference.

So the most practical view is:

- use the probe mainly for `bed_mesh` and easy Z offset management
- keep mechanical gantry squareness under control separately

If you later want true automatic gantry alignment, that becomes a separate project and depends on how you want to use the two Z motors and endstops in Klipper.

## What changes in Klipper for BLTouch

Based on the example already saved in `add_context/printer_from_inet.cfg`, the expected changes are:

1. Add a `[bltouch]` section
2. Switch `[stepper_z]` to `endstop_pin: probe:z_virtual_endstop`
3. Remove `position_endstop` from `[stepper_z]`
4. Add `[safe_z_home]`
5. Add `[bed_mesh]`
6. Calibrate `x_offset`, `y_offset`, and `z_offset`

Pins from the saved example:

- `sensor_pin: ^PE4`
- `control_pin: PB5`

These must still be verified against your actual wiring.

## Risks with cheap 3DTouch clones

- some clones need special Klipper flags
- some do not behave well with `QUERY_PROBE`
- some are less repeatable than a genuine BLTouch

If buying now, a genuine unit is safer. If using a clone, test carefully before trusting homing.

## Recommended implementation order

### Phase 1: current machine sanity

- verify X/Y/Z motion and endstops
- verify current extruder calibration
- make sure hotend and bed PID are sane

### Phase 2: add BLTouch

- mount probe
- confirm wiring
- add config blocks
- run `BLTOUCH_DEBUG` tests
- run `PROBE_CALIBRATE`
- run `BED_MESH_CALIBRATE`

### Phase 3: direct drive conversion

- choose extruder and carriage
- print / source mount
- reroute wiring
- set new extruder `rotation_distance` or `gear_ratio`
- recalibrate extrusion
- retune retraction and `pressure_advance`
- later do `input_shaper`

## Bottom line

For your printer, the sensible path is:

- `BLTouch` first
- direct drive second

If you want one combined end-state, the nicest practical combo is:

- compact direct drive extruder
- probe on the same carriage
- then full recalibration in Klipper

But doing both at once is higher risk than doing them in two passes.
