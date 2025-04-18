# Install Steps

This is a log of installation steps to set up Arch on my machine; as well as my `dotfiles`. Have fun with them.

- [Install Steps](#install-steps)
  - [System Install](#system-install)
    - [Install Arch](#install-arch)
    - [Install a Good Terminal Emulator](#install-a-good-terminal-emulator)
    - [Install Text Editor](#install-text-editor)
    - [Fix DPI](#fix-dpi)
    - [Install AUR Helper](#install-aur-helper)
    - [Update NV Driver \& Setup Kernel Params](#update-nv-driver--setup-kernel-params)
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
    - [Configure Swap (Optional)](#configure-swap-optional)
    - [Configure ZRam (Optional)](#configure-zram-optional)
    - [File Managers](#file-managers)
    - [Fix Screen Capture on Chrome](#fix-screen-capture-on-chrome)
    - [Archive Manager (Optional)](#archive-manager-optional)
    - [GTK Settings Editor](#gtk-settings-editor)
    - [Autologin](#autologin)
    - [Hex Editor](#hex-editor)
    - [Docker](#docker)
    - [Mount Cloud Storage](#mount-cloud-storage)
    - [Mount NAS Storage](#mount-nas-storage)
    - [JPEG XL Support](#jpeg-xl-support)
  - [Dotfiles Config Setup](#dotfiles-config-setup)
    - [Install GTK Theme (Catpuccin)](#install-gtk-theme-catpuccin)
    - [Configure WM (hyprland)](#configure-wm-hyprland)
    - [Configure Bar (waybar)](#configure-bar-waybar)
    - [Install Oh My Zsh.](#install-oh-my-zsh)
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

### Update NV Driver & Setup Kernel Params

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

Add the following to options:
- `nvidia_drm.modeset=1` (needed for Wayland)
- `nvidia.NVreg_PreserveVideoMemoryAllocations=1` (needed for suspend in Wayland)
- `mitigations=off` (optional, sacrifices security for perf)

Line should look something like:

```
options /* some stuff here */ nvidia_drm.modeset=1 mitigations=off nvidia.NVreg_PreserveVideoMemoryAllocations=1
```

And rebuild dkms...

```bash
dkms autoinstall
```

And just in case...
```bash
mkinitcpio # also verify with --automods
```

And enable the services needed for suspend:

```
systemctl enable nvidia-suspend
systemctl enable nvidia-resume
systemctl enable nvidia-hibernate
```

Then blacklist nouveau

```
sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf" && sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
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
yay -S pulse-browser-bin
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

In Rider, set VM option `-Dsun.java2d.uiScale.enabled=false`.

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

### Configure Swap (Optional)

Also allows hibernation.

```bash
sudo btrfs subvolume create /swap

# For 32GB RAM, using Ubuntu Recommendation that also covers hibernation.
sudo btrfs filesystem mkswapfile --size 38g --uuid clear /swap/swapfile

sudo swapon /swap/swapfile

## Add to fstab
# /swap/swapfile none swap defaults 0 0
```

### Configure ZRam (Optional)

i.e. Compressed RAM. Optionally use instead of swap if you have enough RAM.

```bash
# https://wiki.archlinux.org/title/Zram#:~:text=zram%2C%20formerly%20called%20compcache%2C%20is,a%20general-purpose%20RAM%20disk.
# Disable zswap if needed first.
sudo pacman -S zram-generator # might be already insatalled depending on archinstall config

# Open
sudo nano /etc/systemd/zram-generator.conf
compression-algorithm = zstd
swap-priority = 100
fs-type = swap

# Enable
systemctl enable systemd-zram-setup@zram0.service
```

### File Managers

```bash
yay -S thunar # tumbler for thumbs
yay -S polkit-gnome # Required for auth which is required for mounting drives
yay -S thunar-archive-plugin # archive files
yay -S thunar-media-tags-plugin # id3 tags
yay -S tumbler-extra-thumbnailers # dds and some other useful stuff
yay -S f3d # application for previewing models

# Extensions
yay -S tumbler # Thumbnails
yay -S webp-pixbuf-loader # webp
yay -S ffmpegthumbnailer # videos
yay -S poppler-glib # .pdf
yay -S freetype2 # .pdf

# CLI
pacman -S ranger # optional
```

### Fix Screen Capture on Chrome

```bash
pacman -S xdg-desktop-portal-hyprland

# Update Config
exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
```

### Archive Manager (Optional)

```bash
yay -S file-roller
```

### GTK Settings Editor

```bash
yay -S nwg-look
```

### Autologin

```bash
sudo mkdir /etc/systemd/system/getty@tty1.service.d/
sudo nano /etc/systemd/system/getty@tty1.service.d/override.conf
```

```
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin sewer --noclear %I $TERM
```

```
sudo systemctl enable getty@tty1.service
```

### Hex Editor

```
yay -S 010editor
```

Sometimes it fails in Wayland, x11 mode will work, edit:  
- `~/.local/share/applications/010editor.desktop`  
- `~/.local/share/applications/010editor-project.desktop`  
- `~/.local/share/applications/010editor-import.desktop`  

And prepend `env QT_QPA_PLATFORM=xcb` to the commands.

### Docker

```
yay -S docker
systemctl enable docker.service

# Add user to docker group
sudo usermod -aG docker ${USER}
```

### Mount Cloud Storage

```
pacman -S rclone
rclone config

# Mount that service
mkdir ~/Cloud

# Mount Command in 
# .config/hypr/cloud.conf
```

### Mount NAS Storage

For cloud storage:
```bash
pacman -S rclone
rclone config

# Mount that service
mkdir ~/Cloud

# Mount Command in
# .config/hypr/nas.conf
```

For NFS shares:
```bash
# Install NFS client utilities
sudo pacman -S nfs-utils

# Create mount point
mkdir -p ~/NAS

# Test mount command
sudo mount -t nfs 192.168.1.125:/mnt ~/NAS

# To mount automatically on startup, add the following line to /etc/fstab:
# 192.168.1.125:/mnt    /home/username/NAS    nfs    defaults,_netdev,auto    0    0

# Edit fstab
sudo nano /etc/fstab
```

### JPEG XL Support

```bash
yay -S libjxl
```

Modify the `*screenshot.sh` scripts to make JXL screenshots if desired.

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
# Saves to my 'Cloud' directory. You may need to adjust that.
# Print Screen: Screenshot Region
# Alt + Print Screen: Screenshot Current Window
yay -S grim slurp 
```

Notification Service:

```bash
# .config/hypr/notification.conf
yay -S mako
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

Mounting & Storage Devices:

```bash
# Prereqs
yay -S polkit  # for mounting as user, you'll have this already if you have auth agent

# Automount
# .config/hypr/automount.conf
yay -S udiskie # daemon

# Mount
# .config/hypr/mount.conf
yay -S polkit-gnome # requisite

# File Manager Support
yay -S gvfs
yay -S gvfs-mtp # Android/MTP Support

# SSD Trim (might already be enabled)
systemctl enable fstrim.timer
```

Clipboard Manager:

```bash
pacman -S cliphist

#.config/hypr/clipboard.conf
```

Disable/Enable Cloud:

```bash
# .config/hypr/cloud.conf
```

### Configure Bar (waybar)

```bash
# .config/hypr/bar.conf
yay -S waybar-hyprland-git

# Needed Fonts
yay -S ttf-font-awesome ttf-jetbrains-mono ttf-icomoon-feather ttf-iosevka-nerd ttf-iosevka

# Needed Applet
yay -S nm-connection-editor

# Needed for auto reload.
yay -S inotify-tools
```

Note: The `music` component on the bar doesn't have wired up buttons, for now it only responds to left/middle/right click.

### Install Oh My Zsh.

```zsh
pacman -S zsh

# We will import Oh My Zsh through a script.
```

Also consider installing autosuggestions:
https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh

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
./update.sh```