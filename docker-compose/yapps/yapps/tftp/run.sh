#!/bin/bash

bash -c "/usr/sbin/in.tftpd -l -s -c /tmp"
tail -f /dev/null
