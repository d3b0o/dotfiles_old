#!/bin/bash

#Colors
RED="\e[31m"
GREEN="\e[32m"
RESET="\e[0m"
TPUT_BLUE=$(tput setaf 123)


Dependencies() {
    
    dependencies=('bspwm' 'polybar' 'rofi' 'picom' 'sxhkd' 'firejail' 'neofetch' 'unrar' 'gnome-terminal' 'vim' 'zsh')
    for i in "${dependencies[@]}"; do
        echo -e "${TPUT_BLUE}\n[*] Installing $i...${RESET}"
        sudo apt install $i
    
    done
    echo -e "${TPUT_BLUE}\n[*] Update...${RESET}"
    sudo apt update

}

Config() {
    #Ask for safe old config
    echo -e "${TPUT_BLUE}\nDo you want to make a copy of your configuration? (y/n)${RESET}"
    read -s -n 1 answer
    if [[ $answer == y ]]
    then
        #Verify if there is and old config saved
        DIRECTORIO=~/.config/config.old
        if [ -d "$DIRECTORIO" ]; then
            #There is an old config previously saved
            echo -e "\n${RED}[!] ERROR Ya exsiste un directorio con una configuracion antigua"
            echo -e "Borralo o cambiale el nombre (${DIRECTORIO})${RESET}"
            exit 2
        else
            #Creating old_config
            mkdir $DIRECTORIO
            echo -e "\n${GREEN}Created folder on ${DIRECTORIO}${RESET}"

            #Move all config files
            files=('rofi' 'sxhkd' 'bspwm' 'polybar' 'picom')
            for i in "${files[@]}"; do
                directory=~/.config/$i

                if [ -d "$directory" ]; then
                mv ~/.config/$i ~/.config/config.old/
                fi
            done
        fi
    fi

    #Save new sxhkd, polybar and rofi config
    files=('rofi' 'polybar' 'bin')
    for i in "${files[@]}"; do
        mkdir ~/.config/$i
        cp -r Config/$i.rar ~/.config/$i/
        unrar x ~/.config/$i/$i.rar ~/.config/$i/
        rm -r ~/.config/$i/$i.rar
    
    done

    #Download wallpaper
    mkdir ~/Wallpapers_bspwm
    cp -r Wallpapers/* ~/Wallpapers_bspwm/

    #Save new sxhkd config
    mkdir ~/.config/sxhkd
    cp -r Config/sxhkdrc ~/.config/sxhkd/sxhkdrc

    #Save new bspwm config
    mkdir ~/.config/bspwm
    mkdir ~/.config/bspwm/scripts
    cp -r Config/bspwm_resize ~/.config/bspwm/scripts/
    cp -r Config/bspwmrc ~/.config/bspwm/

    #Save new picom config
    mkdir ~/.config/picom
    cp -r Config/picom.conf ~/.config/picom/

    zsh

}

clear
#Title
echo -e """${GREEN}
  ____                                     _____                __   _         
 |  _ \                                   / ____|              / _| (_)        
 | |_) | ___  ____  __      __ ________   | |      ___   ____  | |_  _   ____  
 |  _ < / __||  _ \ \ \ /\ / /|  _   _ \  | |     / _ \ |  _ \ |  _|| | / _  | 
 | |_) |\__ \| |_) | \ V  V / | | | | | | | |____| (_) || | | || |  | || (_| | 
 |____/ |___/| .__/   \_/\_/  |_| |_| |_|  \_____|\___/ |_| |_||_|  |_| \__, | 
             | |                                                        __/ | 
             |_|                                                       |___/  
                        ${RED}by d3b0o${RESET}            
"""
sleep 1

#Main
echo -e "${TPUT_BLUE}\nChose an Option\n\n1- Install Dependencies \n2- Config files \n3- All\n4- Exit${RESET}"
read -s -n 1 answer

if [[ $answer == 1 ]]; then
    Dependencies

elif [[ $answer == 2 ]]; then
    Config

elif [[ $answer == 3 ]]; then
    Dependencies
    Config
fi