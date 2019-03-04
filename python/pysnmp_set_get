from pysnmp.hlapi import *
import time

dut = "10.55.195.192"
os2 = "PSGS-2710G_v7.10.1834_201812024.imgs"
os1 = "PSGS-2710G_v7.10.1839_201812024.imgs"

iloop = 0
while iloop < 100:
    for os in [os1, os2]:

        # check runing version
        errorIndication, errorStatus, errorIndex, varBinds = next(
            getCmd(SnmpEngine(),
                   CommunityData('public'),
                   UdpTransportTarget((dut, 161)),
                   ContextData(),
                   ObjectType(ObjectIdentity('1.3.6.1.4.1.6296.6.5205.1.1.1.1.1.10.1')),
                   )
        )

        if errorIndication:
            print(errorIndication)
        elif errorStatus:
            print('%s at %s' % (errorStatus.prettyPrint(),
                                errorIndex and varBinds[int(errorIndex) - 1][0] or '?'))
        else:
            for varBind in varBinds:
                print(' = '.join([x.prettyPrint() for x in varBind]))

        # upgrade os
        errorIndication, errorStatus, errorIndex, varBinds = next(
            setCmd(SnmpEngine(),
                CommunityData('private'),
                UdpTransportTarget((dut, 161)),
                ContextData(),
                ObjectType(ObjectIdentity('1.3.6.1.4.1.6296.6.5205.1.4.3.3.0'), IpAddress('10.55.57.1')),
                ObjectType(ObjectIdentity('1.3.6.1.4.1.6296.6.5205.1.4.3.4.0'), OctetString(os)),
                ObjectType(ObjectIdentity('1.3.6.1.4.1.6296.6.5205.1.4.3.5.0'), Integer(1)),
                )
        )

        if errorIndication:
            print(errorIndication)
        elif errorStatus:
            print('%s at %s' % (errorStatus.prettyPrint(),
                                errorIndex and varBinds[int(errorIndex) - 1][0] or '?'))
        else:
            for varBind in varBinds:
                print(' = '.join([x.prettyPrint() for x in varBind]))

        for t in range(1,11):
            time.sleep(60)
            print("{} minutes waited.".format(t))

        # reboot system
        errorIndication, errorStatus, errorIndex, varBinds = next(
            setCmd(SnmpEngine(),
                CommunityData('private'),
                UdpTransportTarget((dut, 161)),
                ContextData(),
                ObjectType(ObjectIdentity('1.3.6.1.4.1.6296.6.5205.1.4.1.0'), Integer(1)),
                )
        )

        if errorIndication:
            print(errorIndication)
        elif errorStatus:
            print('%s at %s' % (errorStatus.prettyPrint(),
                                errorIndex and varBinds[int(errorIndex) - 1][0] or '?'))
        else:
            for varBind in varBinds:
                print(' = '.join([x.prettyPrint() for x in varBind]))

        time.sleep(30)

        # check running version
        errorIndication, errorStatus, errorIndex, varBinds = next(
            getCmd(SnmpEngine(),
                   CommunityData('public'),
                   UdpTransportTarget((dut, 161)),
                   ContextData(),
                   ObjectType(ObjectIdentity('1.3.6.1.4.1.6296.6.5205.1.1.1.1.1.10.1')),
                   )
        )

        if errorIndication:
            print(errorIndication)
        elif errorStatus:
            print('%s at %s' % (errorStatus.prettyPrint(),
                                errorIndex and varBinds[int(errorIndex) - 1][0] or '?'))
        else:
            for varBind in varBinds:
                print(' = '.join([x.prettyPrint() for x in varBind]))

        iloop += 1
        print("{} times done.".format(iloop))
        print("#"*100)
