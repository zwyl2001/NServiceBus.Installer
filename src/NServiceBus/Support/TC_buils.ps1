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

$archive = "Particular.NServiceBus-4.4" 

$stability = "Final"

$preReleaseNameValue = "-Final00"

if($stability -eq "Final") 
{
   $preReleaseName = ""
} 
else 
{
   $preReleaseName = $preReleaseNameValue
}

$versionValue = "4.4.0"

$baseDir = "."

$setupProjectFile = "C:\Projects\NServiceBus.Installer\src\NServiceBus\NServiceBus.aip"

$outputDir = "C:\Projects\NServiceBus.Installer\src\NServiceBus\Output Package"


# edit Advanced Installer Project   
exec { &$script:AdvinstCLI /edit $setupProjectFile /SetVersion "$versionValue" -noprodcode } 

exec { &$script:AdvinstCLI /edit $setupProjectFile /SetPackageName "$archive.exe" -buildname DefaultBuild }

exec { &$script:AdvinstCLI /edit $setupProjectFile /SetOutputLocation -buildname DefaultBuild -path "$outputDir" }

exec { &$script:AdvinstCLI /edit $setupProjectFile /SetProperty OPT_PRERELEASE_NAME="$preReleaseName" }

exec { &$script:AdvinstCLI /edit $setupProjectFile /SetProperty MY_VERSION="4.4" }
    
# Build setup with Advanced Installer 
exec { &$script:AdvinstCLI /rebuild $setupProjectFile }