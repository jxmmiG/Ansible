ReadMe file for our week 2 upload

> #This folder contains the files for our week 2 deplouments.
>
> #The aim of this project is to set up a running portfolio website. I have modified the website files and they are in the samplePortfolio directory. Feel free to download, fork or clone them and make them to your taste.
>
> #The deployment includes an ansible controller and 2 nodes running the website in apache. We use a Load Balancer to publish the website publicly.
> 
> #The file deployment2.ps1 contains the powershell script to deploy the entire setup within minutes.
---
# Repository contents
readme.md = this file. read the below before jumping in.

Week2nstructions.txt = # START HERE. This contains the full instruction set.

deployment2.ps1 = Powershell Script to deploy the desired environment in Azure. You can use Cloud shell for ease. Please remember to set-Azcontext before you start running commands.

inventory.hosts = Inventory file for Ansible. Contains details of all hosts and groups.

playbookweek2.yaml = Ansible playbook file.
