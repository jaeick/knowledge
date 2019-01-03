FROM centos:7

RUN yum update
RUN yum install -y freeradius net-tools
RUN yum clean all

COPY run.sh /usr/sbin/
RUN chmod +x /usr/sbin/run.sh

EXPOSE 1812-1813/udp 18120/udp


CMD /usr/sbin/run.sh
