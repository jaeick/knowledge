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
