function Get-RegistryValue($key, $value) {
    (Get-ItemProperty $key $value -ErrorAction SilentlyContinue).$value
}

function Exec
{
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=1)][scriptblock]$cmd,
        [Parameter(Position=1,Mandatory=0)][string]$errorMessage = ($msgs.error_bad_command -f $cmd)
    )
    & $cmd

    Write-Host ($cmd)

    if ($lastexitcode -ne 0) {
        throw ("Exec: " + $errorMessage)
    }
}

$AdvancedInstallerPath = Get-RegistryValue "HKLM:\SOFTWARE\Wow6432Node\Caphyon\Advanced Installer\" "Advanced Installer Path" 

$script:AdvinstCLI = $AdvancedInstallerPath + "bin\x86\AdvancedInstaller.com"

$archive = "Particular.NServiceBus-4" # "Particular.NServiceBus-%GitFlowVersion.Version%" 

$stability = "alfa" #%GitFlowVersion.Stability%

$preReleaseNameValue = "-alfa408" # "-%GitFlowVersion.Stability%%GitFlowVersion.PreReleaseNumber%"

if($stability -eq "Final") 
{
   $preReleaseName = ""
} 
else 
{
   $preReleaseName = $preReleaseNameValue
}

$versionValue = "4.1.0.1" #"%GitFlowVersion.Major%.%GitFlowVersion.Minor%.%GitFlowVersion.Patch%"

$baseDir = Split-Path (Resolve-Path $MyInvocation.MyCommand.Path)

$setupProjectFile = "$baseDir\src\NServiceBus\NServiceBus.aip"

$outputDir = "$baseDir\src\NServiceBus\Output Package"


# edit Advanced Installer Project   
exec { &$script:AdvinstCLI /edit $setupProjectFile /SetVersion "$versionValue" -noprodcode } 

exec { &$script:AdvinstCLI /edit $setupProjectFile /SetPackageName "$archive.exe" -buildname DefaultBuild }

exec { &$script:AdvinstCLI /edit $setupProjectFile /SetOutputLocation -buildname DefaultBuild -path "$outputDir" }

exec { &$script:AdvinstCLI /edit $setupProjectFile /SetProperty OPT_PRERELEASE_NAME="$preReleaseName" }
    
# Build setup with Advanced Installer 
exec { &$script:AdvinstCLI /rebuild $setupProjectFile }