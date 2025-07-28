#!/bin/bash

# Проверяем доступность ключевых команд modprobe и lsmod, просто для предупреждения
if ! command -v modprobe >/dev/null 2>&1; then
  echo "Внимание: команда modprobe не найдена. Проверка загрузки модуля fuse невозможна."
fi

if ! command -v lsmod >/dev/null 2>&1; then
  echo "Внимание: команда lsmod не найдена. Проверка загруженных модулей невозможна."
fi

# Установка пакетов без sudo невозможна, предположим, что они уже установлены.
# Проверяем наличие libfuse2 и fuse по библиотекам:
if [ ! -f /lib/x86_64-linux-gnu/libfuse.so.2 ] && [ ! -f /lib64/libfuse.so.2 ]; then
  echo "Внимание: libfuse2 не найдена. Пожалуйста, установите пакет libfuse2 самостоятельно."
fi

if ! command -v Xvfb >/dev/null 2>&1; then
  echo "Внимание: Xvfb не установлен. Виртуальный X-сервер недоступен."
fi

# Переходим в домашнюю папку и создаём директорию lmstudio
mkdir -p ~/lmstudio && cd ~/lmstudio

# Версия LM Studio
LMSTUDIO_VERSION="0.3.15-11"
LMSTUDIO_APPIMAGE="LM-Studio-${LMSTUDIO_VERSION}-x64.AppImage"

# Загружаем LM Studio, если он ещё не скачан
if [ ! -f "$LMSTUDIO_APPIMAGE" ]; then
  wget -c "https://installers.lmstudio.ai/linux/x64/${LMSTUDIO_VERSION}/${LMSTUDIO_APPIMAGE}"
fi

chmod +x "$LMSTUDIO_APPIMAGE"

# Запускаем Xvfb в фоне (если установлен)
export DISPLAY=:99
Xvfb :99 -screen 0 1280x720x24 &
sleep 3

# Запускаем LM Studio
./"$LMSTUDIO_APPIMAGE" &

echo "LM Studio запущен."
echo "Откройте в браузере веб-интерфейс по адресу http://<IP_вашего_сервера>:1234"
echo "Если он недоступен, проверьте проброс портов и наличие FUSE."

exit 0
