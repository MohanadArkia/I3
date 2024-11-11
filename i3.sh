#!/bin/bash

if [ $(id -u) -eq 0 ]; then
    echo "Please run the script without root privileges"
fi

function esensialPackages() {
    packages=("xorg" "xorg-xinit" "i3-wm" "xscreensaver" "i3status" "rofi" "terminator" "firefox" "ttf-font-awesome"
        "materia-gtk-theme" "papirus-icon-theme" "lxappearance" "nitrogen" "picom"
        "pulseaudio" "pamixer" "alsa-utils" "vlc" "base-devel" "dunst" "acpi" "trayer" "pcmanfm" "git" "networkmanager"
    "network-manager-applet" "cronie" "okular" "flameshot" "noto-fonts" "zip" "unzip" "xdotool")
    
    sudo pacman -S "${packages[@]}"
    git clone https://github.com/Ventto/lux.git;cd lux;sudo make install;cd ..;sudo rm -rf lux
    git clone https://aur.archlinux.org/yay.git;cd yay;makepkg -si;cd ..;sudo rm -rf yay
    yay -S brillo
    yay -S perl-tk
    yay -S ttf-apple-emoji
    cpan install IPC::System::Simple
    sudo systemctl enable cronie.service --now
    sudo ln -s /usr/bin/vim /usr/bin/vi
}

function movingFolders() {
    if [ ! -d "dotConfig" ]; then
        echo "dotConfig directory does not exist"
        return
    fi
    
    cd "dotConfig"
    for dir in "dunst" "i3" "i3status" "rofi" "terminator" "scripts" "fontawesome"; do
        
        local themesPath="/usr/share/rofi/themes/"
        local documentsPath="$HOME/Documents"
        local iconsPath="$HOME/.local/share/icons"
        
        if [ -d "$dir" ]; then
            
            if [ "$dir" = "rofi" ]; then
                sudo mv "$dir/themes/DarkBlue.rasi" "$dir/themes/rounded-blue-dark.rasi" "$dir/themes/rounded-common.rasi" "$themesPath"
                sudo rm -rf "$dir/themes";
            fi
            
            if [ "$dir" = "scripts" ]; then
                mv "scripts" "$documentsPath"
            fi
            
            if [ "$dir" = "fontawesome" ]; then
                mv "fontawesome" "$iconsPath"
            fi
            
            if [ "$dir" = "fonts" ]; then
                mv "fonts" "$fontsPath"
            fi
            
            mv "$dir" "$HOME/.config"
        else
            echo "$dir" "directory does not exist"
        fi
    done
    
    if [ -f "xinitrc" ]; then
        mv "xinitrc" "$HOME/.xinitrc"
    else
        echo "xinitrc file does not exist"
    fi
}

esensialPackages
movingFolders
