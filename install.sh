# install dependecies
sudo apt install fzf
sudo apt install xclip
sudo apt install xdotool
# install pet
sudo cp pet/bin/pet /usr/local/bin/.

# remove old config
rm -r ~/.config/pet
mkdir ~/.config/pet
cp  pet/config/config.toml  ~/.config/pet/.
cp  pet/config/snippet.toml  ~/.config/pet/.

echo 'alias pc='pet searo "alias pc='pet search | xclip -selection clipboard && xdotool key Ctrl+Shift+V'" >> ~/.bashrc

