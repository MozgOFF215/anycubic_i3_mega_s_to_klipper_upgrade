# Smart Plug Setup (Smart Life) - RU/EN

## RU: Шаг 1 - Подключение розетки к Smart Life

### Что нужно
- Смартфон с интернетом.
- Домашний Wi-Fi 2.4 GHz (обязательно для большинства Tuya/Smart Life розеток).
- Приложение `Smart Life` (или `Tuya Smart`).
- Розетка подключена к питанию рядом с роутером на время настройки.

### 1) Установить приложение и войти
1. Установите `Smart Life` из App Store или Google Play.
2. Зарегистрируйтесь или войдите в аккаунт.
3. Разрешите приложению доступ к Bluetooth/Location, если попросит (нужно для обнаружения).

### 2) Подготовить розетку к спариванию
1. Вставьте розетку в сеть.
2. Зажмите кнопку питания на розетке на 5-10 секунд, пока индикатор не начнет быстро мигать.
3. Если мигает медленно, обычно это режим AP. Для начала лучше быстрый режим (EZ Mode).

### 3) Добавить устройство
1. В `Smart Life` нажмите `+` -> `Add Device`.
2. Выберите категорию `Socket (Wi-Fi)` или похожую.
3. Подтвердите, что индикатор быстро мигает.
4. Выберите вашу сеть Wi-Fi `2.4 GHz` и введите пароль.
5. Дождитесь завершения добавления (до 1-2 минут).

### 4) Проверка работы
1. Переименуйте устройство, например: `3D Printer Power`.
2. Нажмите `On/Off` в приложении и проверьте, что розетка щелкает/переключается.
3. Включите мобильный интернет (отключив Wi-Fi) и проверьте удаленное управление.

### Если не подключается
- Проверьте, что подключение к сети именно `2.4 GHz`, а не `5 GHz`.
- Поднесите розетку ближе к роутеру на время первой настройки.
- Переведите розетку в режим AP (медленное мигание), если EZ не сработал.
- Отключите VPN на смартфоне на время привязки.
- Сбросьте розетку и повторите добавление.

### Безопасность для 3D-принтера
- Не отключайте розетку во время активной печати или нагрева.
- Лучше выключать питание только после завершения печати и охлаждения.
- Orange Pi должен питаться отдельно от этой розетки.

### Текущий статус (на сегодня)
- Розетка успешно подключена и управляется через `Smart Life` на смартфоне.
- Подключение к `Alexa` отложено; при необходимости можно добавить позже без повторной настройки розетки.

---

## EN: Step 1 - Connect the Smart Plug to Smart Life

### Requirements
- A smartphone with internet access.
- Home Wi-Fi on 2.4 GHz (required by most Tuya/Smart Life plugs).
- `Smart Life` app (or `Tuya Smart`).
- Plug connected close to the router during initial setup.

### 1) Install app and sign in
1. Install `Smart Life` from App Store or Google Play.
2. Create an account or sign in.
3. Allow Bluetooth/Location permissions if requested (used for discovery).

### 2) Put the plug in pairing mode
1. Plug it into power.
2. Hold the power button for 5-10 seconds until the LED blinks quickly.
3. If it blinks slowly, that is usually AP mode. Start with fast blink (EZ mode).

### 3) Add the device
1. In `Smart Life`, tap `+` -> `Add Device`.
2. Select `Socket (Wi-Fi)` or similar.
3. Confirm the indicator is blinking quickly.
4. Select your `2.4 GHz` Wi-Fi and enter password.
5. Wait for pairing to complete (up to 1-2 minutes).

### 4) Verify operation
1. Rename it, for example: `3D Printer Power`.
2. Toggle `On/Off` in the app and confirm the plug switches.
3. Disable Wi-Fi on your phone (mobile data only) and verify remote control works.

### If pairing fails
- Confirm you are using `2.4 GHz` Wi-Fi, not `5 GHz`.
- Move the plug closer to the router for first pairing.
- Try AP mode (slow blink) if EZ mode fails.
- Temporarily disable VPN on the phone.
- Reset the plug and retry pairing.

### Safety for 3D printer usage
- Do not cut power during active print or heating.
- Power off only after print is finished and temperatures are down.
- Keep Orange Pi on separate power (not behind this plug).

### Current status (as of now)
- The smart plug is successfully paired and controlled via `Smart Life` on the phone.
- `Alexa` integration is postponed and can be added later without re-pairing the plug.
