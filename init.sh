# Luodaan hakemisto jos ei ole jo olemassa
mkdir -p ~/.config/nvim
# Symlinkki kyseiseen hakemistoon koska nvim hakee sieltä
ln -s nvim/init.lua ~/.config/nvim/init.lua

# Symlinkki skhdrc
ln -s skhd/skhdrc ~/.skhdrc

# Symlinkki tmux konffiin
ln -s tmux/tmux.conf ~/.tmux.conf

ln -s zsh/zprofile ~/.zprofile
ln -s zsh/zprofile ~/.zshenv
ln -s zsh/zshrc ~/.zshrc

# Install zsh plugins
./zsh/install-plugins.sh

# Symlinkki claude commandeihin
mkdir -p ~/.claude
ln -s claude/commands ~/.claude/commands
