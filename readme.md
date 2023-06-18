> #Here are instructions to create your first ansible playbook
>
>  #You need 3 VMs, preferably created with PowerShell or Terraform or ARM.
> 
> #The file deployment.ps1 contains the powershell script to deploy the entire setup within 2 minutes
---
# Repository contents
readme.md = this file. read the below before jumping in.

Instructions.txt = # START HERE. This contains the full instruction set.

deployment.ps1 = Powershell Script to deploy the desired environment in Azure. You can use Cloud shell for ease. Please remember to set-Azcontext before you start running commands.

installTerraformCentOS.sh = Bash shell script to install terraform on a CentOS image virtual machine.

installtfubuntu.sh = Bash shell script to install terraform on a Ubuntu/Debian image virtual machine.

inventory.hosts = Inventory file for Ansible. Contains details of all hosts and groups.

main.yaml = Ansible playbook file.
