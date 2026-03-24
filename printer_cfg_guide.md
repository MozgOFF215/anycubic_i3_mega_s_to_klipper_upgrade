# Klipper printer.cfg – Anycubic i3 Mega S (TriGorilla)

## Цель
Этот файл описывает ТОЛЬКО настройку `printer.cfg` для Klipper на Anycubic i3 Mega S.

---

## 1. Расположение файла

```bash
/home/mozgoff/printer_data/config/printer.cfg
```

Редактирование:
- через Mainsail (рекомендуется)
- или через SSH + nano

---

## 2. Полный рабочий конфиг

```ini
[include mainsail.cfg]

[mcu]
serial: /dev/serial/by-id/usb-Silicon_Labs_CP2102_USB_to_UART_Bridge_Controller_0001-if00-port0

[printer]
kinematics: cartesian
max_velocity: 300
max_accel: 3000
max_z_velocity: 5
max_z_accel: 100

# X Axis
[stepper_x]
step_pin: PF0
dir_pin: !PF1
enable_pin: !PD7
microsteps: 16
rotation_distance: 40
endstop_pin: ^!PE5
position_endstop: 0
position_max: 210
homing_speed: 50

# Y Axis
[stepper_y]
step_pin: PF6
dir_pin: PF7
enable_pin: !PF2
microsteps: 16
rotation_distance: 40
endstop_pin: ^!PL7
position_endstop: 0
position_max: 210
homing_speed: 50

# Z Axis (правый)
[stepper_z]
step_pin = PL3
dir_pin = PL1
enable_pin = !PK0
rotation_distance = 8
endstop_pin = ^!PD3
position_endstop = 0
position_max = 210
position_min = -5
homing_speed = 10

# Z Axis (левый)
[stepper_z1]
step_pin = PC1
dir_pin = PC3
enable_pin = !PC7
endstop_pin = ^!PL6
rotation_distance = 8

# Extruder
[extruder]
step_pin: PA4
dir_pin: PA6
enable_pin: !PA2
microsteps: 16
rotation_distance: 33.5
nozzle_diameter: 0.4
filament_diameter: 1.75
heater_pin: PB4
sensor_type: EPCOS 100K B57560G104F
sensor_pin: PK5
control: pid
min_temp: 0
max_temp: 260

# Bed
[heater_bed]
heater_pin: PH5
sensor_type: EPCOS 100K B57560G104F
sensor_pin: PK6
control: pid
min_temp: 0
max_temp: 110

# Fan
[fan]
pin: PH6

# Virtual SD
[virtual_sdcard]
path: /home/mozgoff/printer_data/gcodes
```

---

## 3. Проверка endstop

```gcode
QUERY_ENDSTOPS
```

Ожидается:
- все: open
- при нажатии: TRIGGERED

---

## 4. Проверка направлений (БЕЗ G28)

```gcode
G91
G1 X20
G1 Y20
G1 Z5
G90
```

### Правильные направления:
- X → вправо
- Y → стол назад
- Z → вверх

Если неправильно → инвертировать `dir_pin` (добавить `!`)

---

## 5. Первый безопасный homing

```gcode
G28 X
G28 Y
G28 Z
```

Только после этого:

```gcode
G28
```

---

## 6. Важные пины (уже подтверждены)

- X endstop → PE5
- Y endstop → PL7
- Z правый → PD3
- Z левый → PL6

---

## 7. Типичные ошибки

### Принтер не видит концевик
- неправильный pin
- забыли `^!`

### Ось едет не туда
- не инвертирован `dir_pin`

### Ошибка MCU
- неверный serial путь

---

## 8. После этого этапа

Дальше делать:

1. PID calibration
2. Extruder calibration
3. Bed leveling
4. Pressure advance
5. Input shaper

---

## 9. Команды Klipper

```gcode
STATUS
QUERY_ENDSTOPS
RESTART
FIRMWARE_RESTART
M112
```
