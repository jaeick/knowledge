FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y tacacs+ net-tools vim
RUN apt-get clean

COPY run.sh /usr/sbin/
RUN chmod +x /usr/sbin/run.sh

EXPOSE 49

CMD /usr/sbin/run.sh
