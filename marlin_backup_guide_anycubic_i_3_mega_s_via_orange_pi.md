# Marlin Backup Guide (Anycubic i3 Mega S via Orange Pi + Python TCP bridge)

## 🎯 Цель
Сохранить все настройки Marlin (EEPROM), чтобы можно было полностью восстановить состояние принтера после перехода на Klipper.

---

## ⚠️ Что именно сохраняем

В Marlin нет "файла настроек" — всё хранится в EEPROM.

Команда:

```
M503
```

возвращает ВСЕ текущие параметры:

- Steps (M92)
- PID (M301, M304)
- Acceleration (M201)
- Jerk (M205)
- Offsets (M206, M666)
- Mesh leveling (G29 S3 ...)

👉 Это и есть твой полный бэкап.

---

## 🔧 Подготовка

### 1. На Orange Pi остановить Klipper

```
sudo systemctl stop klipper
```

---

### 2. Определить имя USB-порта принтера

На Orange Pi выполнить:

```bash
ls /dev/serial/by-id/
```

Ожидается что-то вроде:

```bash
usb-Silicon_Labs_CP2102_USB_to_UART_Bridge_Controller_0001-if00-port0
```

Полный путь к порту будет:

```bash
/dev/serial/by-id/usb-Silicon_Labs_CP2102_USB_to_UART_Bridge_Controller_0001-if00-port0
```

> Использовать именно путь из `/dev/serial/by-id/`, а не `/dev/ttyUSB0`, потому что он стабильнее.

---

### 3. Запустить TCP мост через Python + pyserial

Создай файл, например:

```bash
nano ~/serial_tcp_bridge.py
```

Вставь следующий код:

```python
import socket
import threading
import serial

SERIAL_PORT = "/dev/serial/by-id/usb-Silicon_Labs_CP2102_USB_to_UART_Bridge_Controller_0001-if00-port0"
BAUDRATE = 250000
TCP_HOST = "0.0.0.0"
TCP_PORT = 5000

ser = serial.Serial(SERIAL_PORT, BAUDRATE, timeout=0)

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server.bind((TCP_HOST, TCP_PORT))
server.listen(1)

print(f"Listening on {TCP_HOST}:{TCP_PORT} -> {SERIAL_PORT} @ {BAUDRATE}")

def handle_client(conn, addr):
    print(f"Client connected: {addr}")

    stop_flag = False

    def tcp_to_serial():
        nonlocal stop_flag
        try:
            while not stop_flag:
                data = conn.recv(1024)
                if not data:
                    break
                ser.write(data)
        except Exception as e:
            print(f"tcp_to_serial error: {e}")
        stop_flag = True

    def serial_to_tcp():
        nonlocal stop_flag
        try:
            while not stop_flag:
                data = ser.read(1024)
                if data:
                    conn.sendall(data)
        except Exception as e:
            print(f"serial_to_tcp error: {e}")
        stop_flag = True

    t1 = threading.Thread(target=tcp_to_serial, daemon=True)
    t2 = threading.Thread(target=serial_to_tcp, daemon=True)
    t1.start()
    t2.start()

    t1.join()
    t2.join()

    conn.close()
    print(f"Client disconnected: {addr}")

while True:
    conn, addr = server.accept()
    handle_client(conn, addr)
```

---

### 4. Установить зависимость

```bash
sudo apt install python3-serial -y
```

---

### 5. Запустить

```bash
python3 ~/serial_tcp_bridge.py
```

После запуска ты увидишь:

```text
Listening on 0.0.0.0:5000
```

---

## 💻 Подключение через Repetier-Host (Windows)

### Настройки:

- Connection: TCP/IP
- IP: `192.168.178.48`
- Port: `5000`
- Baudrate: `250000`

Нажать **Connect**

---

## 📥 Снятие бэкапа

### 1. Проверка связи

```
M115
```

Должен прийти ответ с версией Marlin.

---

### 2. Получение настроек

```
M503
```

---

### 3. Сохранение

Скопировать ВЕСЬ вывод консоли и сохранить в файл:

```
marlin_backup_YYYY-MM-DD.txt
```

---

## 📌 Что особенно важно проверить

Убедись, что в бэкапе есть:

### Steps
```
M92 X... Y... Z... E...
```

### PID Hotend
```
M301 P... I... D...
```

### PID Bed
```
M304 P... I... D...
```

### Mesh leveling
```
G29 S3 X... Y... Z...
```

### Offsets
```
M206 ...
M666 ...
```

---

## 🔄 Как восстановить Marlin

После возврата на Marlin:

1. Подключиться к принтеру
2. Ввести все команды из бэкапа:

```
M92 ...
M301 ...
M304 ...
M206 ...
M666 ...
G29 S3 ...
```

3. Сохранить:

```
M500
```

---

## 🧠 Важно помнить

- В этом сценарии использовался **Python + pyserial TCP bridge**, а не `socat`
- Klipper НЕ использует EEPROM
- Все настройки в Klipper будут в `printer.cfg`
- Этот бэкап нужен только для возврата на Marlin

---

## 🚀 Рекомендуется дополнительно

- Сделать фото экрана принтера
- Сохранить версию прошивки (M115)
- Сохранить файл в облако

---

## ✅ Готово

Теперь у тебя есть полный бэкап состояния принтера.

Можно безопасно переходить на Klipper 😄

