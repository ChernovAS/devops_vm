
Vagrant.configure("2") do |config|
   config.vm.box = "geerlingguy/centos8"
   config.vm.network "public_network"
   config.vm.provider "virtualbox" do |vb|
   vb.memory = "12480"
  end
   config.vm.provision "shell", inline: <<-SHELL
   echo "nameserver 8.8.8.8" >> /etc/resolv.conf
   sudo mkdir /vagrant
   sudo git clone https://github.com/ChernovAS/devops_vm.git /vagrant
   cd /vagrant && chmod +x install.sh
   sudo ./install.sh
   SHELL
end