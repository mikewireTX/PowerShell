#
#
#
# Connect to vCenter
$creds = Get-Credential
# Put your vCenter name here
$server = "mr-vcsa.mr.pvt"
Connect-VIServer -Server $server -Credential $creds -Force
#
#
#
# 
Get-Cluster -PipelineVariable clustername | Get-VMHost | Get-VM | Where-Object {$_.PowerState –eq “PoweredOn”} | Get-CDDrive | 
Where-Object {$_.IsoPath -ne $null} | Select-Object -Property @{N='vCenter'; E={([uri]($_.Parent.ExtensionData.Client.ServiceUrl)).Host}}, @{N=’Cluster’;E={$clustername.Name}}, @{N='VM'; E={$_.Parent.Name }}, @{N='ISO'; E={$_.IsoPath}} | 
Format-Table
#
#
#
#
#