#!/usr/bin/env bash
input=$(echo "" | dmenu -p "Pesquisar:" | sed 's/\s/%20/g')
[[ -n "$input" ]] && firefox  --private-window "https://www.google.com/search?q=$input" &
