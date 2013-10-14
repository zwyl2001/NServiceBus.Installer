[System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')

$samplesZipFile = Resolve-Path '..\Dependencies'

$targetSamplesFolder = Resolve-Path '..\..\Release\samples'

 Write-Host("Extracting Samples to $targetSamplesFolder")

[System.IO.Compression.ZipFile]::ExtractToDirectory("$samplesZipFile\NServiceBus.Samples.zip", $targetSamplesFolder)

$dependenciesPackagesFolder = Resolve-Path '..\Dependencies\packages\'

# bundles\ServiceControl
$bundlesFolder = Resolve-Path '..\..\NServiceBus\bundles\'

Write-Host("Copying Dependencies to $bundlesFolder")

Copy-Item "$dependenciesPackagesFolder\NServiceBus.ServiceControl\*" -Destination $bundlesFolder -Recurse -force

Write-Host("001_unpackDependencies done.")