#!/bin/bash

# Переменные
APPIMAGE_URL="https://releases.lmstudio.ai/linux/x86/0.3.5/2/LM_Studio-0.3.5.AppImage"
APPIMAGE_NAME="LM_Studio-0.3.5.AppImage"
INSTALL_DIR="$HOME/LMStudio"
DESKTOP_FILE="$HOME/.local/share/applications/LM-Studio.desktop"

# Создание директории для установки
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR" || exit 1

echo "Скачиваем LM Studio AppImage..."
curl -L -o "$APPIMAGE_NAME" "$APPIMAGE_URL"

echo "Делаем AppImage исполняемым..."
chmod +x "$APPIMAGE_NAME"

echo "Распаковываем AppImage..."
./"$APPIMAGE_NAME" --appimage-extract

echo "Устанавливаем права для chrome-sandbox..."
sudo chown root:root squashfs-root/chrome-sandbox
sudo chmod 4755 squashfs-root/chrome-sandbox

echo "Готово! LM Studio установлена в $INSTALL_DIR"

echo "Создаём ярлык в меню приложений..."
mkdir -p "$(dirname "$DESKTOP_FILE")"
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=LM Studio
Exec=$INSTALL_DIR/squashfs-root/lm-studio
Icon=$INSTALL_DIR/squashfs-root/resources/app/icon.png
Type=Application
Categories=Development;AI;
Comment=Local Large Language Models Studio
EOF

chmod +x "$DESKTOP_FILE"

echo "Вы можете запустить LM Studio командой: $INSTALL_DIR/squashfs-root/lm-studio"
echo "Ярлык LM Studio добавлен в меню приложений."

# По желанию, сразу запустим LM Studio
# Uncomment следующую строку для автоматического запуска
"$INSTALL_DIR/squashfs-root/lm-studio"