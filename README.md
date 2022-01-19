# Vagrant

This project is a collection of Vagrant files used for tests/lab purposes

### Tech - A1

Vagrantfile description:

* [elasticsearch] - Deploy Centos7 VM and install ElasticSearch/JournalBeat/Kibana
* [jenkins] - Deploy Centos7 VM and install Jenkins
* [php-mysql] - Deploy 2 Ubuntu VMs and install Apache/PHP and MySQL host
* [prometheus] - Deploy 2 Ubuntu VMs and install Prometheus/NodeExport and Grafana host
* [wordpress] - Deploy 2 Ubuntu VM and install Apache/PHP/Wordpress and MySQL host 

### Installation - A2

Prerequisites:

Virtualbox
https://www.virtualbox.org/wiki/Downloads

Install Vagrant:
https://learn.hashicorp.com/tutorials/vagrant/getting-started-install?in=vagrant/getting-started


### Execute Vagrant

Go to you VagrantFile directory

Create virtual machine:

```sh
$ vagrant up
```

Acessing terminal:

```sh
$ vagrant ssh
```

