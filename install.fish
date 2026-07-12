#!/usr/bin/env fish

if test (id -u) -eq 0
    echo "This script should not be run as root" >&2
    exit 1
end

# Request root privileges immediately
sudo -v

# Install yay if not already installed
if not command -q yay
    sudo pacman -Syu --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    pushd /tmp/yay-bin
    makepkg -s --noconfirm
    sudo pacman -U --noconfirm *.pkg.tar.zst
    popd
    rm -rf /tmp/yay-bin
end

# Configure yay, update the system and install packages from packages.txt
yay -Syu --needed --noconfirm --cleanmenu=false --diffmenu=false --removemake --sudoloop --cleanafter --batchinstall \
    --save <packages.txt

# Create symbolic links for dotfiles
pushd files
for f in (fd --type file --hidden .)
    ln -sfn (realpath "$f") ~/"$f"
end
popd

# Change the default shell to fish
sudo chsh -s /usr/bin/fish $USER

# Install nvm.fish if not already installed
if not functions -q nvm
    fisher install jorgebucaran/nvm.fish
end

# Install pnpm if not already installed
if not command -q pnpm
    corepack enable
    corepack install -g pnpm
end

# Enable and start the opencode.service for the user
mkdir -p ~/.config/systemd/user
cp opencode.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now opencode.service

# Enable and start GDM
sudo systemctl enable --now gdm

# Set GNOME settings
gsettings set org.gnome.shell enabled-extensions "['dash-to-dock@micxgx.gmail.com', 'gpu-screen-recorder@dec05eba.com', 'appindicatorsupport@rgcjonas.gmail.com']"
gsettings set org.gnome.shell favorite-apps "['org.gnome.Console.desktop', 'firefox.desktop', 'org.gnome.Nautilus.desktop']"
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark
gsettings set org.gnome.desktop.interface monospace-font-name "JetBrains Mono 11"
gsettings set org.gnome.desktop.datetime automatic-timezone true
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.search-providers sort-order "['org.gnome.Settings.desktop', 'org.gnome.Contacts.desktop', 'org.gnome.Nautilus.desktop']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
gsettings set org.gnome.desktop.wm.preferences button-layout "appmenu:minimize,maximize,close"
gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position LEFT
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false

echo "Finished!"
