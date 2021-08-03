<powershell>

Write-Output "------------------------------------"
Write-Output "Install latest SSM Agent"
Write-Output "------------------------------------"
Invoke-WebRequest https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe -OutFile $env:USERPROFILE\Desktop\SSMAgent_latest.exe
Start-Process -FilePath $env:USERPROFILE\Desktop\SSMAgent_latest.exe -ArgumentList "/S"

Write-Output "------------------------------------"
Write-Output "Install IIS Webserver, .NET Framework 4.5"
Write-Output "------------------------------------"
Install-WindowsFeature -name Web-Server -IncludeManagementTools
Install-WindowsFeature Net-Framework-45-Features
Get-WindowsFeature | Where { $_.InstallState -eq "Installed" } | Format-Table 

#Import-Module Carbon 

#$adminUser = (Get-SSMParameterValue -Name ${user_ssm_path}).Parameters.Value
#$adminPassword = (Get-SSMParameterValue -Name ${password_ssm_path} -WithDecryption $true).Parameters.Value

#$adminCreds = New-Credential -UserName "$adminUser" -Password "$adminPassword"
#Install-User -Credential $adminCreds

#Add-GroupMember -Name Administrators -Member $adminUser

# Resize system drive if overridden from ami value
#$MaxSize = (Get-PartitionSupportedSize -DriveLetter C).sizeMax
#Resize-Partition -DriveLetter C -Size $MaxSize

# Set timezone
tzutil /s 'GMT Standard Time'

# Run all scripts that apply runtime config
$runtimeconfig = 'C:\Setup\RunTimeConfig'
    Foreach-Object {
Get-ChildItem $runtimeconfig -Filter *.ps1 |
        & $runtimeconfig\$_
    }

</powershell>
<persist>true</persist>