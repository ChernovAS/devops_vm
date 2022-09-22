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

As an access poin briged network is used (its ip address), it is greped and used later for the python webapp.
Basically /health is a redirection towards grafana graph's page with pre-defied parametrs

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
 
4) python simple web server is configured and executed on port 8001 which has been proxied to http://<server_ip>/app 
for /app: on the main page there is a link (HEALTH) with Prometheus Graphs which is playing role of /health page,
below: page visitors counter is located, it is not ideal (because value is string), but it updates dynamic.

This was achieved with help of the official python prometheus-client (https://github.com/prometheus/client_python).

Things to improve:
1) SElinux ansible configuration: due to some issues with python libraries (which I was not able to resolve) ansible is not able to manage SELinux
2) Grafana defaul path is http://<server_ip>/grafana/d/pythonapp , it should be /grafana/dashboard instead. No idea how to resolve this, dashbord uid rename is kinda working
but still there is /d in the path right after /grafana
3) as a workaround on the webapp Prometheus graphs page is used with requred parameters
http://<server_bridged_ip>:9090/graph?g0.range_input=1h&g0.expr=%20rate(server_requests_total%5B1m%5D)&g0.tab=0&g1.range_input=1h&g1.expr=rate(process_resident_memory_bytes%7Bjob%3D%27python-app%27%7D%5B1m%5D)&g1.tab=0&g2.range_input=1h&g2.expr=rate(process_cpu_seconds_total%7Bjob%3D%27python-app%27%7D%5B1m%5D)&g2.tab=0

But NGINX is not proxying it to /health

.

