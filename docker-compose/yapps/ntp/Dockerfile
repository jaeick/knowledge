FROM centos:7

RUN yum update
RUN yum install -y ntp net-tools
RUN yum clean all

COPY run.sh /usr/sbin/
RUN chmod +x /usr/sbin/run.sh

EXPOSE 123/udp

CMD /usr/sbin/run.sh
