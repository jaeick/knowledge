## Install docker
<pre><code>
# apt-get install docker.io
</pre></code>

## Install docker-compose
<pre><code>
# curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# chmod +x /usr/local/bin/docker-compose

# docker-compose --version
docker-compose version 1.23.1, build 1719ceb
</pre></code>

## Run
<pre><code>
# docker-compose up -d
# docker-compose down
</pre></code>
