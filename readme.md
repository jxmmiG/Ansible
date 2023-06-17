> #Here are instructions to create your first ansible playbook
>
>  #You need 3 VMs, preferably created with PowerShell or Terraform or ARM.
> 
> #I created mine in the portal and I'll work on getting that scripted tomorrow#Once the VMs are created using centOS this time, we'll install ansible on the master node
> 
> #for Ubuntu

sudo apt update

sudo apt install ansible

> #For centOS you have to add the epel-release repo first then install ansible

sudo yum install epel-release

sudo yum install ansible


> #next we use ssh keys to make life easier for everyone, especially ansible itself
> 
> #first generate keypairs

cd ~

ssh-keygen

> #then copy the generated keys to the remote nodes

ssh-copy-id -i id_rsa.pub 192.168.25.5

ssh-copy-id -i id_rsa.pub 192.168.25.6

>#to keep things organised I put all my files in a file called ansiblefiles in my home directory

mkdir ansiblefiles

---

># Create an ansible inventory file

cd ~

cd /ansible

touch inventory.hosts

> #The inventory file can look something like this. there are about 400 ways to write this file so don't be married to any style

node1 ansible_host=192.168.25.5 ansuble_user=jxmmi

node2 ansible_host=192.168.25.6 ansible_user=jxmmi

node7 ansible_host=192.168.25.7 ansuble_user=jxmmi

node8 ansible_host=192.168.25.8 ansible_user=jxmmi

[stage]

node1

node2

[prod]

node7

node8

>#Test connectivity to all my hosts

ansible all -i ansiblefiles/inventory.hosts -m ping

> #Now we want to create an ansible playbook to run a shell script that installs terraform on our target machines 
>
> #this would be super valuable if we had a large number of target servers and don't want to have to configure them one after the other

nano installtfubuntu.sh

> #contents of the file
---
#!/bin/bash

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \

gpg --dearmor | \

sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \

https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \

sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

sudo apt-get install terraform

---

> #next we change the permissions of the file to make it executable

chmod +x installtfubuntu.sh

> #now that we have a good running script, we can push the config to the other nodes using a terraform playbook

nano main.yaml

> #file contents are the actual yaml script for ansible

- name: 'Playbook to Install Terraform on Target Nodes'

  hosts: stage

  become: yes
  
  tasks:
    
    - name: Copy terraform install script to remote server
      
      copy:
        
        src: installtfubuntu.sh
        
        dest: /tmp/install_terraform.sh
        
        owner: jxmmi
        
        group: jxmmi
        
        mode: ugo+x

    
    - name: Run a shell command
      
      shell: /tmp/install_terraform.sh

---

> #then we run the yaml file using 

ansible-playbook -i inventory.hosts main.yaml -v

> #that does the job. Congratulations you have your first yaml file!
