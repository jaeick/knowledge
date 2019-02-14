## directory
```
dir_a
├── __init__.py
├── dir_b
│   ├── __init__.py
│   └── file_b.py
├── file_a.py
```

```
root@VM:~/dir_a/dir_b:> python file_b.py
==========================================================================================
__file__ =>  file_b.py
os.path.abspath(__file__) :  /root/dir_a/dir_b/file_b.py
os.path.dirname(__file__) :  
os.path.dirname(os.path.abspath(__file__) :  /root/dir_a/dir_b
os.path.abspath(os.path.dirname(os.path.abspath(__file__))) :  /root/dir_a/dir_b
os.path.dirname(os.path.dirname(os.path.abspath(__file__))) :  /root/dir_a
==========================================================================================
sys.path.addpend(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))) :  ['/root/dir_a/dir_b', '/usr/lib/python2.7', '/usr/lib/python2.7/plat-x86_64-linux-gnu', '/usr/lib/python2.7/lib-tk', '/usr/lib/python2.7/lib-old', '/usr/lib/python2.7/lib-dynload', '/usr/local/lib/python2.7/dist-packages', '/usr/lib/python2.7/dist-packages', '/usr/lib/python2.7/dist-packages/gtk-2.0', '/root/dir_a']
==========================================================================================
hi
```

<pre><code>
import os
import sys

print "=" * 90
print "__file__ => ", __file__
print "os.path.abspath(__file__) : ", os.path.abspath(__file__)
print "os.path.dirname(__file__) : ", os.path.dirname(__file__)
print "os.path.dirname(os.path.abspath(__file__) : ", os.path.dirname(os.path.abspath(__file__))
print "os.path.abspath(os.path.dirname(os.path.abspath(__file__))) : ", os.path.abspath(os.path.dirname(os.path.abspath(__file__)))
print "os.path.dirname(os.path.dirname(os.path.abspath(__file__))) : ", os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
print "=" * 90

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
print "sys.path.addpend(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))) : " , sys.path
print "=" * 90

import file_a
file_a.caller()
</pre></code>
        
     
