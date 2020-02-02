#!/bin/ruby
Vagrant.configure("2") do |config|
 config.vm.box = "ubuntu/bionic64" # officially published image
 config.vm.network "forwarded_port", guest: 8080, host: 8080
 config.vm.network "forwarded_port", guest: 80, host: 80

  # config.vbguest.auto_update = false

  config.vm.synced_folder ".", "/vagrant", owner: "vagrant", group: "vagrant", mount_options: ["dmode=777", "fmode=700"]

  Dir.mkdir(ENV['HOME'] + "/.aws") unless Dir.exist?(ENV['HOME'] + "/.aws")

#  config.vm.synced_folder ENV['HOME'] + "/.aws", "/home/vagrant/.aws"
  config.vm.synced_folder "/.aws", "/home/vagrant/.aws"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = 2048
    vb.cpus = 2
  end

  config.vm.define :provisioner do |provisioner|
    # Install Ansible, Packer, Docker, Git, Terraform and Kubernetes
    provisioner.vm.provision "shell", inline: "sudo apt-get update"
    provisioner.vm.provision "shell", inline: "sudo apt install -y docker.io python3-pip"
    provisioner.vm.provision "shell", inline: "sudo apt install -y ntp"
    provisioner.vm.provision "shell", inline: "sudo apt install -y ntpdate"
    provisioner.vm.provision "shell", inline: "zcat <(curl -s \"https://releases.hashicorp.com/terraform/0.12.13/terraform_0.12.13_linux_amd64.zip\") | sudo tee /usr/bin/terraform > /dev/null && sudo chmod +x /usr/bin/terraform"
    provisioner.vm.provision "shell", inline: "zcat <(curl -s \"https://releases.hashicorp.com/packer/1.4.3/packer_1.4.3_linux_amd64.zip\" ) | sudo tee /usr/bin/packer > /dev/null && sudo chmod +x /usr/bin/packer"
    provisioner.vm.provision "shell", inline: "sudo pip3 install awscli --upgrade"
    provisioner.vm.provision "shell", inline: "sudo -H pip3 install ansible==2.8.5"
    provisioner.vm.provision "shell", inline: "sudo gpasswd -a vagrant docker && newgrp docker" # enable non-root docker
    provisioner.vm.provision "shell", inline: "sudo curl -s https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl -o /usr/bin/kubectl && sudo chmod +x /usr/bin/kubectl"
    # zsh and more
    provisioner.vm.provision "shell", inline: "/bin/tar xvf /vagrant/logfiles.tar.gz" 
    provisioner.vm.provision "shell", inline: "cp /vagrant/gitsh.sh /home/vagrant/ && chown vagrant:vagrant /home/vagrant/gitsh.sh" 
    provisioner.vm.provision "shell", inline: "cp /vagrant/config /home/vagrant/.ssh/ && chown vagrant:vagrant /home/vagrant/.ssh/config && chmod 400 /home/vagrant/.ssh/config" 
    provisioner.vm.provision "shell", inline: "mv github_rsa /home/vagrant/.ssh/ && chown vagrant:vagrant /home/vagrant/.ssh/github_rsa"
    provisioner.vm.provision "shell", inline: "apt-get install -y cowsay"
    provisioner.vm.provision "shell", inline: "apt-get install -y fortune"
    provisioner.vm.provision "shell", inline: "apt-get install -y cmatrix"
    provisioner.vm.provision "shell", inline: "apt-get install -y pyjoke"
    provisioner.vm.provision "shell", inline: "apt install -y zsh"
    provisioner.vm.provision "shell", inline: "sudo chsh -s /usr/bin/zsh vagrant "
    provisioner.vm.provision "shell", inline: "sudo chsh -s /usr/bin/zsh root "
    provisioner.vm.provision "shell", inline: "echo 'install oh-my-zsh'"
    provisioner.vm.provision "shell", inline: "wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh"
    provisioner.vm.provision "shell", inline: "cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc"
    provisioner.vm.provision "shell", inline: "curl -L git.io/antigen > antigen.zsh"
    provisioner.vm.provision "shell", inline: "echo 'antigen bundle git' >> .zshrc"
    provisioner.vm.provision "shell", inline: "echo 'antigen use oh-my-zsh' >> .zshrc"
    provisioner.vm.provision "shell", inline: "echo 'source ~/antigen.zsh' >> .zshrc"
    provisioner.vm.provision "shell", inline: "cp ~/.zshrc /home/vagrant/.zshrc"
    provisioner.vm.provision "shell", inline: "chown vagrant:vagrant /home/vagrant/.zshrc"
    provisioner.vm.provision "shell", inline: "cp -r ~/.oh-my-zsh/ /home/vagrant/.oh-my-zsh"
    provisioner.vm.provision "shell", inline: "mkdir dotfiles"
    provisioner.vm.provision "shell", inline: "chown -R vagrant:vagrant .oh-my-zsh"
    provisioner.vm.provision "shell", inline: "chown vagrant:vagrant antigen.zsh"
    provisioner.vm.provision "shell", inline: "chown vagrant:vagrant dotfiles"
    provisioner.vm.provision "shell", inline: "echo 'echo \"Welcome To DEV MACHINE \"|cowsay' >> .zshrc"
    # vim and more
    provisioner.vm.provision "shell", inline: "sudo mkdir -p ~/.vim/autoload ~/.vim/bundle"
    provisioner.vm.provision "shell", inline: "curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim"
    provisioner.vm.provision "shell", inline: "mkdir -p /home/vagrant/.vim/autoload /home/vagrant/.vim/bundle"
    provisioner.vm.provision "shell", inline: "curl -LSso /home/vagrant/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim"
    provisioner.vm.provision "shell", inline: "curl -sLf https://spacevim.org/install.sh | bash"
    provisioner.vm.provision "shell", inline: "sudo runuser -l vagrant -c 'curl -sLf https://spacevim.org/install.sh | bash'"
    #
    provisioner.vm.provision "shell", inline: "kubectl version --short --client"
    provisioner.vm.provision "shell", inline: "docker --version"
    provisioner.vm.provision "shell", inline: "aws --version"
    provisioner.vm.provision "shell", inline: "packer --version"
    provisioner.vm.provision "shell", inline: "terraform --version"

  end
end


