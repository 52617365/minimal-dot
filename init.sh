# Luodaan hakemisto jos ei ole jo olemassa
mkdir -p ~/.config/nvim
# Symlinkki kyseiseen hakemistoon koska nvim hakee sieltä
ln -s nvim/init.lua ~/.config/nvim/init.lua

# Symlinkki tmux konffiin
ln -s tmux/tmux.conf ~/.tmux.conf

ln -s zsh/zprofile ~/.zprofile
ln -s zsh/zshrc ~/.zshrc
