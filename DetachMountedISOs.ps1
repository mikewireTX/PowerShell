#######################################################
#       Detach Mounted ISO's 
#######################################################
# Author(s):  Mike Ross  
# Github:  https://github.com/mikewireTX
# Web: https://mikewire.com/
#######################################################
# Below is a script to detach ISO's mounted to VM's
# using PowerCLI - use at your own risk!
#
# # Connect to vCenter
$creds = Get-Credential
# Put your vCenter name here
$server = Read-Host 'Input the vCenter server FQDN or IP'
Connect-VIServer -Server $server -Credential $creds -Force
#########################
#Cluster Name
$clustername = Read-Host 'Input the cluster name'

# Get a list of VM's with ISO's attached and list vCenter, Cluster, VM name and ISO
Get-Cluster -PipelineVariable clustername | Get-VMHost | Get-VM | Where-Object {$_.PowerState –eq “PoweredOn”} | Get-CDDrive | 
Where-Object {$_.IsoPath -ne $null} | Select-Object -Property @{N='vCenter'; E={([uri]($_.Parent.ExtensionData.Client.ServiceUrl)).Host}}, @{N=’Cluster’;E={$clustername.Name}}, @{N='VM'; E={$_.Parent.Name }}, @{N='ISO'; E={$_.IsoPath}} | 
Format-Table


#This will detach the ISO's per cluster name
#Get-Cluster -Name $cluster | Get-VM | Get-CDDrive | where {$_.IsoPath -ne $null} | Set-CDDrive -NoMedia -Confirm:$False
