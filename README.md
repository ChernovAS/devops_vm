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
2) Grafana deployment and configuration to serve with subpath, anonymous view of the provided dashboard
Dashbord and datasource are imported from pre-created files
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
