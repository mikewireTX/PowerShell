﻿#######################################################
#       Get Iso's attached to VM's in vCenter Report
#######################################################
# Author(s):  Mike Ross  
# Github:  https://github.com/mikewireTX
# Web: https://mikewire.com/
#######################################################
#
# Connect to vCenter
$creds = Get-Credential
# Put your vCenter name here
$server = "mr-vcsa.mr.pvt"
Connect-VIServer -Server $server -Credential $creds -Force
#########################
#########################
# Get a list of VM's with ISO's attached and list vCenter, Cluster, VM name and ISO
Get-Cluster -PipelineVariable clustername | Get-VMHost | Get-VM | Where-Object {$_.PowerState –eq “PoweredOn”} | Get-CDDrive | 
Where-Object {$_.IsoPath -ne $null} | Select-Object -Property @{N='vCenter'; E={([uri]($_.Parent.ExtensionData.Client.ServiceUrl)).Host}}, @{N=’Cluster’;E={$clustername.Name}}, @{N='VM'; E={$_.Parent.Name }}, @{N='ISO'; E={$_.IsoPath}} | 
Format-Table
# Disconnect from VIServer
Disconnect-VIServer -Server $server
# End
#######################################################