# Camera fix after kernel switch (crowsnest / ustreamer)

This note documents a real issue after switching Orange Pi kernel to fix reboot behavior.

## Problem

After kernel switch, camera stopped working in Mainsail.

Observed:
- `/dev/v4l/by-id/...` camera device exists
- `crowsnest` service is running
- stream port `8080` is not listening
- logs show:
  - `ERROR: Start of ustreamer [cam 1] failed!`
  - `WATCHDOG: Lost Device ...`

## Root cause

`crowsnest.conf` used an unsupported frame rate:
- configured: `max_fps: 50`
- camera capability (from `v4l2-ctl`): up to `30 fps`

With invalid FPS, `ustreamer` failed to start.

## Diagnostics used

```bash
ls -l /dev/v4l/by-id/
v4l2-ctl -d /dev/video2 --list-formats-ext
sudo systemctl status crowsnest --no-pager -l
sudo journalctl -u crowsnest -n 120 --no-pager
ss -tulpen | grep -E ':8080|:8081'
```

## Fix applied

Use supported camera parameters in `~/printer_data/config/crowsnest.conf`:

```ini
[cam 1]
mode: ustreamer
port: 8080
device: /dev/video2
resolution: 1280x720
max_fps: 15
```

Then restart:

```bash
sudo systemctl restart crowsnest
```

Verify:

```bash
ss -tulpen | grep -E ':8080|:8081'
curl -I "http://127.0.0.1:8080/?action=stream"
```

## Recommended stable profile

For this Sonix USB camera on Orange Pi:
- `resolution: 1280x720`
- `max_fps: 15` (stable)

Higher FPS should only be set if explicitly supported by `v4l2-ctl --list-formats-ext`.

