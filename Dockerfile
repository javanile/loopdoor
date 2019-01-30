##
# javanile/loopdoor (v0.0.1)
##

FROM ubuntu:18.04

RUN apt-get update \
 && apt-get install -y openssh-server net-tools iputils-ping sshpass \
 && mkdir /var/run/sshd \
 && mkdir /root/.ssh \
 && sed -ri 's/^#?Port 22/Port 55555/' /etc/ssh/sshd_config \
 && sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -ms /bin/bash loopdoor
RUN echo 'loopdoor:736a88e8d44f29037990071d2a55fed5' | chpasswd

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 55555

ENTRYPOINT ["entrypoint.sh"]
