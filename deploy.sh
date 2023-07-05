#!/bin/bash

chmod -R 755 ./.config/
cp -R ./.config/* $HOME/.config
cp -R ./Pictures/* $HOME/Pictures

chsh -s $(which zsh)
cp -R ./.zshenv $HOME/.zshenv