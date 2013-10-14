# cls

$packagesFolder = Resolve-Path '..\..\packages'

$binariesFolder = Resolve-Path '..\..\Release\binaries'

$toolsFolder = Resolve-Path '..\..\Release\Tools'

$includeFileList = "*.exe","*.pdb","*.xml","*.dll", "*.config"

$excluedFileList = "*Apache.*","Microsoft.*", "Ionic.*", "Dummy.md"

$excludeSubDirectory = "$packagesFolder\Fody", "$packagesFolder\GitFlowVersion.Fody", "$packagesFolder\GitFlowVersionTask", "$packagesFolder\log4net", "$packagesFolder\NServiceBus.Host32", "$packagesFolder\NServiceBus.Autofac", "$packagesFolder\NServiceBus.CastleWindsor", "$packagesFolder\NServiceBus.Ninject", "$packagesFolder\NServiceBus.Spring", "$packagesFolder\NServiceBus.StructureMap", "$packagesFolder\NServiceBus.Unity", "$packagesFolder\NServiceBus.Tools", "$packagesFolder\Particular.CustomActions"

Write-Host("Copying binaries and tools...")

$files = Get-ChildItem $packagesFolder -Recurse -Include $includeFileList -Exclude $excluedFileList

foreach ($file in $files)
{
$copy = 1

    foreach($dir in $excludeSubDirectory.Split())
    {
        if ($file.DirectoryName.StartsWith($dir, [StringComparison]::InvariantCultureIgnoreCase ))
        {
            $copy = 0
        }
    }

    if($copy -eq 1)
    {
        Write-Host("Copying:$file to $binariesFolder")

        Copy-Item $file -Destination $binariesFolder
    }
}

#containers

$includeSubDirectory = "$packagesFolder\NServiceBus.Autofac", "$packagesFolder\NServiceBus.CastleWindsor", "$packagesFolder\NServiceBus.Ninject", "$packagesFolder\NServiceBus.Spring", "$packagesFolder\NServiceBus.StructureMap", "$packagesFolder\NServiceBus.Unity"
 
Write-Host("Copying containers...")

foreach($container in $includeSubDirectory.Split())
{
    $containerDirName = Split-Path($container) -Leaf

    Write-Host("Copying:$container\lib\net40\ to $binariesFolder\containers\$containerDirName\")

    if(!(Test-Path "$binariesFolder\containers\$containerDirName\")){ md "$binariesFolder\containers\$containerDirName\";}

    Copy-Item "$container\lib\net40\*" -Recurse -Destination "$binariesFolder\containers\$containerDirName\" -Force
}

#log4net

$log4NetDit = "$packagesFolder\log4net\lib\net40-full\*"

Copy-Item $log4NetDit -Destination $binariesFolder

#NServiceBus.Host32.exe

if(!(Test-Path $binariesFolder\NServiceBus.Host32)){ md $binariesFolder\NServiceBus.Host32;}

Get-ChildItem "$packagesFolder\NServiceBus.Host32\lib\net40\" -Recurse | % { Copy-Item $_.FullName -Destination "$binariesFolder\NServiceBus.Host32\$($_.BaseName + '32' + $_.Extension)"};

#Tools
Copy-item "$packagesFolder\NServiceBus.Tools\*" -Destination "$toolsFolder\"-Include $includeFileList -Force 

Copy-item "$packagesFolder\NServiceBus.Tools\LicenseInstaller\*" -Destination "$toolsFolder\LicenseInstaller\" -Include $includeFileList -Force

Write-Host("Done copying binaries and tools")

$res_binaryFolder = Resolve-Path '..\..\NServiceBus\res-binary\'

Write-Host("Copying Dependencies to $res_binaryFolder")

Copy-Item "$packagesFolder\Particular.CustomActions\lib\net40\" -Destination $res_binaryFolder -Recurse -force


Write-Host("002_copyToBinaries done.")
