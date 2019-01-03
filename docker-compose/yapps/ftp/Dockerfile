FROM centos:7

RUN yum update
RUN yum install -y vsftpd net-tools
RUN yum clean all

COPY run.sh /usr/sbin/
RUN chmod +x /usr/sbin/run.sh

EXPOSE 21 50001-50010

CMD /usr/sbin/run.sh
