﻿#This script deploys the follwing resources
#Resource Group
#1 VNET with 1 subnet
#subnet level NSG
#3 VMs & NICs
#LB Public IP
#LB STandard
#For week 2, we added a Load Balancing rule on port 80 to load balance tobi's portfolio which we've downloaded.

#CORE VARIABLE DECLARATION 
#Please set your VM name and password below before modifying any other variables. Also set your preferred website dns label

$VMAdminUsername = "jxmmi"
$VMAdminPassword = "Password@123"
$dnsprefix = "misterjxmmi"


$SecurePassword = ConvertTo-SecureString $VMAdminPassword -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($VMAdminUsername, $SecurePassword); 

$region = 'uksouth'
$RGname = 'AnsibleRGjune'
$vnetname = 'AnsibleVNET'
$vnetaddress = '192.168.30.0/24'
$subnetname = 'subnetA'
$subnetaddress = '192.168.30.0/27'
$nsgName = 'NSG-Subnet'
$VMName = "controller"
$VMName2 = "node1"
$VMName3 = "node2"
$NICName = 'controller-NIC'
$NICName2 = 'node1-NIC'
$NICName3 = 'node2-NIC'

$LBpublicIPName = 'lb-PIP'
$LBpublicIP2Name = 'lb-PIP-Outbound'
$lbName = 'ansibleLB'

$publisherName = "eurolinuxspzoo1620639373013"
$productName = "centos-8-5-free"
$planName = "centos-8-5-free"
$osOffer = 'centos-8-5-free'
$osSKU = 'centos-8-5-free'

#this script is designed to be reusable, and so you should only have to change the variables above.
#if you have to switch to a Windows VM, then change the AzvmOperatingSystem property to -Windows

#First, the script will create Resource group, subnet and VNET with NSG applied to the subnet
New-AzResourceGroup -Name $RGname -Location $region

$subnet = New-AzVirtualNetworkSubnetConfig -Name $subnetname -AddressPrefix $subnetaddress
New-AzVirtualNetwork -Name $vnetname -ResourceGroupName $RGname -Location $region -AddressPrefix $vnetaddress -Subnet $subnet
$vnet = Get-AzVirtualNetwork -Name $vnetname -ResourceGroupName $RGname

