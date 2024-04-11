﻿#######################################################
#       Getting Started with PowerCLI 
#######################################################
# Author(s):  Mike Ross  
# Github:  https://github.com/mikewireTX
# Web: https://mikewire.com/
#######################################################
# Below is a small collection of cmdlets to get started
# using PowerCLI - use at your own risk!
#
# Use this cmdlet to install PowerCLI
Install-Module VMware.PowerCLI
#
# Set the executin policy and limit scope to CurrentUser (you)
Set-ExecutionPolicy Bypass -Scope CurrentUser
#
# Set the CEIP to false
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false
#
# Connect to vCenter - sub in your hostname below
Connect-VIServer -Server <yourserver>
# Disconnect from the single server- sub in your hostname below
#
Disconnect-VIServer -Server <yourserver>
# Disconnect from ALL vCenter server(s) - force all active connections to disconnect
Disconnect-VIServer -Force
#
# End
#######################################################