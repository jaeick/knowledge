FROM centos:7

RUN yum update
RUN yum install -y tftp-server net-tools
RUN yum clean all

RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

COPY run.sh /usr/sbin/
RUN chmod +x /usr/sbin/run.sh

EXPOSE 69/udp

CMD /usr/sbin/run.sh
