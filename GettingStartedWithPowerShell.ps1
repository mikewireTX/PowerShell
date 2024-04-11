﻿#######################################################
#       Getting Started with PowerCLI 
#######################################################
# Author(s):  Mike Ross  
# Github:  https://github.com/mikewireTX
# Web: https://mikewire.com/
#######################################################
#
#
# Install PowerCLI
Install-Module VMware.PowerCLI
# Run this for Powershell ISE integration - install NuGet when prompted 
# Find-Module -Name VMware.PowerCLI
Install-Module -Name VMware.PowerCLI
# Set the executin policy and limit scope to CurrentUser (you)
Set-ExecutionPolicy Bypass -Scope CurrentUser
# Set the CEIP to false
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false
# Connect to vCenter/ESXi
Connect-VIServer -Server mr-vcsa.mr.pvt
# Disconnect from the single server
Disconnect-VIServer -Server mr-vcsa.mr.pvt
# Disconnect from ALL vCenter/ESXi (force all active connections to disconnect)
Disconnect-VIServer -Force

Get-vm | get-member

Get-VM | Select-Object -Property Name, VMHost, Guest, @{n='Cluster'; e={$_.VMHost.Parent}}

Get-VM  -RelatedObject

#https://communities.vmware.com/t5/VMware-PowerCLI-Discussions/Powershell-script-to-list-VMs-with-attached-iso/td-p/2921738
#Referenced URL and script by LucD

@{n='Cluster'; e={$_.VMHost.Parent}}
#######
#######
Get-Cluster -PipelineVariable clustername | Get-VMHost | Get-VM | Where-Object {$_.PowerState –eq “PoweredOn”} | Get-CDDrive | Where-Object {$_.IsoPath -ne $null} | Select-Object -Property @{N='vCenter'; E={([uri]($_.Parent.ExtensionData.Client.ServiceUrl)).Host}}, @{N=’Cluster’;E={$clustername.Name}}, @{N='VM'; E={$_.Parent.Name }}, @{N='ISO'; E={$_.IsoPath}} | Format-Table
#######
#@{N=’Cluster’;E={$_.VM.VMHost.Parent.Name}}
#@{N = 'Power State'; E = {$_.PowerState}}
#@{N = 'Cluster'; E = {Get-Cluster -VM $_}}

Get-Cluster PROD01 | Get-VMHost | Get-VM | Where-Object {$_.PowerState –eq “PoweredOn”} | Get-CDDrive | FT Parent, IsoPath, @{N = 'vCenter'; E = {([uri]($_.Parent.ExtensionData.Client.ServiceUrl)).Host}}


#Unmount/disconnect ISO's from VM's with them attached by cluster
Get-Cluster -Name PROD01 | Get-VM | Get-CDDrive | where {$_.IsoPath -ne $null} | Set-CDDrive -NoMedia -Confirm:$False

Get-Cluster | Where-Object {$_.Name -eq "PROD01"} | Get-VM | Get-CDDrive | where {$_.IsoPath -ne $null} | Set-CDDrive -NoMedia -Confirm:$False

get-vm | Get-Annotation -CustomAttribute “attribute” | Where-Object { $_.Value -eq “UAT” }

get-VM | where { $_ | get-cddrive | where { $_.ConnectionState.Connected -eq “true” } } | select Name

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Get-VM | Select Name, @{N="Cluster";E={Get-Cluster -VM $_}},

    @{N= "ESX Host";E={Get-VMHost -VM $_}}

    Where-Object { $_.IsoPath -ne $null } | 
    Select-Object @{N = 'Cluster'; E = {Get-Cluster -VM $_}},  
    @{N = 'VM'; E = {$_.Parent.Name }}, IsoPath, 
    @{N = 'vCenter'; E = { ([uri]($_.Parent.ExtensionData.Client.ServiceUrl)).Host } }



    Get-VM | Select Name, @{N="Cluster";E={Get-Cluster -VM $_}}



Get-Cluster| Get-VM | Get-Snapshot |

Where-Object {$_. Created -lt (Get-Date). AddDays(-7)} | 

Select-Object -Property @{Name=’Cluster’;Expression={$_.VM.VMHost.Parent.Name}},

    VM, Name,

    @{N="Size";E={"{0:N2} GB" -f ($_.SizeGB)}},

    @{N='Days Old';E={[math]::Round((New-TimeSpan -Start $_.Created -End (Get-Date)).TotalDays,0)}} |

Format-Table  


    Get-VM | Select Name, @{N='Cluster';E={(Get-Cluster -VM $_).Name}}

    Get-Cluster

    Get-Datacenter -Cluster 'PROD01'