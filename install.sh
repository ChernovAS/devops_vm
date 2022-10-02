#/!bin/bash
#######################################
sleep 3
echo "==============================="
echo "===PREPARING FOR DNF UPDATE===="
echo "==============================="
sleep 3
YUM_REPO=/etc/yum.repos.d/
sudo sed -i 's/mirrorlist/#mirrorlist/g' $YUM_REPO/CentOS-* && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' $YUM_REPO/CentOS-*
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
#sudo dnf update -y
#sudo dnf makecache
sleep 3
echo "==============================="
echo "====INSTALLING DEPENDENCIES===="
echo "==============================="
cd /vagrant
sudo dnf install epel-release python39 -y
sudo dnf install python39-PyYAML python39-cryptography python39-six -y
wget http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/ansible-core-2.13.3-1.el8.x86_64.rpm
wget http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/sshpass-1.09-4.el8.x86_64.rpm
sudo rpm -ivh sshpass-1.09-4.el8.x86_64.rpm ansible-core-2.13.3-1.el8.x86_64.rpm
pip3 install prometheus-client
sleep 3
echo "==============================="
echo "====ANSIBLE           STUFF===="
echo "==============================="
sudo mkdir -p /etc/dashboards/python_app/
sudo mkdir ansible
ANSIBLE=/vagrant/ansible
ansible-galaxy init $ANSIBLE/roles/nginx
ansible-galaxy init $ANSIBLE/roles/grafana
ansible-galaxy init $ANSIBLE/roles/iptables
ansible-galaxy init $ANSIBLE/roles/webapp
#ansible-galaxy init $ANSIBLE/roles/selinux
ansible-galaxy collection install ansible.posix
git clone https://github.com/MiteshSharma/PrometheusWithAnsible
cp -pR PrometheusWithAnsible/roles/* $ANSIBLE/roles/
sudo mv main_task_nginx.yml $ANSIBLE/roles/nginx/tasks/main.yml
sudo mv nginx.conf $ANSIBLE/roles/nginx/templates/
sudo mv main_task_grafana.yml $ANSIBLE/roles/grafana/tasks/main.yml
sudo mv grafana.ini $ANSIBLE/roles/grafana/templates/
sudo mv datasources.yml $ANSIBLE/roles/grafana/templates/
sudo mv dashboards.yml $ANSIBLE/roles/grafana/templates/
sudo mv pythonapp.json $ANSIBLE/roles/grafana/templates/
#sudo mv selinux.yml $ANSIBLE/roles/selinux/tasks/main.yml
sudo mv iptables.yml $ANSIBLE/roles/iptables/tasks/main.yml
sudo mv pythonwebapp.yml ANSIBLE/roles/webapp/tasks/main.yml
mv webapp.service $ANSIBLE/roles/webapp/templates/
sleep 3
#!!!!!INSTALL PYTHON APP
sudo mkdir -p projects/python
mv webapp.py projects/python/
sudo /sbin/ifconfig enp0s8 | grep 'inet' | cut -d: -f2 | awk '{print $2}' > projects/python/ipaddr
#nohup python3 projects/python/webapp.py &
sleep 3
echo "==============================="
echo "====ANSIBLE           START===="
echo "==============================="
###ssh-keys
#sudo echo | ssh-keygen -N ''
#sudo sshpass -p vagrant ssh-copy-id localhost.localdomain
echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$(whoami)
sudo mv playbook.yml inventory.yml ansible/
ansible-playbook -i ansible/inventory.yml ansible/playbook.yml
sleep 120
sudo echo -e "  - job_name: 'python-app'\n    static_configs:\n      - targets: ['localhost:8000']" >> /etc/prometheus/prometheus.conf
systemctl restart prometheus
echo "==============================="
echo "===DONE_DONE_DONE_DONE_DONE===="
echo "==============================="
