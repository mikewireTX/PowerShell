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
# Check if PowerCLi is already installed (this is the depricated version)
Get-PowerCLIVersion
# 
# This is a better cmdlet to run and is not deprecated
Get-Module -Name VMware.* | Select-Object -Property Name,Version
#
# Use this cmdlet to install PowerCLI:
Install-Module VMware.PowerCLI -Scope CurrentUser
#
# Set the execution policy to bypass and limit scope to CurrentUser (you):
Set-ExecutionPolicy Bypass -Scope CurrentUser
#
# Or set CEIP (Customer Experience Improvement Program) to true:
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $true
#
# Set the CEIP to false:
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false
#
# Uninstall PowerCLI Main module
Get-Module VMware.PowerCLI -ListAvailable | Uninstall-Module -Force
#
# Uninstall PowerCLI VMware modules except for the main PowerCLI module
(Get-Module VMware.PowerCLI -ListAvailable).RequiredModules | Uninstall-Module -Force
#
# Connect to vCenter - sub in your hostname below:
Connect-VIServer -Server <yourserver>#
#
# Check what VIServer you are connected to:
$global:defaultviserver
#
# Update PowerCLI:
Update-Module -Name VMware.PowerCLI
#
# Disconnect from the single server- sub in your hostname below
Disconnect-VIServer -Server <yourserver>
#
# Disconnect from ALL vCenter server(s) - force all active connections to disconnect
Disconnect-VIServer -Force
#
# End
#######################################################