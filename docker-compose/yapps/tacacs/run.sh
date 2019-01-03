#!/bin/bash

sed -i "s/key = testing123/key = ${TACACS_KEY}/" /etc/tacacs+/tac_plus.conf
echo -e "user = ${TACACS_AAA_USER} {" >> /etc/tacacs+/tac_plus.conf
echo -e "\tdefault service = permit" >> /etc/tacacs+/tac_plus.conf
echo -e "\tlogin = cleartext ${TACACS_AAA_PASS}" >> /etc/tacacs+/tac_plus.conf
echo -e "}" >> /etc/tacacs+/tac_plus.conf

/usr/sbin/tac_plus -C /etc/tacacs+/tac_plus.conf
tail -f /dev/null
