# install pet
cp pet/bin/pet /usr/local/bin/.


# remove old config
rm -r ~/.config/pet
cp -r pet/config/pet ~/.config/.

echo 'alias pc='pet searo "alias pc='pet search | xclip -selection clipboard && xdotool key Ctrl+Shift+V'" >> ~/.bashrc

