#!/usr/bin/env bash
for i in {1..5}; do
    volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print int(100*$2)}')
    [[ -n "$volume" ]] && break
    sleep 0.2
done

[[ -z "$volume" ]] && volume=0

status() {
    [[ $volume -eq 0 ]] && icon="󰖁" || icon="󰕾"
    echo "$icon $volume%"
}

update() {
    if [[ $1 = "gui" ]]; then new_volume=$(echo "" | dmenu -p "Definir volume ($volume%):");
    else new_volume=$1; fi

    [[ ! "$new_volume" =~ ^-?[0-9]+$ ]] && exit 1
    [[ $new_volume -lt 0 ]] && new_volume=0
    [[ $new_volume -gt 100 ]] && new_volume=100

    new_volume=$(echo "scale=2; $new_volume/100" | bc)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ $new_volume 2> /dev/null
    pkill -RTMIN+3 i3blocks
}

add() {
    if [[ $1 = "gui" ]]; then add_volume=$(echo "" | dmenu -p "Adicionar volume ($volume%):");
    else add_volume=$1; fi

    [[ ! "$add_volume" =~ ^-?[0-9]+$ ]] && exit 1
    update $(echo "$volume+$add_volume" | bc) 
}

usage() {
    echo -e "Comando\tArgumentos\tDescrição" \
            "\nstatus\t-\t- Mostra o volume atual" \
            "\nupdate\t[valor|gui]\t- Define o volume" \
            "\nadd\t[valor|gui]\t- Adiciona ao volume" | column -t -s $'\t'
}

case "$1" in
    "status") status;;
    "update") update $2;;
    "add") add $2;;
    *) usage;;
esac
