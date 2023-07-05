# Install Steps

This is a log of installation steps to set up Arch on my machine; as well as my `dotfiles`. Have fun with them.

- [Install Steps](#install-steps)
  - [System Install](#system-install)
    - [Install Arch](#install-arch)
    - [Install a Good Terminal Emulator](#install-a-good-terminal-emulator)
    - [Install Text Editor](#install-text-editor)
    - [Fix DPI](#fix-dpi)
    - [Install AUR Helper](#install-aur-helper)
    - [Update NV Driver](#update-nv-driver)
    - [Replace i3 with Hyprland](#replace-i3-with-hyprland)
    - [Install NetworkManager](#install-networkmanager)
  - [User Setup](#user-setup)
    - [Install Resource Tracker](#install-resource-tracker)
    - [Install Browser](#install-browser)
    - [Install Bragging Rights (Neofetch)](#install-bragging-rights-neofetch)
    - [Audio Management](#audio-management)
    - [Install IDE (.NET)](#install-ide-net)
    - [Keyboard Lighting (Corsair)](#keyboard-lighting-corsair)
    - [Mouse Config (Universal)](#mouse-config-universal)
    - [File Managers](#file-managers)
    - [Fix Screen Capture on Chrome](#fix-screen-capture-on-chrome)
    - [Auth Agent](#auth-agent)
    - [Archive Manager (Optional)](#archive-manager-optional)
    - [GTK Settings Editor](#gtk-settings-editor)
    - [Removable Media \& Mounting Support](#removable-media--mounting-support)
  - [Dotfiles Config Setup](#dotfiles-config-setup)
    - [Install GTK Theme (Catpuccin)](#install-gtk-theme-catpuccin)
    - [Configure WM (hyprland)](#configure-wm-hyprland)
    - [Configure Bar (waybar)](#configure-bar-waybar)
    - [Install Zsh (our configs rely on this).](#install-zsh-our-configs-rely-on-this)
  - [Deploy the Configurations](#deploy-the-configurations)
  - [Maintenance](#maintenance)
    - [Copy Dotfiles from Current User to Repo](#copy-dotfiles-from-current-user-to-repo)


## System Install

### Install Arch

```bash
# Easy installer because I'm lazy.
# with pipewire
pacman -S archinstall
archinstall
```

### Install a Good Terminal Emulator

```bash
pacman -S kitty
```

Note: `Ctrl+Shift+C / V` do copy and paste.

### Install Text Editor

```bash
pacman -S vscode

# Remember to hide that menu bar in VSCode :wink:
```

### Fix DPI

Note: Need to set DPI if not targeting default 96 value.

```bash
nano ~/.Xresources
```

Insert desired DPI for apps:

```
Xft.dpi: 192
```

Then merge with current settings
```
xrdb -merge ~/.Xresources
```

Changes will apply after app restarts.

For screen DPI, use `xrandr`:

```
# 4K and 1080p side ny side
xrandr --dpi 192 --fb 7680x2160 --output DP-0 --mode 3840x2160 --output DVI-D-0 --scale 2x2 --pos 3840x0
```

Note: This is just temporary, later our screen will be controlled by wayland.

### Install AUR Helper

```bash
pacman -S git -y
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### Update NV Driver

If you're stuck with prioprietary driver like me, it's kinda sad.  
This repo has some extra fixes.  

```bash
git clone https://github.com/Frogging-Family/nvidia-all.git
cd nvidia-all
makepkg -si
```

Must enable direct rendering manager in kernel params (`systemd-boot` instructions):

```bash
nano /boot/loader/entries/...conf
```

Add `nvidia_drm.modeset=1` to options, and while we're at it, disable mitigations `mitigations=off`

And rebuild dkms...

```bash
dkms autoinstall
```

And just in case...
```bash
mkinitcpio # also verify with --automods
```

### Replace i3 with Hyprland

```bash
yay -S hyprland-nvidia
yay -S xorg-xwayland
yay -S wlroots-nvidia
```

Disable DM:

```bash
systemctl disable display-manager.service
pacman -Rs lightdm lightdm-gtk-greeter
```

Install some packages:
```bash
sudo pacman -S vulkan-tools
sudo pacman -S vulkan-validation-layers
```

Update `~/.bash_profile`

```bash
export LIBVA_DRIVER_NAME=nvidia
export XDG_SESSION_TYPE=wayland
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export WLR_NO_HARDWARE_CURSORS=1
export MOZ_ENABLE_WAYLAND=1 # (REQUIRED: Firefox will break otherwise.)
#export WLR_RENDERER=vulkan # breaks currently
export SDL_VIDEODRIVER=wayland
export QT_QPA_PLATFORM=wayland
export KITTY_DISABLE_WAYLAND=1 # fixes a crash bug after changing DPI

# Auto start
if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec Hyprland # auto start on boot 
fi
```

Get QT for Wayland

```bash
pacman -S qt5-wayland
pacman -S qt6-wayland
```

Reboot.

### Install NetworkManager

```
pacman -S networkmanager
pacman -S nm-connection-editor
```

## User Setup 

### Install Resource Tracker

```bash
pacman -S btop
```

### Install Browser

```bash
pacman -S vivaldi
```

### Install Bragging Rights (Neofetch)

```bash
pacman -S neofetch
pacman -S imagemagick # thumbnails
```

### Audio Management

```bash
pacman -S pavucontrol # Change audio setting here!
pacman -S playerctl   # Keyboard Bindings
```

After installing, might need to go to `pavucontrol` and check the default device using the checkbox.

In my case this is `Starship/Matisse HD Audio Controller` under `Output` tab.

### Install IDE (.NET)

```bash
yay -S aur/rider
yay -S dotnet-sdk-7.0
```

### Keyboard Lighting (Corsair)

```bash
yay -S ckb-next
systemctl enable ckb-next-daemon
systemctl start ckb-next-daemon
```

### Mouse Config (Universal)

```bash
pacman -S piper
piper
```

### File Managers

```bash
yay -S thunar tumbler ffmpegthumbnailer # tumbler for thumbs
pacman -S ranger # optional
```

### Fix Screen Capture on Chrome

```bash
pacman -S xdg-desktop-portal-hyprland

# Update Config
exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
```

### Auth Agent

```bash
pacman -S polkit-kde-agent
```

### Archive Manager (Optional)

```bash
yay -S file-roller
```

### GTK Settings Editor

```bash
yay -S nwg-look
```

### Removable Media & Mounting Support

```bash
yay -S gvfs
```

## Dotfiles Config Setup

RGBA

- Accent A: #00ff99ee `(Down/Green)`
- Accent B: #33ccffee `(Up/Blue)`

- Accent A Lighter: #a9ceb5
- Accent B Lighter: #a2cce0

### Install GTK Theme (Catpuccin)

```bash
yay -S catppuccin-gtk-theme-mocha catppuccin-gtk-theme-macchiato catppuccin-gtk-theme-frappe catppuccin-gtk-theme-latte papirus-icon-theme gtk-engine-murrine
```

### Configure WM (hyprland)

Display Configuration Helper:

```bash
# .config/hypr/monitors.conf
pacman -S nwg-displays wlr-randr
```

Screenshots:

```bash
# .config/hypr/screenshot.conf
# Bound to Print Screen, saves to 'Pictures' folder.
yay -S grim slurp 
```

Notification Service:

```bash
# .config/hypr/notification.conf
yay -S dunst
```

Media Keys:

```bash
# .config/hypr/mediakeys.conf
pacman -S playerctl # Keyboard Bindings
```

Keyboard/Mouse:

```bash
# .config/hypr/input.conf
# kb_layout = gb
# force_no_accel = 1
```

Keybinds:

```bash
# .config/hypr/bindings.conf
# default bindings closely resemble i3wm
```

App Launcher/Window Switcher/Command Runner:

```bash
# .config/hypr/applauncher.conf     # MOD + D
# .config/hypr/windowswitcher.conf  # Alt+Tab
# .config/hypr/runcommand.conf      # MOD + R
yay -S rofi-lbonn-wayland-git rofi-emoji nerd-fonts-jetbrains-mono-160

# Theme settings in .config/rofi
```

Lock Screen:

```bash
# .config/hypr/lockscreen.conf     # MOD + ESC
# .config/swaylock/config 
yay -S swaylock-effects
```

Wallpaper: 

```bash
# .config/hypr/hyprpaper.conf 
pacman -S hyprpaper
```

### Configure Bar (waybar)

```bash
# .config/hypr/bar.conf
yay -S waybar-hyprland-git

# Needed Fonts
yay -S ttf-font-awesome ttf-jetbrains-mono ttf-icomoon-feather ttf-iosevka-nerd ttf-iosevka

# Needed Applet
yay -S nm-connection-editor
```

Note: The `music` component on the bar doesn't have wired up buttons, for now it only responds to left/middle/right click.

### Install Zsh (our configs rely on this).

```zsh
pacman -S zsh
```

## Deploy the Configurations

Copies the dotfiles, makes zsh default shell, changes shell to zsh:

```bash
chmod +x ./deploy.sh
deploy.sh
```

## Maintenance

### Copy Dotfiles from Current User to Repo

This shell script copies all the files from the current user's `.config` into this repo's `.config` (by folder), as well as other user folders.

i.e. If `.config/i3` exists, it will copy all of `$HOME/.config/i3`.

```bash
./update.sh
```