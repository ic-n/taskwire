FROM fedora

ARG PASSWORD

RUN dnf upgrade --refresh -y
RUN dnf install openssh-server -y
RUN mkdir /var/run/sshd

RUN sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
 && echo "root:${PASSWORD}" | chpasswd

RUN sed -ie 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
RUN /usr/bin/ssh-keygen -A
RUN ssh-keygen -t rsa -b 4096 -f  /etc/ssh/ssh_host_key
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN mkdir ~/.ssh
RUN chmod 700 ~/.ssh
RUN touch ~/.ssh/authorized_keys
RUN chmod 600 ~/.ssh/authorized_keys

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]