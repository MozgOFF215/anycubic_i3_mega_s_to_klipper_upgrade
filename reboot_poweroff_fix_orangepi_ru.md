# Исправление reboot/poweroff на Orange Pi (Armbian, связка Anycubic/Klipper)

В этом документе зафиксирован реальный кейс, когда:
- `sudo reboot` рвал SSH, но плата не поднималась обратно без ручного отключения питания,
- `poweroff` до исправления работал нестабильно.

После решения ниже и `reboot`, и `poweroff` работают корректно.

## Среда

- Плата: Orange Pi 3 LTS
- ОС: Armbian
- Проблемное ядро: `6.12.68-current-sunxi64`
- Стабильное ядро после исправления: `6.16.8` из `linux-image-edge-sunxi64=25.8.2`

## Симптомы

1. При `sudo systemctl reboot`:
   - SSH-сессия обрывается,
   - плата не появляется снова в сети,
   - помогает только выключить/включить питание вручную.
2. `sudo systemctl poweroff` до исправления тоже мог вести себя нестабильно.

## Ключевые признаки в диагностике

После включения persistent journal в логах предыдущей загрузки были:
- `cpufreq-dt: Worker [...] terminated by signal 11 (SEGV)`
- `CPU1/CPU2/CPU3: failed to come online`
- уведомление про debug-ядро (`trace_printk() ... DEBUG kernel ... unsafe for production`)

Это указывает на проблему ядра/инициализации CPU frequency, а не на перенос SD->eMMC.

## Включение persistent journal (обязательно для диагностики)

```bash
sudo mkdir -p /var/log/journal
sudo chown root:systemd-journal /var/log/journal
sudo chmod 2755 /var/log/journal
sudo sed -i 's/^#\?Storage=.*/Storage=persistent/' /etc/systemd/journald.conf
sudo systemctl restart systemd-journald
sudo journalctl --flush
```

## Исправление: переключение на альтернативное ядро

Запустить:

```bash
sudo armbian-config
```

Путь в меню:
- `System` -> `Kernel` -> `Use alternative kernels`
- На вопрос `Show only mainstream kernels?` выбрать `No`
- Установить: `linux-image-edge-sunxi64=25.8.2` (`v6.16.8`)

После установки перезагрузиться.

## Проверка результата

1. Проверить активное ядро:

```bash
uname -r
```

Ожидаемо: `6.16.8` (или другая стабильная версия, которую выбрали вы).

2. Проверить reboot минимум 2 раза:

```bash
sudo systemctl reboot
```

3. Проверить poweroff:

```bash
sudo systemctl poweroff
```

После исправления ожидаемо:
- плата корректно выключается,
- светодиоды могут погаснуть полностью (зависит от ревизии/питания),
- кнопка питания снова запускает обычную загрузку.

## Примечания

- Проблема может наблюдаться и до, и после переноса системы с SD на eMMC.
- Если на новом обновлении ядра проблема вернется, снова протестировать соседнюю стабильную ветку (`current`/`edge`/`legacy`) через `armbian-config`.

