# Фикс камеры после смены ядра (crowsnest / ustreamer)

Этот документ фиксирует реальную проблему после переключения ядра на Orange Pi для исправления reboot.

## Проблема

После смены ядра камера перестала работать в Mainsail.

Наблюдалось:
- устройство камеры в `/dev/v4l/by-id/...` есть
- сервис `crowsnest` запущен
- порт стрима `8080` не слушается
- в логах:
  - `ERROR: Start of ustreamer [cam 1] failed!`
  - `WATCHDOG: Lost Device ...`

## Причина

В `crowsnest.conf` был задан неподдерживаемый FPS:
- настроено: `max_fps: 50`
- по возможностям камеры (`v4l2-ctl`): максимум `30 fps`

При некорректном FPS `ustreamer` не стартует.

## Диагностика

```bash
ls -l /dev/v4l/by-id/
v4l2-ctl -d /dev/video2 --list-formats-ext
sudo systemctl status crowsnest --no-pager -l
sudo journalctl -u crowsnest -n 120 --no-pager
ss -tulpen | grep -E ':8080|:8081'
```

## Что исправили

Поставили поддерживаемые параметры в `~/printer_data/config/crowsnest.conf`:

```ini
[cam 1]
mode: ustreamer
port: 8080
device: /dev/video2
resolution: 1280x720
max_fps: 15
```

Затем перезапуск:

```bash
sudo systemctl restart crowsnest
```

Проверка:

```bash
ss -tulpen | grep -E ':8080|:8081'
curl -I "http://127.0.0.1:8080/?action=stream"
```

## Рекомендуемый стабильный профиль

Для этой Sonix USB-камеры на Orange Pi:
- `resolution: 1280x720`
- `max_fps: 15` (стабильно)

Более высокий FPS выставлять только если он явно поддерживается в `v4l2-ctl --list-formats-ext`.

