
Vagrant.configure("2") do |config|
   config.vm.box = "geerlingguy/centos8"
   config.vm.network "public_network"
   config.vm.provider "virtualbox" do |vb|
   vb.memory = "12480"
  end
   config.vm.provision "shell", inline: <<-SHELL
   echo "nameserver 8.8.8.8" >> /etc/resolv.conf
   YUM_REPO=/etc/yum.repos.d/
   sudo sed -i 's/mirrorlist/#mirrorlist/g' $YUM_REPO/CentOS-* && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' $YUM_REPO/CentOS-*
   sleep 3
   echo "installing dependencies"
   sleep 1
   cd /vagrant
   sudo dnf install epel-release python39 -y
   sudo dnf install python39-PyYAML python39-cryptography python39-six -y
   wget http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/ansible-core-2.13.3-1.el8.x86_64.rpm
   wget http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/sshpass-1.09-4.el8.x86_64.rpm
   sudo rpm -ivh sshpass-1.09-4.el8.x86_64.rpm ansible-core-2.13.3-1.el8.x86_64.rpm
   pip3 install prometheus-client
   sleep 3
   echo "installing and configuring Ansible"
   sleep 1
   sudo mkdir -p /etc/dashboards/python_app/
   sudo mkdir ansible
   ANSIBLE=/vagrant/ansible
   ansible-galaxy init $ANSIBLE/roles/nginx
   ansible-galaxy init $ANSIBLE/roles/grafana
   ansible-galaxy init $ANSIBLE/roles/iptables
   git clone https://github.com/MiteshSharma/PrometheusWithAnsible
   cp -pR PrometheusWithAnsible/roles/* $ANSIBLE/roles/
   sudo mv main_task_nginx.yml $ANSIBLE/roles/nginx/tasks/main.yml
   sudo mv nginx.conf $ANSIBLE/roles/nginx/templates/
   sudo mv main_task_grafana.yml $ANSIBLE/roles/grafana/tasks/main.yml
   sudo mv grafana.ini $ANSIBLE/roles/grafana/templates/
   sudo mv datasources.yml $ANSIBLE/roles/grafana/templates/
   sudo mv dashboards.yml $ANSIBLE/roles/grafana/templates/
   sudo mv pythonapp.json $ANSIBLE/roles/grafana/templates/
   sudo mv iptables.yml $ANSIBLE/roles/iptables/tasks/main.yml
   sleep 3
   echo "python app"
   sleep 1
   sudo mkdir -p projects/python
   mv webapp.py projects/python/
   sudo /sbin/ifconfig enp0s8 | grep 'inet' | cut -d: -f2 | awk '{print $2}' > projects/python/ipaddr
   nohup python3 projects/python/webapp.py &
   sleep 3
   echo "ansible start"
   sudo echo | ssh-keygen -N dev0pS
   sudo sshpass -p dev0pS ssh-copy-id localhost.localdomain
   sudo mv playbook.yml hosts ansible/
   ansible-playbook -i $ANSIBLE/hosts $ANSIBLE/playbook.yml
   sudo mv prometheus.conf /etc/prometheus/
   systemctl restart prometheus
   SHELL
end