#!/bin/bash

# Обновление списка пакетов и установка зависимостей
sudo apt update
sudo apt install -y wget libfuse2 libatk1.0-0 libatk-bridge2.0-0 libcups2 libgdk-pixbuf2.0-0 libgtk-3-0 libpango-1.0-0 libcairo2 libxcomposite1 libxdamage1 libasound2 libatspi2.0-0 fuse xvfb

# Проверка загрузки модуля FUSE
sudo modprobe fuse
if ! lsmod | grep -q fuse ; then
  echo "Ошибка: модуль fuse не загружен. Проверьте поддержку FUSE в вашей системе."
  exit 1
fi

# Создаём папку для LM Studio
mkdir -p ~/lmstudio && cd ~/lmstudio

# Загрузка последнего AppImage LM Studio
LMSTUDIO_VERSION="0.3.15-11"  # Можно обновить версию при необходимости
LMSTUDIO_APPIMAGE="LM-Studio-${LMSTUDIO_VERSION}-x64.AppImage"
wget -c "https://installers.lmstudio.ai/linux/x64/${LMSTUDIO_VERSION}/${LMSTUDIO_APPIMAGE}"

# Делаем файл исполняемым
chmod +x "${LMSTUDIO_APPIMAGE}"

# Запуск LM Studio в виртуальном фреймбуфере для GUI на сервере без физического дисплея
# Порт веб-интерфейса по умолчанию 1234
XVFB_DISPLAY=:99
export DISPLAY=$XVFB_DISPLAY
Xvfb $XVFB_DISPLAY -screen 0 1280x720x24 &

# Ждём небольшую паузу, чтобы Xvfb запустился
sleep 3

# Запускаем LM Studio в фоне
./${LMSTUDIO_APPIMAGE} &

echo "LM Studio запущен в режиме GUI с виртуальным дисплеем."
echo "Для доступа к веб-интерфейсу откройте браузер и перейдите по адресу:"
echo "    http://<IP_вашего_сервера>:1234"
echo "Если доступ с удаленной машины не работает, настройте проброс портов или SSH-туннель на порт 1234."

echo "Если нужно завершить работу LM Studio, найдите процесс и завершите его командой:"
echo "    pkill -f '${LMSTUDIO_APPIMAGE}'"
