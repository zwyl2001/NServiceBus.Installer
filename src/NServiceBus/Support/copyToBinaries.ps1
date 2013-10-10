

cls
$packagesFolder = Resolve-Path '..\..\packages'

$binariesFolder = Resolve-Path '..\..\Release\binaries'

$IncludeFileList = "*.exe","*.pdb","*.xml","*.dll"

$ExcluedFileList = "*Apache.*","Microsoft.*", "Ionic.*"

$ExcludeSubDirectory = "$packagesFolder\Fody", "$packagesFolder\GitFlowVersion.Fody", "$packagesFolder\GitFlowVersionTask", "$packagesFolder\log4net", "$packagesFolder\NServiceBus.Host32", "$packagesFolder\NServiceBus.Autofac", "$packagesFolder\NServiceBus.Autofac", "$packagesFolder\NServiceBus.Ninject", "$packagesFolder\NServiceBus.Spring", "$packagesFolder\NServiceBus.StructureMap", "$packagesFolder\NServiceBus.Unity", "$packagesFolder\NServiceBus.Tools"


$files = Get-ChildItem $packagesFolder -Recurse -Include $IncludeFileList -Exclude $ExcluedFileList

foreach ($file in $files)
{
$copy = 1

    foreach($dir in $ExcludeSubDirectory.Split())
    {
        if ($file.DirectoryName.StartsWith($dir, [StringComparison]::InvariantCultureIgnoreCase ))
        {
            $copy = 0
        }
    }

    if($copy -eq 1)
    {
        Write-Host("copying:$file to $binariesFolder")

        Copy-Item $file -Destination $binariesFolder
    }
}

#log4net

$log4NetDit = "$packagesFolder\log4net\lib\net40-full\*"

Copy-Item $log4NetDit -Destination $binariesFolder

#NServiceBus.Host32.exe
Get-ChildItem "$packagesFolder\NServiceBus.Host32\lib\net40\" -Recurse | % { Copy-Item $_.FullName -Destination "$binariesFolder\$($_.BaseName + '32' + $_.Extension)"}

#Tools
Copy-item "$packagesFolder\NServiceBus.Tools\*" -Destination "$binariesFolder\Tools\"-Include $IncludeFileList -Force 

Copy-item "$packagesFolder\NServiceBus.Tools\LicenseInstaller\*" -Destination "$binariesFolder\Tools\LicenseInstaller\" -Include $IncludeFileList -Force
