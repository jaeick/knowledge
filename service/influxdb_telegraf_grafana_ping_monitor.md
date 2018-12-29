# Influxdb

## Install
<pre><code>
# curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
# source /etc/lsb-release
# echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
# apt-get update && apt-get install influxdb
# systemctl start influxdb
</pre></code>

# Telegraf

## Install telegraf
<pre><code>
# apt-get install telegraf
# apt-get install iputils-ping
</pre></code>

## /etc/telegraf/telegraf.conf
<pre><code>
[agent]
  interval = "1s"
  flush_interval = "1s"

[[outputs.influxdb]]
  urls = ["http://127.0.0.1:8086"]
  database = "telegraf"
  retention_policy = ""
  write_consistency = "any"
  timeout = "5s"

[[inputs.ping]]
  urls = ["8.8.8.8","google.com"]
  count = 1
  ping_interval = 1.0
  timeout = 1.0
</pre></code>

## start service
<pre><code>
# systemctl start telegraf
</pre></code>

# Grafana

## Install
<pre><code>
# echo "deb https://packagecloud.io/grafana/stable/debian/ stretch main" | tee /etc/apt/sources.list.d/grafana.list
# curl https://packagecloud.io/gpg.key | sudo apt-key add -
# apt-get update || apt-get intsall grafana
# systemctl start grafana-server
</pre></code>

http://localhost:3000 (admin/admin)


