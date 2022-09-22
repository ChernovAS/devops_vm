import http.server
from prometheus_client import start_http_server
from prometheus_client import Counter

with open('ipaddr','r') as file:
  IPAddr = file.read().replace('\n','')

REQUESTS = Counter('server_requests_total', 'Total number of requests to this webserver')

class ServerHandler(http.server.BaseHTTPRequestHandler):
  def do_GET(self):
    REQUESTS.inc()
    self.send_response(200)
    self.end_headers()
    self.wfile.write(bytes("<html><body><a href='http://" + IPAddr + ":9090/graph?g0.range_input=1h&g0.expr=%20rate(server_requests_total%5B1m%5D)&g0.tab=0&g1.range_input=1h&g1.expr=rate(process_resident_memory_bytes%7Bjob%3D%27python-app%27%7D%5B1m%5D)&g1.tab=0&g2.range_input=1h&g2.expr=rate(process_cpu_seconds_total%7Bjob%3D%27python-app%27%7D%5B1m%5D)&g2.tab=0'>HEALTH</a></body></html>", "utf-8"))
    self.wfile.write(Counter)
    

if __name__ == "__main__":
  start_http_server(8000)
  server = http.server.HTTPServer(('', 8001), ServerHandler)
  print("Prometheus metrics available on port 8000 /metrics")
  print("HTTP server available on port 8001")
  server.serve_forever()
