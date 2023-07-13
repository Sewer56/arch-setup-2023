#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export RELOADEDIIMODS=/home/sewer/Desktop/Reloaded-II/Mods/

#export LIBVA_DRIVER_NAME=nvidia
#export XDG_SESSION_TYPE=wayland
#export GBM_BACKEND=nvidia-drm
#export __GLX_VENDOR_LIBRARY_NAME=nvidia
export WLR_NO_HARDWARE_CURSORS=1
#export MOZ_ENABLE_WAYLAND=1 # (REQUIRED: Firefox will break otherwise.)
#export WLR_RENDERER=vulkan
#export SDL_VIDEODRIVER=wayland
#export QT_QPA_PLATFORM=wayland
export KITTY_DISABLE_WAYLAND=1

# Auto start
if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec Hyprland # auto start on boot 
fi

. "$HOME/.cargo/env"
