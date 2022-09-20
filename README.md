This project is for the automatic VM deployment with such features on board:
1) Grafana
2) Prometheus
3) Nginx
4) Ansible
5) Python-web

All provisioning is happening via Varantfile (SHELL section).
During the VM deployment all requred config files will be copied to related Ansible roles directories.
VM will be started and required dependencies will be installed.
Later ansible will be executed and via playbook file all requred app will be deployed and configured.

Ansible playbook contains:
1) NGINX is used as a proxy to replace default path for grafana from http://<server_ip>:3000 to http://<server_ip>/grafana
for python_app it is redirecting http://localhost:8001 to http://<server_ip>/app
2) Grafana deployment and configuration to serve with subpath, anonymous view of the provided dashboard
Dashbord and datasource are imported from pre-created files. 
3) Prometheus is used from github: prometheus itself, node_exporter and blackbox_exporter, all configs are default.
To scrape python app parametrs prometheus.conf is replaced with modified conf file.
SELinux is enabled by_default with VM, it is not managed via Ansible.

IPtables are managed via ansible:  with allowed ports:
      - "22"
      - "80"
      - "443"
      - "8080"
      - "3000"
      - "8000:9999"
      

Things to improve:
1) SElinux ansible configuration: due to some issues with python libraries (which I was not able to resolve) ansible is not able to manage SELinux
2) Grafana defaul path is http://<server_ip>/grafana/d/pythonapp , it should be /grafana/dashboard instead. No idea how to resolve this, dashbord uid rename is kinda working
but still there is /d in the path right after /grafana
3) Python app - pain in my asshole so far :)
THere should be 2 pages, one with http app counter and prometheus cpu/ram_scrape on te other page.

* as a trick on the webapps page grafana monitoring might be forwarded
