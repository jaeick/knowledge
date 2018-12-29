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

## global config
<pre><code>
# grep -v "#" telegraf.conf | grep -v ^$
[[outputs.influxdb]]
  urls = ["http://127.0.0.1:8086"]
  database = "telegraf"
  retention_policy = ""
  write_consistency = "any"
  timeout = "5s"
</pre></code>

## ping export config
<pre><code>
# vi /etc/telegraf/telegraf.d/telegraf_ping.conf 
[[inputs.ping]]
  ## List of urls to ping
  urls = ["8.8.8.8","google.com"]

  ## Number of pings to send per collection (ping -c <COUNT>)
  count = 1

  ## Interval, in s, at which to ping. 0 == default (ping -i <PING_INTERVAL>)
  ## Not available in Windows.
  ping_interval = 1.0

  ## Per-ping timeout, in s. 0 == no timeout (ping -W <TIMEOUT>)
  timeout = 1.0

  ## Total-ping deadline, in s. 0 == no deadline (ping -w <DEADLINE>)
  # deadline = 10

  ## Interface or source address to send ping from (ping -I <INTERFACE/SRC_ADDR>)
  ## on Darwin and Freebsd only source address possible: (ping -S <SRC_ADDR>)
  # interface = ""

  ## Specify the ping executable binary, default is "ping"
  # binary = "ping"
</pre></code>

# Grafana

## Install
<pre><code>
# echo "deb https://packagecloud.io/grafana/stable/debian/ stretch main" | tee /etc/apt/sources.list.d/grafana.list
# curl https://packagecloud.io/gpg.key | sudo apt-key add -
# apt-get update || apt-get intsall grafana
# systemctl start grafana-server
<pre><code>

http://localhost:3000


