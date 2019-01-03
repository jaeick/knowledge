## lshw

<pre><code>
# lshw -class network -businfo
Bus info          Device     Class          Description
=======================================================
pci@0000:02:00.0  enp2s0f0   network        Ethernet Controller X710 for 10GbE SFP+
pci@0000:02:00.1  enp2s0f1   network        Ethernet Controller X710 for 10GbE SFP+
pci@0000:02:00.2  enp2s0f2   network        Ethernet Controller X710 for 10GbE SFP+
pci@0000:02:00.3  enp2s0f3   network        Ethernet Controller X710 for 10GbE SFP+
pci@0000:04:00.0  ens15f0    network        I350 Gigabit Network Connection
pci@0000:04:00.1  ens15f1    network        I350 Gigabit Network Connection
pci@0000:04:00.2  ens15f2    network        I350 Gigabit Network Connection
pci@0000:04:00.3  ens15f3    network        I350 Gigabit Network Connection
pci@0000:0a:00.0  enp10s0    network        I210 Gigabit Network Connection
pci@0000:0b:00.0  enp11s0    network        I210 Gigabit Network Connection
pci@0000:83:00.0  ens4f0     network        I350 Gigabit Fiber Network Connection
pci@0000:83:00.1  ens4f1     network        I350 Gigabit Fiber Network Connection
pci@0000:83:00.2  ens4f2     network        I350 Gigabit Fiber Network Connection
pci@0000:83:00.3  ens4f3     network        I350 Gigabit Fiber Network Connection
</pre></code>

## lspci
### install
<pre><code>
# yum install pciutils
</pre><code>

<pre><code>
# lspci | grep Ether
02:00.0 Ethernet controller: Intel Corporation Ethernet Controller X710 for 10GbE SFP+ (rev 02)
02:00.1 Ethernet controller: Intel Corporation Ethernet Controller X710 for 10GbE SFP+ (rev 02)
02:00.2 Ethernet controller: Intel Corporation Ethernet Controller X710 for 10GbE SFP+ (rev 02)
02:00.3 Ethernet controller: Intel Corporation Ethernet Controller X710 for 10GbE SFP+ (rev 02)
04:00.0 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
04:00.1 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
04:00.2 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
04:00.3 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
0a:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
0b:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
83:00.0 Ethernet controller: Intel Corporation I350 Gigabit Fiber Network Connection (rev 01)
83:00.1 Ethernet controller: Intel Corporation I350 Gigabit Fiber Network Connection (rev 01)
83:00.2 Ethernet controller: Intel Corporation I350 Gigabit Fiber Network Connection (rev 01)
83:00.3 Ethernet controller: Intel Corporation I350 Gigabit Fiber Network Connection (rev 01)
</pre></code>
