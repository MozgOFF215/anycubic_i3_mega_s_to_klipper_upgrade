# Исправление `Timer too close` при работе только на 1 ядре CPU (Orange Pi 3 LTS)

Документ фиксирует реальный кейс нестабильности Klipper на Orange Pi 3 LTS.

## Симптомы

- Случайные ошибки homing на разных осях:
  - `Communication timeout during homing`
- Аварийная остановка Klipper:
  - `MCU 'mcu' shutdown: Timer too close`
- Ошибка проявляется не всегда (несколько homing подряд могут пройти успешно, потом снова сбой).

## Корневая причина

Хост работал только на одном ядре:
- `nproc` показывал `1`
- `/sys/devices/system/cpu/online` показывал `0`
- в kernel log:
  - `CPU1/CPU2/CPU3: failed to come online`

Основной триггер: смешанные ветки загрузочного стека:
- kernel/DTB были на `legacy`
- U-Boot оставался на `current`

Из-за этого ломался SMP startup, и появлялась нестабильность таймингов на стороне хоста для Klipper.

## Диагностика

```bash
uname -r
nproc
cat /sys/devices/system/cpu/online
dmesg | grep -Ei "CPU[1-3].*failed|SMP: Total|Internal error|Oops"
dpkg -l | grep -E "linux-u-boot|linux-image-legacy|linux-dtb-legacy"
```

## Рабочее исправление

1. Установить U-Boot той же ветки, что и kernel (legacy):

```bash
sudo apt update
sudo apt install --reinstall -y linux-u-boot-orangepi3-lts-legacy
```

2. Удалить конфликтующий пакет U-Boot ветки `current` (если установлен):

```bash
sudo apt purge -y linux-u-boot-orangepi3-lts-current
```

3. Переустановить kernel и DTB той же ветки:

```bash
sudo apt install --reinstall -y linux-image-legacy-sunxi64 linux-dtb-legacy-sunxi64
sudo update-initramfs -u
```

4. Перезаписать bootloader в eMMC:

```bash
sudo armbian-install
```

Выбрать:
- `Install/Update the bootloader on eMMC (/dev/mmcblk2)`

5. Перезагрузиться и проверить:

```bash
uname -r
nproc
cat /sys/devices/system/cpu/online
```

Ожидаемо:
- `6.6.75-legacy-sunxi64` (или выбранная legacy-версия)
- `nproc = 4`
- `online = 0-3`

## Результат после фикса

- `G28` стабильно проходит многократно
- `Timer too close` исчезает
- Нагрузка хоста и MCU в норме

