git config --global user.name "Leonardo Castano";
git config --global user.email "leonardo.castnao@gmail.com";
echo "alias gconf='/usr/bin/git --git-dir=/home/vagrant/dotfiles/ --work-tree=/home/vagrant/'" >> /home/vagrant/.zshrc;
. /home/vagrant/.zshrc;
git clone --bare git@github.com:leonardocastanodiaz/dotfiles.git /home/vagrant/dotfiles;
gconf config --local status.showUntrackedFiles no
