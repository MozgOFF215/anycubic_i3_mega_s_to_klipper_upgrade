# Connect Orange Pi to Tailscale (Mainsail + Camera)

This guide gives you remote access to your Orange Pi (Mainsail + camera) from a laptop and Android phone over a private Tailscale network, without opening router ports.

## Result

- You can open Mainsail via `http://100.x.x.x`.
- Camera is reachable through Tailscale from laptop/phone.
- Only devices authorized in your Tailscale account can access it.

## 0) Prerequisites

- Orange Pi with Klipper + Moonraker + Mainsail.
- Laptop and Android smartphone.
- One Tailscale account (free plan is usually enough).
- Terminal access to Orange Pi (local or SSH).

## 1) Install Tailscale on Orange Pi

Run on Orange Pi:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

After `tailscale up`, you will get a login URL. Open it in browser and sign in to Tailscale.

Check status:

```bash
tailscale status
tailscale ip -4
```

Save the IPv4 like `100.x.x.x` - this is your Orange Pi Tailscale IP.

## 2) Connect laptop and Android

1. Install Tailscale on laptop:
   - Windows/macOS/Linux: [https://tailscale.com/download](https://tailscale.com/download)
2. Install Tailscale app on Android from Google Play.
3. Sign in on both devices with the same Tailscale account used in step 1.
4. Confirm status is `Connected`.

## 3) Test Mainsail over Tailscale

Open on laptop:

```text
http://100.x.x.x
```

If your UI is on a non-default port:

```text
http://100.x.x.x:PORT
```

Moonraker API test:

```text
http://100.x.x.x:7125/printer/info
```

Your config is already correct for Tailscale:
- `config/moonraker.conf`: `host: 0.0.0.0`
- `config/moonraker.conf`: `port: 7125`

## 3.1) If Mainsail shows `Unauthorized`

If Mainsail opens but shows `Cannot connect to Moonraker ... Unauthorized`, add Tailscale network range to Moonraker trusted clients.

Edit:

```bash
nano ~/printer_data/config/moonraker.conf
```

In `[authorization] -> trusted_clients`, add:

```ini
100.64.0.0/10
```

Example:

```ini
[authorization]
trusted_clients:
    192.168.0.0/16
    10.0.0.0/8
    127.0.0.0/8
    169.254.0.0/16
    172.16.0.0/12
    FC00::/7
    FE80::/10
    ::1/128
    100.64.0.0/10
```

Restart Moonraker:

```bash
sudo systemctl restart moonraker
```

Then reload Mainsail in browser.

## 4) Check and expose camera

In common MainsailOS/KIAUH setups, camera runs via `crowsnest`, often on:
- `8080` (MJPEG stream)
- `8081` (web/stream proxy)

On Orange Pi, check listening ports:

```bash
ss -tulpen | grep -E ':80|:443|:7125|:8080|:8081'
```

Check camera service:

```bash
sudo systemctl status crowsnest --no-pager
```

Check camera config:

```bash
cat ~/printer_data/config/crowsnest.conf
```

Then test from laptop/phone:

```text
http://100.x.x.x:8080
```

If empty, also test `:8081` and the exact path from `crowsnest.conf`.

## 5) Set camera URL in Mainsail

In Mainsail:
1. `Settings` -> `Webcams`.
2. Set stream URL to Tailscale address, for example:
   - `http://100.x.x.x:8080/?action=stream`
3. Save and refresh page.

Tip: if you use both home LAN and remote access, create two webcam profiles (LAN + Tailscale).

## 6) Security basics (recommended)

1. Enable 2FA in your Tailscale account.
2. Remove old/unknown devices from Tailscale admin.
3. Do not open router ports for Mainsail/Moonraker when using Tailscale.

## 7) Quick troubleshooting

On Orange Pi:

```bash
tailscale status
tailscale ip -4
curl -I http://127.0.0.1
curl -I http://127.0.0.1:7125
ss -tulpen | grep -E ':80|:443|:7125|:8080|:8081'
```

On laptop:

```bash
ping 100.x.x.x
```

If `ping` works but web does not:
- verify the correct port,
- verify web server and moonraker are running,
- verify `crowsnest` for camera.

## 8) Optional: restrict access to your own devices only

You can add Tailscale ACL rules (for example, only your laptop + Android can reach Orange Pi ports 80/7125/8080). This gives an extra security layer inside your tailnet.
