# IAC_Vagrant

Infrastructure as Code (IaC) projects built using Vagrant and VMware ESXi.

This repository contains multiple Vagrant environments ranging from simple single-machine deployments to complete multi-tier application stacks. All projects are designed to run on **VMware ESXi** rather than VirtualBox.

---

## Requirements

* Vagrant
* VMware ESXi
* VMware ESXi Vagrant Plugin

VMware ESXi support is provided through:

https://github.com/josenk/vagrant-vmware-esxi

---

# Repository Structure

## Simple Single-VM Projects

If you need a quick Vagrant machine, you can use any of the following folders:

* `ubuntu-22`
* `rocky9`
* `ubuntu-20-wordpress ## google ubuntu wordpress.`  

Each folder contains a standalone Vagrant environment for a specific purpose.

---

## portfolioIAC

A single-box deployment project where the complete website deployment is automated through Vagrant provisioning.

Features:

* Automatic server setup
* Automated web deployment
* Infrastructure provisioning through shell scripts

---

## multivm

A multi-machine Vagrant environment managed from a single Vagrantfile.

Current status:

* Multiple virtual machines are deployed successfully.
* Some provisioning and automation tasks are still under development.

---

# VProfile Project

The `vprofile` directory contains the most complete and advanced project in this repository.
It demonstrates a classic multi-tier application architecture.

## Architecture
  Nginx: Acts as a reverse proxy and forwards incoming requests to Tomcat.
  Tomcat: Hosts and runs the Java web application.
  MySQL: Stores application data and handles database operations.
  RabbitMQ: Provides message queuing and workload distribution between services.
  Memcached: Caches frequently requested data to reduce database load and improve application response times.

---

## Deployment Design

* All VProfile virtual machines are defined inside a single `Vagrantfile`.
* Each machine receives its configuration through dedicated provisioning Bash scripts.
* The environment is designed to demonstrate infrastructure automation and service integration.

---

# Useful Notes

For VMware ESXi users, the following Windows box has been tested and can be useful:

```bash
  config.vm.box = 'generic/rocky9'
  config.vm.box = "generic/ubuntu2204"
  config.vm.box = 'bento/ubuntu-20.04'
  config.vm.box = 'StefanScherer/windows_2016'
  config.vm.box = 'hashicorp/precise64'
  #config.vm.box = 'generic/centos7'
  #config.vm.box = 'generic/centos6'
  #config.vm.box = 'generic/fedora27'
  #config.vm.box = 'generic/freebsd11'
  #config.vm.box = 'generic/ubuntu1710'
  #config.vm.box = 'generic/debian9'
  #config.vm.box = 'steveant/CentOS-7.0-1406-Minimal-x64'
  #config.vm.box = 'geerlingguy/centos7'
  #config.vm.box = 'geerlingguy/ubuntu1604'
  #config.vm.box = 'laravel/homestead'
  #config.vm.box = 'puphpet/debian75-x64'
    
```

Additional examples, commands, and usage details can be found in the VMware ESXi plugin repository:

https://github.com/josenk/vagrant-vmware-esxi

---

# Current Challenges / Work In Progress

The following items are still being investigated and improved:

### 1. VM Cloning from Existing Datastore Templates

Automating the creation of multiple VMs from existing VMware datastore templates.

### 2. Ubuntu 22 Networking Issues

Occasional networking and hostname-management plugin issues have been observed on Ubuntu 22.

Current status:

* Rocky Linux works reliably.
* Ubuntu 22 requires additional troubleshooting.

### 3. Rocky 9 Update Issues

Some package updates and dependency-related issues still occur during provisioning and require further refinement.

### 4. nfs server

The NFS server is not working and is causing issues, even though the service is up.


# useful commands
```bash
vagrant up     # Create and start a VM.
vagrant halt    # Gracefully stop a VM.
vagrant reload # Restart a VM.
vagrant destroy -f   # Delete a VM.
vagrant status  # Check VM status. 
vagrant ssh #SSH into a VM.


## Provisioning
vagrant provision    #Run provisioning scripts again.
vagrant reload --provision    #Restart and reprovision.
vagrant up --provision      #Start VM and run provisioning.
```


Contributions, suggestions, and improvements are always welcome.
