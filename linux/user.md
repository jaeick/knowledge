## sudo without password
<pre><code>
$ echo "ubuntu ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/ubuntu
</pre></code>

## Root login on GUI
/usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
<pre><code>
[Seat:*]
user-session=ubuntu
greeter-show-manual-login=true
</pre></code>
/root/.profile
<pre><code>
tty -s && mesg n
</pre></code>

