# Подключение Orange Pi к Tailscale для доступа к Mainsail и камере

Эта инструкция позволяет открыть доступ к вашему Orange Pi (Mainsail + камера) с ноутбука и Android через приватную сеть Tailscale без проброса портов на роутере.

## Что получится в итоге

- Вы будете открывать Mainsail по адресу вида `http://100.x.x.x`.
- Камера будет доступна через Tailscale с того же ноутбука/телефона.
- Доступ будет только у устройств, авторизованных в вашем аккаунте Tailscale.

## 0) Что нужно заранее

- Orange Pi с установленными Klipper + Moonraker + Mainsail.
- Ноутбук и Android-смартфон.
- Один аккаунт Tailscale (можно бесплатный план).
- Доступ к терминалу Orange Pi (локально или по SSH).

## 1) Установка Tailscale на Orange Pi

На Orange Pi выполните:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

После команды `tailscale up` откроется ссылка для авторизации. Войдите в свой аккаунт Tailscale.

Проверка статуса:

```bash
tailscale status
tailscale ip -4
```

Сохраните IPv4 вида `100.x.x.x` - это адрес Orange Pi внутри Tailscale.

## 2) Подключение ноутбука и Android

1. Установите Tailscale на ноутбук:
   - Windows/macOS/Linux: [https://tailscale.com/download](https://tailscale.com/download)
2. Установите приложение Tailscale на Android из Google Play.
3. Войдите на обоих устройствах в тот же аккаунт, что и на Orange Pi.
4. Убедитесь, что в приложении/клиенте Tailscale статус `Connected`.

## 3) Проверка Mainsail через Tailscale

Откройте на ноутбуке:

```text
http://100.x.x.x
```

Если Mainsail у вас работает на другом порту, используйте:

```text
http://100.x.x.x:PORT
```

Также проверьте прямой доступ к Moonraker API:

```text
http://100.x.x.x:7125/printer/info
```

У вас в конфиге уже указано:
- `config/moonraker.conf`: `host: 0.0.0.0`
- `config/moonraker.conf`: `port: 7125`

Это корректно для доступа через Tailscale.

## 3.1) Если в Mainsail ошибка `Unauthorized`

Если Mainsail открывается, но пишет `Cannot connect to Moonraker ... Unauthorized`, добавьте диапазон Tailscale в доверенные клиенты Moonraker.

Откройте:

```bash
nano ~/printer_data/config/moonraker.conf
```

В секции `[authorization] -> trusted_clients` добавьте:

```ini
100.64.0.0/10
```

Пример:

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

Перезапустите Moonraker:

```bash
sudo systemctl restart moonraker
```

После этого обновите страницу Mainsail в браузере.

## 4) Проверка и подключение камеры

Обычно в связке MainsailOS/KIAUH камера идет через `crowsnest` и имеет один из портов:
- `8080` (MJPEG stream)
- `8081` (web/stream proxy)

На Orange Pi проверьте, какие порты реально слушаются:

```bash
ss -tulpen | grep -E ':80|:443|:7125|:8080|:8081'
```

Проверьте сервис камеры:

```bash
sudo systemctl status crowsnest --no-pager
```

Проверьте конфиг камеры:

```bash
cat ~/printer_data/config/crowsnest.conf
```

Далее с ноутбука/телефона откройте:

```text
http://100.x.x.x:8080
```

Если пусто, попробуйте `:8081` и/или путь из `crowsnest.conf`.

## 5) Настройка URL камеры в Mainsail

В Mainsail:
1. `Settings` -> `Webcams`.
2. Добавьте/измените URL потока на адрес через Tailscale, например:
   - `http://100.x.x.x:8080/?action=stream`
3. Сохраните и обновите страницу.

Примечание: если вы пользуетесь интерфейсом и дома, и удаленно, можно сделать два профиля камеры (локальный и Tailscale) и переключать нужный.

## 6) Базовая безопасность (рекомендуется)

1. Включите 2FA в аккаунте Tailscale.
2. В админке Tailscale удалите старые/неиспользуемые устройства.
3. Выключите `Exit Node` на устройствах, если не используете.
4. Не открывайте порты роутера для Mainsail/Moonraker, если используете Tailscale.

## 7) Быстрая диагностика, если не открывается

На Orange Pi:

```bash
tailscale status
tailscale ip -4
curl -I http://127.0.0.1
curl -I http://127.0.0.1:7125
ss -tulpen | grep -E ':80|:443|:7125|:8080|:8081'
```

На ноутбуке:

```bash
ping 100.x.x.x
```

Если `ping` есть, но веб не открывается:
- проверьте порт (возможно Mainsail не на 80),
- проверьте, что сервис веб-сервера и `moonraker` запущены,
- проверьте `crowsnest` для камеры.

## 8) Опционально: доступ только вашим устройствам

Можно дополнительно ограничить доступ через ACL в Tailscale (например, только ваш телефон и ноутбук к Orange Pi на порты 80/7125/8080). Это повышает безопасность даже внутри tailnet.
