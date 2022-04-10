#!/bin/bash

clear

USER=$(ls /home)

# JUST FOR ARCH LINUX

# loadkeys es
# cfdisk
# mkfs...
# mount ... /mnt
# pacstrap /mnt linux linux-firmware base base-devel grub networkmanager wpa_supplicant vim nano git sudo gnome kitty
# genfstab -U /mnt > /mnt/etc/fstab
# arch-chroot /mnt
# passwd
# useradd -m jose
# passwd jose
# usermod -aG wheel jose
# vim /etc/sudoers > uncomment line 82
# vim /etc/locale.gen > uncomment lines 178, 201
# locale-gen
# echo "KEYMAP=es" > /etc/vconsole.conf
# grub-install /dev/sda
# grub-mkconfig -o /boot/grub/grub.cfg
# echo "hackMachine" > /etc/hostname
# vim /etc/hosts > 127.0.0.1 \t localhost, ::1 \t localhost, 127.0.0.1 \t hackMachine.localhost hackMachine
# systemctl enable NetworkManager
# systemctl enable wpa_supplicant
# systemctl enable gdm
# exit
# reboot now

# git clone in user folder (~)

execute() {
    # Install all
    sudo pacman -S --noconfirm wget gtkmm firefox p7zip xorg xorg-server open-vm-tools xf86-video-vmware xf86-input-vmmouse zsh lsd bat feh neovim
    paru -S --noconfirm scrub

    # Activate services
    sudo systemctl enable vmtoolsd
    sudo systemctl start vmtoolsd

    # Paru
    cd /home/$USER/Downloads
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin
    makepkg -si --noconfirm

    # BlackArch
    cd ..
    mkdir blackarch
    cd blackarch
    curl -O https://blackarch.org/strap.sh
    chmod +x strap.sh
    sudo ./strap.sh

    # Awesome
    paru -S --noconfirm awesome-git picom-git alacritty rofi todo-bin acpi acpid \
    wireless_tools jq inotify-tools polkit-gnome xdotool xclip maim \
    brightnessctl alsa-utils alsa-tools pulseaudio lm_sensors \
    mpd mpc mpdris2 ncmpcpp playerctl --needed --noconfirm

    systemctl --user enable mpd.service
    systemctl --user start mpd.service
    sudo systemctl enable acpid.service
    sudo systemctl start acpid.service

    # Fonts
    cd /usr/share/fonts
    sudo wget http://fontlot.com/downfile/5baeb08d06494fc84dbe36210f6f0ad5.105610
    sudo mv 5baeb08d06494fc84dbe36210f6f0ad5.105610 comprimido.zip
    sudo unzip comprimido.zip
    sudo cp iosevka-*2.2.1/ttf*/*.ttf .

    sudo rm -r iosevka-2.2.1 iosevka-slab-2.2.1

    # Icommon
    sudo mv /home/$USER/My-Modified-S4vitar-Desktop-Environment-2022/icomoon.zip .
    sudo unzip icomoon.zip
    sudo mv icomoon/*.ttf .
    sudo rm -rf icomoon icomoon.zip

    # Additional fonts
    paru -S --noconfirm nerd-fonts-jetbrains-mono ttf-font-awesome ttf-font-awesome-4 ttf-material-design-icons

    # Dotfiles
    cd /home/$USER/Downloads
    git clone https://github.com/rxyhn/dotfiles.git; cd dotfiles
    git checkout c1e2eef2baa91aebd37324891cb282666beae04f
    mkdir /home/$USER/.local/bin
    cp -r config/* ~/.config/; cp -r bin/* ~/.local/bin/; cp -r misc/. ~/

    # Set terminal Kitty
    sed -i 's/alacritty/kitty/g' /home/$USER/.config/awesome/rc.lua

    # Change default shell
    sudo usermod -s /usr/bin/zsh $USER
    sudo usermod -s /usr/bin/zsh root

    # Fix keyboard language
    setxkbmap es
    localectl set-x11-keymap es

    # Zsh Config
    cd /home/$USER
    rm .zshrc
    mv /home/$USER/My-Modified-S4vitar-Desktop-Environment-2022/.zshrc .
    sudo ln -s /home/$USER/.zshrc /root/.zshrc
    # vim .zshrc
    paru -S --noconfirm zsh-syntax-highlighting zsh-autosuggestions
    cd /usr/share/zsh/plugins
    sudo mkdir zsh-sudo
    sudo chown $USER.$USER zsh-sudo
    cd zsh-sudo
    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
    mv sudo.plugin.zsh zsh-sudo.zsh

    # Hack Nerd Fonts
    cd /usr/share/fonts
    sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
    sudo unzip Hack.zip
    sudo rm -f Hack.zip

    # Kitty Config
    cd /home/$USER/.config/kitty
    wget https://raw.githubusercontent.com/rxyhn/bspdots/main/config/kitty/kitty.conf
    wget https://raw.githubusercontent.com/rxyhn/bspdots/main/config/kitty/color.ini
    sed -i 's/Cartograph CF Italic/HackNerdFont/g' kitty.conf
    sed -i 's/11/13/g' kitty.conf
    sed -i 's/fff/61afef/g' kitty.conf
    sed -i '14i \ ' kitty.conf
    sed -i '14i map ctrl+left neighboring_window left' kitty.conf
    sed -i '15i map ctrl+right neighboring_window right' kitty.conf
    sed -i '16i map ctrl+up neighboring_window up' kitty.conf
    sed -i '17i map ctrl+down neighboring_window down' kitty.conf
    sed -i '18i \ ' kitty.conf
    sed -i '19i map f1 copy_to_buffer a' kitty.conf
    sed -i '20i map f2 paste_from_buffer a' kitty.conf
    sed -i '21i map f3 copy_to_buffer b' kitty.conf
    sed -i '22i map f4 paste_from_buffer b' kitty.conf
    sed -i '23i cursor_shape beam' kitty.conf
    sed -i '24i cursor_beam_tickness 1.8' kitty.conf
    sed -i '25i \ ' kitty.conf
    sed -i '26i mouse_hide_wait 3.0' kitty.conf
    sed -i '27i detect_urls yes' kitty.conf
    sed -i '28i \ ' kitty.conf
    sed -i '29i repaint_delay 10' kitty.conf
    sed -i '30i input_delay 3' kitty.conf
    sed -i '31i sync_to_monitor yes' kitty.conf
    sed -i '32i \ ' kitty.conf
    sed -i '33i map ctrl+shift+z toggle_layout stack' kitty.conf
    sed -i '34i tab_bar_style powerline' kitty.conf
    sed -i '35i \ ' kitty.conf
    sed -i '36i inactive_tab_background #e06c75' kitty.conf
    sed -i '37i active_tab_background #98c379' kitty.conf
    sed -i '38i active_tab_foreground #000000' kitty.conf
    sed -i '39i tab_bar_margin_color black' kitty.conf
    sed -i '40i \ ' kitty.conf
    sed -i '41i map ctrl+shift+enter new_window_with_cwd' kitty.conf
    sed -i '42i map ctrl+shift+t new_tab_with_cwd' kitty.conf
    sed -i '43i \ ' kitty.conf
    sed -i '44i background_opacity 0.95' kitty.conf

    # Picom
    cd /home/$USER/.config/awesome/theme
    rm picom.conf
    wget https://raw.githubusercontent.com/rxyhn/bspdots/main/config/picom/picom.conf
    sed -i 's/vsync = true/vsync = false/g' picom.conf
    sed -i 's/menu-opacity/opacity/g' picom.conf
    sed -i '164,207d' picom.conf
    sed -i 's/round-borders = 1/round-borders = 20/g' picom.conf
    sed -i 's/corner-radius = 0/corner-radius = 20/g' picom.conf
    sed -i 's/backend = "glx"/backend = "xrender"/g' picom.conf
    sed -i '254 c\#refresh-rate = 0' picom.conf
    sed -i '333 c\use-damage = false' picom.conf

    # Kitty Borders
    cd /home/$USER/.config/awesome/ui/decorations
    sed -i '35 c\-- require("ui.decorations.titlebar")' init.lua
    sed -i '36 c\-- require("ui.decorations.music")' init.lua

    # Background
    mv /home/$USER/My-Modified-S4vitar-Desktop-Environment-2022/wallpaper.jpg /home/$USER/.config/awesome/theme/assets
    cd /home/$USER/.config/awesome
    echo '-- Wallpaper' >> rc.lua
    echo "local wallpaper_cmd=\"feh --bg-fill /home/$USER/.config/awesome/assets/wallpaper.jpg\"" >> rc.lua
    echo 'os.execute(wallpaper_cmd)' >> rc.lua

    # Powerlevel10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
    su root -c 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k'

    # Change Icon
    cd /home/$USER/.config/awesome/theme/assets/icons
    rm awesome.png
    mv /home/$USER/My-Modified-S4vitar-Desktop-Environment-2022/awesome.png .

    # Fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
    su root -c 'git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install'

    # NeoVim
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
    nvim +'hi NormalFloat guibg=#1e222a' +PackerSync
    su root -c "git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1; nvim +'hi NormalFloat guibg=#1e222a' +PackerSync"

    # BurpSuite
    sed -i '27i burp_proxy = "burpsuite"' /home/$USER/.config/awesome/rc.lua

    # KeyBindings
    cd /home/$USER/.config/awesome/configuration
    sed -i 's/{modkey}, "w"/{modkey, "Shift"}, "f"/g' keys.lua
    sed -i '55i \        awful.key({modkey, "Shift"}, "b", function()' keys.lua
    sed -i '56i \            awful.spawn.with_shell(burp_proxy)' keys.lua
    sed -i '57i \        end,' keys.lua
    sed -i '58i \        {description = "open burpsuite", group = "launcher"}),' keys.lua

    # Install programs
    sudo pacman -S --noconfirm burpsuite python-pip responder nmap whatweb wfuzz gobuster
    paru -S --noconfirm wordlists ettercap-gtk
}

configurePowerlevel10k() {
    # Configure p10k configure in user and root
    cd /home/$USER
    sed -i '37i \    command_execution_time' .p10k.zsh
    sed -i '38i \    context' .p10k.zsh
    sed -i '47,109d' .p10k.zsh
    sudo sed -i '37i \    command_execution_time' /root/.p10k.zsh
    sudo sed -i '38i \    context' /root/.p10k.zsh
    sudo sed -i '47,109d' /root/.p10k.zsh
    sudo sed -i '825d' /root/.p10k.zsh
    sudo sed -i 's/%B%n@%m//g' /root/.p10k.zsh
}

# Main
if [ $UID != 0 ]; then
    if [ ! -f /home/$USER/temp ]; then
        execute
        touch /home/$USER/temp
        rm -rf /home/$USER/Downloads/*
        sudo reboot
    else
        configurePowerlevel10k
        rm -f /home/$USER/temp
    fi
else
    echo 'Debes ejecutar este script como usuario'
    exit 1
fi