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

## home directory name [KOR->EN]
<pre><code>
# export LANG=C
# xdg-user-dirs-gtk-update
</pre></code>
export LANG=C의 의미는 locale을 끄겠다는 의미라고 한다. "C"라는 값은 로케일 표준에 정의되어 있는 locale name이라고 한다.
