#!/usr/bin/env bash

# --- Argumentos ---
MODE=$1           # fullscreen | area | dmenu
COPY_OPTION=$2    # copy | nocopy

[[ -z $MODE ]] && { echo "Uso: $0 fullscreen|area|dmenu copy|nocopy"; exit 1; }
[[ -z $COPY_OPTION ]] && { echo "Escolha se quer copy ou nocopy"; exit 1; }

DIR=~/pictures/screenshots
mkdir -p "$DIR"
FILE="$DIR/$(date +%F_%T).png"

# Função para tirar screenshot
take_screenshot() {
    local cmd="$1"
    $cmd > "$FILE"

    if [[ $COPY_OPTION == "copy" ]]; then
        xclip -selection clipboard -t image/png "$FILE"
        notify-send "Screenshot" "Imagem salva e copiada!"
    else
        notify-send "Screenshot" "Imagem salva!"
    fi
}

# Se o modo for dmenu, abre dmenu para escolher fullscreen ou area
if [[ $MODE == "dmenu" ]]; then
    MODE=$(echo -e "\nfullscreen\narea" | dmenu -i -p "Tipo de screenshot:")
    [[ -z $MODE ]] && exit 1
fi

case "$MODE" in
    "fullscreen") take_screenshot "maim";;
    "area") take_screenshot "maim -s";;
    *) echo "Modo inválido: $MODE"; exit 1;;
esac
