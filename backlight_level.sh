#!/usr/bin/env bash

backlight_path="/sys/class/backlight/intel_backlight"

min_percent=1

max=$(cat "$backlight_path/max_brightness")
actual=$(cat "$backlight_path/actual_brightness")

level=$(( actual * 100 / max ))

status() {
    icons=("󰃞" "󰃟" "󰃠")
    idx=$(( level / 34 ))
    [[ $idx -gt 2 ]] && idx=2
    echo "${icons[$idx]} $level%"
}

apply_brightness() {
    brightnessctl s "$1%" > /dev/null
    pkill -RTMIN+4 i3blocks
}

update() {
    if [[ $1 = "gui" ]]; then
        new_level=$(echo "" | dmenu -p "Definir brilho ($level%):")
    else
        new_level=$1
    fi

    [[ ! "$new_level" =~ ^-?[0-9]+$ ]] && exit 1

    apply_brightness "$new_level"
}

add() {
    if [[ $1 = "gui" ]]; then
        add_level=$(echo "" | dmenu -p "Adicionar brilho ($level%):")
    else
        add_level=$1
    fi

    [[ ! "$add_level" =~ ^-?[0-9]+$ ]] && exit 1

    new_level=$(( level + add_level ))
    apply_brightness "$new_level"
}

usage() {
    echo -e "Comando\tArgumentos\tDescrição" \
            "\nstatus\t-\t- Mostra o brilho atual" \
            "\nupdate\t[valor|gui]\t- Define o brilho (mínimo $min_percent%)" \
            "\nadd\t[valor|gui]\t- Adiciona ao brilho" | column -t -s $'\t'
}

case "$1" in
    "status") status;;
    "update") update "$2";;
    "add") add "$2";;
    *) usage;;
esac
