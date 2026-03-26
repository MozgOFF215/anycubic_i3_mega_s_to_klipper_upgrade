# Справка По Макросам Klipper (Текущий Конфиг)

Документ описывает макросы, которые сейчас используются в:
- `config/mainsail.cfg`
- `config/beeper.cfg`

## Где Какие Макросы

- Пользовательские макросы:
  - `M300` (из `config/beeper.cfg`)
  - `PAUSE`, `RESUME`, `CANCEL_PRINT` (из `config/mainsail.cfg`)
  - `SET_PAUSE_NEXT_LAYER`, `SET_PAUSE_AT_LAYER` (из `config/mainsail.cfg`)
- Внутренние служебные макросы:
  - `SET_PRINT_STATS_INFO`
  - `_TOOLHEAD_PARK_PAUSE_CANCEL`
  - `_CLIENT_EXTRUDE`
  - `_CLIENT_RETRACT`
  - `_CLIENT_LINEAR_MOVE`

---

## 1) `M300` (звуковой сигнал)

Определен в: `config/beeper.cfg`

Назначение:
- Проигрывает бип в start/end g-code и ручных командах.

Параметры:
- `S` - частота тона (Гц), по умолчанию `1000`, ограничение `0..4000`
- `P` - длительность сигнала (мс), по умолчанию `120`
- `G` - пауза после сигнала (мс), по умолчанию `80`

Примеры:
```gcode
M300
M300 S1000 P200
M300 S1800 P120
M300 S2200 P220 G120
```

Примечания:
- Если нужен режим активного буззера:
```gcode
SET_GCODE_VARIABLE MACRO=M300 VARIABLE=active_buzzer VALUE=1
```
- Вернуть обычный (тональный) режим:
```gcode
SET_GCODE_VARIABLE MACRO=M300 VARIABLE=active_buzzer VALUE=0
```

---

## 2) `PAUSE`, `RESUME`, `CANCEL_PRINT`

Определены в: `config/mainsail.cfg`

Назначение:
- Расширенные макросы управления печатью из Mainsail.
- Оборачивают базовое поведение Klipper и добавляют ретракт, парковку, логику idle timeout и проверки безопасности.

Обычное использование:
```gcode
PAUSE
RESUME
CANCEL_PRINT
```

Ключевые моменты:
- `PAUSE` паркует голову и делает ретракт.
- `RESUME` проверяет температуру (и при необходимости состояние датчика филамента) перед продолжением.
- `CANCEL_PRINT` делает ретракт, опциональную парковку, отключает нагреватели/вентилятор и сбрасывает флаги паузы по слоям.

---

## 3) Пауза по слоям

Определены в: `config/mainsail.cfg`

### `SET_PAUSE_NEXT_LAYER`
Назначение:
- Пауза на следующем слое.

Примеры:
```gcode
SET_PAUSE_NEXT_LAYER ENABLE=1
SET_PAUSE_NEXT_LAYER ENABLE=0
SET_PAUSE_NEXT_LAYER ENABLE=1 MACRO=PAUSE
```

### `SET_PAUSE_AT_LAYER`
Назначение:
- Пауза на конкретном номере слоя.

Примеры:
```gcode
SET_PAUSE_AT_LAYER LAYER=10
SET_PAUSE_AT_LAYER ENABLE=0
SET_PAUSE_AT_LAYER LAYER=25 MACRO=PAUSE
```

---

## 4) Внутренние макросы (справочно)

Обычно вручную не вызываются:

- `SET_PRINT_STATS_INFO`:
  - Перехватывает статистику печати для паузы по слою.
- `_TOOLHEAD_PARK_PAUSE_CANCEL`:
  - Общая логика парковки для pause/cancel.
- `_CLIENT_EXTRUDE`, `_CLIENT_RETRACT`:
  - Безопасные помощники для экструзии/ретракта.
- `_CLIENT_LINEAR_MOVE`:
  - Служебный линейный move с сохранением/восстановлением состояния.

---

## 5) Где безопасно настраивать

Рекомендуемый подход без правки read-only `mainsail.cfg`:

1. Свои макросы хранить в отдельных include-файлах (как `config/beeper.cfg`).
2. Вызывать нужные макросы из start/end g-code в слайсере.
3. При необходимости добавить `_CLIENT_VARIABLE` в `printer.cfg` (как рекомендовано в комментариях `mainsail.cfg`) для тонкой настройки `PAUSE/RESUME/CANCEL_PRINT`.

---

## Быстрые Тестовые Команды

```gcode
M300 S1200 P120
M300 S1800 P120
PAUSE
RESUME
SET_PAUSE_NEXT_LAYER ENABLE=1
SET_PAUSE_AT_LAYER LAYER=5
```

