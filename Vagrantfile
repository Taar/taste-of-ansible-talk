# -*- mode: ruby -*-
# vi: set ft=ruby :

# README
#
# Getting Started:
# 1. vagrant plugin install vagrant-hostmanager
# 2. vagrant up
# 3. vagrant ssh

Vagrant.configure(2) do |config|
  config.hostmanager.enabled = true

  config.vm.provider "virtualbox"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
  end

  config.vm.box = "ubuntu/bionic64"

  config.vm.define "control", primary: true do |h|
    h.vm.provider "virtualbox" do |vb|
      vb.cpus = 1
    end
    h.vm.hostname = "control"
    h.vm.network "private_network", ip: "192.168.135.10"
    h.vm.synced_folder "deploy", "/home/vagrant/deploy", create: true
    h.vm.provision :shell, :inline => <<'EOF'
cp /vagrant/ansible.pub /home/vagrant/.ssh/id_rsa.pub
cp /vagrant/ansible /home/vagrant/.ssh/id_rsa
cp /vagrant/ssh_config /home/vagrant/.ssh/config
chown -R vagrant:vagrant /home/vagrant/.ssh/
EOF
  end

  config.vm.define "webserver01" do |h|
    h.vm.hostname = "webserver01"
    h.vm.network "private_network", ip: "192.168.135.11"
    h.vm.provision :shell, inline: 'cat /vagrant/ansible.pub >> /home/vagrant/.ssh/authorized_keys'
  end

  config.vm.define "database01" do |h|
    h.vm.hostname = "database01"
    h.vm.network "private_network", ip: "192.168.135.12"
    h.vm.provision :shell, inline: 'cat /vagrant/ansible.pub >> /home/vagrant/.ssh/authorized_keys'
  end
end
