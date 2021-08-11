<powershell>

Write-Output "------------------------------------"
Write-Output "Install latest SSM Agent"
Write-Output "------------------------------------"
Invoke-WebRequest https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe -OutFile $env:USERPROFILE\Desktop\SSMAgent_latest.exe
Start-Process -FilePath $env:USERPROFILE\Desktop\SSMAgent_latest.exe -ArgumentList "/S"

# Set timezone
tzutil /s 'GMT Standard Time'

# Run all scripts that apply runtime config
cd c:\setup\RunTimeConfig
# .\InstallAWSCLI.ps1 - Baked into AMI
.\SetInstanceRegistryKeys.ps1
.\SetRDSEndpointRegistryKeys.ps1
.\RemoveAWSCLI.ps1
.\InstallKarmaApp.ps1
.\KarmaAppConfigure.ps1



####### OLD ###################
#Import-Module Carbon
#$adminUser = (Get-SSMParameterValue -Name ${user_ssm_path}).Parameters.Value
#$adminPassword = (Get-SSMParameterValue -Name ${password_ssm_path} -WithDecryption $true).Parameters.Value
#$adminCreds = New-Credential -UserName "$adminUser" -Password "$adminPassword"
#Install-User -Credential $adminCreds
#Add-GroupMember -Name Administrators -Member $adminUser

# Resize system drive if overridden from ami value
#$MaxSize = (Get-PartitionSupportedSize -DriveLetter C).sizeMax
#Resize-Partition -DriveLetter C -Size $MaxSize


</powershell>
<persist>true</persist>