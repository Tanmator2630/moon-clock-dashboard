#!/bin/bash

if ! command -v ascii_moon &> /dev/null; then
    echo "Error: 'ascii_moon' command not found."
    exit 1
fi

time_format="12h"
art_size="40"
show_date=true
needs_redraw=true

clear
tput civis
echo -e "\e[?25l"
stty -echo

trap "tput cnorm; echo -e '\e[?25h'; stty echo; clear; exit" INT TERM

while true; do
    term_height=$(tput lines)
    term_width=$(tput cols)

    current_epoch=$(date +%s)
    phase_index=$(( ((current_epoch - 1704974760) % 2551443 * 8) / 2551443 ))
    phase_names=("NEW MOON" "WAXING CRESCENT" "FIRST QUARTER" "WAXING GIBBOUS" "FULL MOON" "WANING GIBBOUS" "LAST QUARTER" "WANING CRESCENT")
    phase_name="${phase_names[$phase_index]}"

    if [ "$show_date" = true ]; then
        if [ "$time_format" = "12h" ]; then
            date_time=$(date "+%A, %B %d, %Y  |  %I:%M:%S %p")
        else
            date_time=$(date "+%A, %B %d, %Y  |  %H:%M:%S")
        fi
    else
        if [ "$time_format" = "12h" ]; then
            date_time=$(date "+%I:%M:%S %p")
        else
            date_time=$(date "+%H:%M:%S")
        fi
    fi

    if [ "$needs_redraw" = true ]; then
        clear
        display_art=$(ascii_moon --lines "$art_size")

        max_art_width=0
        while IFS= read -r line; do
            clean_line=$(echo "$line" | sed 's/\x1b\[[0-9;]*m//g')
            if [ ${#clean_line} -gt $max_art_width ]; then
                max_art_width=${#clean_line}
            fi
        done <<< "$display_art"

        art_height=$(echo "$display_art" | wc -l)
        
        total_layout_height=$((art_height + 7))
        top_padding=$(( (term_height - total_layout_height) / 2 ))
        [ $top_padding -lt 0 ] && top_padding=0

        menu_text="[t] Toggle 12h/24h  |  [d] Toggle Date  |  [m] Toggle Moon Size ($art_size)  |  [q] Quit"
        menu_width=${#menu_text}
        menu_padding=$(( (term_width - menu_width) / 2 ))
        [ $menu_padding -lt 0 ] && menu_padding=0
        
        tput cup 0 0
        printf "%${menu_padding}s%s\n" "" "$menu_text"
        
        printf '─%.0s' $(seq 1 "$term_width")
        echo ""

        for ((i=2; i<top_padding; i++)); do echo ""; done

        while IFS= read -r line; do
            left_padding=$(( (term_width - max_art_width) / 2 ))
            [ $left_padding -lt 0 ] && left_padding=0
            printf "%${left_padding}s%b\n" "" "$line"
        done <<< "$display_art"

        echo ""

        phase_row=$(( top_padding + art_height + 1 ))
        time_row=$(( phase_row + 2 ))

        phase_width=${#phase_name}
        phase_padding=$(( (term_width - phase_width) / 2 ))
        [ $phase_padding -lt 0 ] && phase_padding=0
        tput cup $phase_row 0
        tput bold
        printf "%${phase_padding}s%s" "" "$phase_name"
        tput sgr0

        needs_redraw=false
    fi

    date_width=${#date_time}
    date_padding=$(( (term_width - date_width) / 2 ))
    [ $date_padding -lt 0 ] && date_padding=0
    
    tput cup $time_row 0
    tput el
    tput bold
    printf "%${date_padding}s%s" "" "$date_time"
    tput sgr0

    tput cup 0 0

    read -t 1 -n 1 key
    case "$key" in
        t|T)
            if [ "$time_format" = "12h" ]; then time_format="24h"; else time_format="12h"; fi
            ;;
        d|D)
            if [ "$show_date" = true ]; then show_date=false; else show_date=true; fi
            ;;
        m|M)
            if [ "$art_size" = "40" ]; then art_size="20"; else art_size="40"; fi
            needs_redraw=true
            ;;
        q|Q)
            break
            ;;
    esac
done

tput cnorm
echo -e '\e[?25h'
stty echo
clear