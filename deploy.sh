#!/bin/bash

# Copy over Files
chmod -R 755 ./.config/
cp -R ./.config/* $HOME/.config
cp -R ./Pictures/* $HOME/Pictures

# Setup zsh
chsh -s $(which zsh)
cp -R ./.zshenv $HOME/.zshenv

# Fix bookmarks
sed -i "s|/home/your_username|/home/$USER|g" ~/.config/gtk-3.0/bookmarks