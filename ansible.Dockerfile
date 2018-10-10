FROM ubuntu:bionic

# RUN add-apt-repository ppa:ansible/ansible
RUN apt-get update
RUN apt-get install -y software-properties-common ansible sudo openssh-server
RUN mkdir /var/run/sshd

RUN useradd -c 'Ansible User' -m -d /home/ansible -s /bin/bash ansible
RUN adduser ansible sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /home/ansible/.ssh
RUN chmod 0700 /home/ansible/.ssh
COPY ssh_config /home/ansible/.ssh/config
COPY ansible /home/ansible/.ssh/id_rsa
COPY ansible.pub /home/ansible/.ssh/id_rsa.pub
COPY ansible.pub /home/ansible/.ssh/authorized_keys
RUN chown -R ansible:ansible /home/ansible/

RUN ansible --version

ENV HOME /home/ansible
EXPOSE 22
USER ansible
CMD ["sudo", "/usr/sbin/sshd", "-D"]
