## sudo without password
<pre><code>
$ echo "ubuntu ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/ubuntu
</pre></code>

## root login on GUI
<pre><code>
# vi /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
[Seat:*]
user-session=ubuntu
greeter-show-manual-login=true

# vi /root/.profile
tty -s && mesg n

# reboot
</pre></code>