$rule1 = New-AzNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP" `
    -Access Allow -Protocol * -Direction Inbound -Priority 500 -SourceAddressPrefix `
    Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80

$rule2 = New-AzNetworkSecurityRuleConfig -Name ssh-rule -Description "Allow SSH" `
    -Access Allow -Protocol * -Direction Inbound -Priority 510 -SourceAddressPrefix `
    Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22

$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $RGname -Location $region -Name "NSG-Subnet" -SecurityRules $rule1,$rule2
Set-AzVirtualNetworkSubnetConfig -Name $subnetname -VirtualNetwork $vnet -AddressPrefix $subnetaddress -NetworkSecurityGroupId $nsg.Id
$vnet | Set-AzVirtualNetwork

#now we can create the virtual machines
$NIC = New-AzNetworkInterface -Name $NICName -ResourceGroupName $RGname -Location $region -SubnetId $vnet.Subnets[0].Id
$NIC = Get-AzNetworkInterface -Name $NICName -ResourceGroupName $RGname
$VMconfig = New-AzVMConfig -VMName $VMName -VMSize Standard_B1ms
$VMconfig = Set-AzVMOperatingSystem -VM $VMconfig -Linux -ComputerName $VMName -Credential $credential
$VMconfig = Add-AzVMNetworkInterface -VM $VMconfig -Id $NIC.Id
$VMconfig = Set-AzVMSourceImage -VM $VMconfig -PublisherName $publisherName -Offer $osOffer -Skus $osSKU -Version 'latest'
$VMconfig = Set-AzVMPlan -VM $VMconfig -Publisher $publisherName -Product $productName -Name $planName

New-AzVM -ResourceGroupName $RGname -Location $region -VM $VMconfig -Verbose	


#for VM2 which uses VMName2 and NIC2
$NIC2 = New-AzNetworkInterface -Name $NICName2 -ResourceGroupName $RGname -Location $region -SubnetId $vnet.Subnets[0].Id
$NIC2 = Get-AzNetworkInterface -Name $NICName2 -ResourceGroupName $RGname
$VMconfig2 = New-AzVMConfig -VMName $VMName2 -VMSize Standard_B1ms
$VMconfig2 = Set-AzVMOperatingSystem -VM $VMconfig2 -Linux -ComputerName $VMName2 -Credential $credential
$VMconfig2 = Add-AzVMNetworkInterface -VM $VMconfig2 -Id $NIC2.Id
$VMconfig2 = Set-AzVMSourceImage -VM $VMconfig2 -PublisherName $publisherName -Offer $osOffer -Skus $osSKU -Version 'latest'
$VMconfig2 = Set-AzVMPlan -VM $VMconfig2 -Publisher $publisherName -Product $productName -Name $planName

New-AzVM -ResourceGroupName $RGname -Location $region -VM $VMconfig2 -Verbose	


#and finallyVM3 which uses VMName3 and NIC3
$NIC3 = New-AzNetworkInterface -Name $NICName3 -ResourceGroupName $RGname -Location $region -SubnetId $vnet.Subnets[0].Id
$NIC3 = Get-AzNetworkInterface -Name $NICName3 -ResourceGroupName $RGname
$VMconfig3 = New-AzVMConfig -VMName $VMName3 -VMSize Standard_B1ms
$VMconfig3 = Set-AzVMOperatingSystem -VM $VMconfig3 -Linux -ComputerName $VMName3 -Credential $credential
$VMconfig3 = Add-AzVMNetworkInterface -VM $VMconfig3 -Id $NIC3.Id
$VMconfig3 = Set-AzVMSourceImage -VM $VMconfig3 -PublisherName $publisherName -Offer $osOffer -Skus $osSKU -Version 'latest'
$VMconfig3 = Set-AzVMPlan -VM $VMconfig3 -Publisher $publisherName -Product $productName -Name $planName

New-AzVM -ResourceGroupName $RGname -Location $region -VM $VMconfig3 -Verbose


#Our VMs are done. Now we create the Public IP first and then the LB
$lbPIP = New-AzPublicIpAddress -ResourceGroupName $RGname -Name $LBpublicIPName -Location $region -AllocationMethod "Static" -Sku Standard -DomainNameLabel $dnsprefix
$lbPIP2 = New-AzPublicIpAddress -ResourceGroupName $RGname -Name $LBpublicIP2Name -Location $region -AllocationMethod "Static" -Sku Standard

$lbFIP = New-AzLoadBalancerFrontendIpConfig -Name 'InboundFrontEnd' -PublicIpAddress $lbPIP
$lbFIP2 = New-AzLoadBalancerFrontendIpConfig -Name 'OutboundFrontEnd' -PublicIpAddress $lbPIP2
$lbBEP = New-AzLoadBalancerBackendAddressPoolConfig -Name "LB-BEP"
$lbBEP2 = New-AzLoadBalancerBackendAddressPoolConfig -Name "LB-BEPweb"
$LBprobe = New-AzLoadBalancerProbeConfig -Name "LBprobe" -Protocol "tcp" -Port 80 -IntervalInSeconds 15 -ProbeCount 2 -ProbeThreshold 2
$lbNATrule = New-AzLoadBalancerInboundNatRuleConfig -Name "rdp-master" -FrontendIPConfiguration $lbFIP -Protocol "Tcp" -FrontendPort 8050 -BackendPort 22 -IdleTimeoutInMinutes 4
$lbOutboundRule = New-AzLoadBalancerOutboundRuleConfig -Name "outbound" -Protocol "All" -FrontendIPConfiguration $lbFIP -BackendAddressPool $lbBEP
$lbOutboundRule2 = New-AzLoadBalancerOutboundRuleConfig -Name "outboundnodes" -Protocol "All" -FrontendIPConfiguration $lbFIP2 -BackendAddressPool $lbBEP2

$lbrule = New-AzLoadBalancerRuleConfig -Name "LBRule80" -FrontendIpConfiguration $lbFIP -BackendAddressPool $lbBEP2 -Probe $LBprobe -Protocol "Tcp" -FrontendPort 80 -BackendPort 80 -IdleTimeoutInMinutes 4 -LoadDistribution Default -DisableOutboundSNAT 

#the backend pool and NAT rule above were created without backend target NIC or IPs. We'll add that later
$lb = New-AzLoadBalancer -Name $lbName -ResourceGroupName $RGname -Location $region -FrontendIpConfiguration $lbFIP,$lbFIP2 -BackendAddressPool $lbBEP,$lbBEP2 -Probe $LBprobe -InboundNatRule $lbNATrule -OutboundRule $lbOutboundRule,$lbOutboundRule2 -LoadBalancingRule $lbrule
$lb = Get-AzLoadBalancer -Name $lbName -ResourceGroupName $RGname

#Now, how to add a NIC to Load Balancer backend pool or NatRule is tricky but we can achieve it with the script below
$NIC.IpConfigurations[0].LoadBalancerBackendAddressPools.Add($lb.BackendAddressPools[0]);
$NIC2.IpConfigurations[0].LoadBalancerBackendAddressPools.Add($lb.BackendAddressPools[1]);
$NIC3.IpConfigurations[0].LoadBalancerBackendAddressPools.Add($lb.BackendAddressPools[1]);
$NIC.IpConfigurations[0].LoadBalancerInboundNatRules.Add($lb.InboundNatRules[0]);

$lb = $lb | Set-AzLoadBalancer
$NIC | Set-AzNetworkInterface
$NIC2 | Set-AzNetworkInterface
$NIC3 | Set-AzNetworkInterface
