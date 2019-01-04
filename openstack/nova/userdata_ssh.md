## userdate of setting SSH passwd

<pre><code>
#cloud-config
password: ubuntu123
chpasswd: { expire: False }
ssh_pwauth: True
</pre></code>
