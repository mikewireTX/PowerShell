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
function ConnectvCenter {
# Gather creds to connect to vCenter
$creds = Get-Credential
# Specify the vCenter Server to connect to
$vcenter = Read-Host 'Input the vCenter server FQDN or IP to connect to'
if (Connect-VIServer -Server $vcenter -Credential $creds -ErrorAction SilentlyContinue) {Write-Output 'Connected to '$vcenter'!'} 
    else {$Error[0] }
} #end function


function ScanCluster-YesNoPrompt {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory)][string]$Prompt,
        [switch]$DefaultYes
    )

    if ($DefaultYes.IsPresent) {
        $Prompt = $Prompt + " (Y/n)"
    } else {
        $Prompt = $Prompt + " (y/N)"
    }
    
    while ($true) {
        $Answer = Read-Host -Prompt $Prompt
        switch ($Answer) {
            'y' {
                return $true              
            }
            'n' {
                return $false
                
                End
                
                 
            }
            '' {
                if ($DefaultYes.IsPresent) {
                    return $true
                } else {
                    return $false
                }
            }
            Default {
                Write-Host " Invalid input. Try again."
            }
        } # end switch
    } # end while
} # end function


if ( ConnectvCenter ) {

    $cluster = Read-Host 'Input the cluster name'

    if ( ScanCluster-YesNoPrompt -Prompt "Do you want to scan the cluster '$cluster'?" ) {
               
                Get-Cluster -PipelineVariable clustername | Where-Object {$_.Name -eq $cluster } | Get-VMHost | Get-VM | Where-Object {$_.PowerState –eq “PoweredOn”} | Get-CDDrive | 
                Where-Object {$_.IsoPath -ne $null} | Select-Object -Property @{N='vCenter'; E={([uri]($_.Parent.ExtensionData.Client.ServiceUrl)).Host}}, @{N=’Cluster’;E={$clustername.Name}}, @{N='VM'; E={$_.Parent.Name }}, @{N='ISO'; E={$_.IsoPath}} | 
                Format-Table
                
                }

         else { write-host $Error }

    if ( ScanCluster-YesNoPrompt -Prompt "Do you want to detach the ISO's from cluster '$cluster'?" ) { 

                Get-Cluster -Name $cluster | Get-VM | Get-CDDrive | where {$_.IsoPath -ne $null} | Set-CDDrive -NoMedia -Confirm:$False

        }

        else { write-host $Error }

  
}


else { write-host $Error }
#
#
#
