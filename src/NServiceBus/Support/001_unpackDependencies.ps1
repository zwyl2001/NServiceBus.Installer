[System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')

$samplesZipFile = Resolve-Path '..\Dependencies'

$targetSamplesFolder = Resolve-Path '..\..\Release\samples'

 Write-Host("Extracting Samples to $targetSamplesFolder")

[System.IO.Compression.ZipFile]::ExtractToDirectory( "$samplesZipFile\NServiceBus.Samples.Transports1.zip", $targetSamplesFolder)

[System.IO.Compression.ZipFile]::ExtractToDirectory("$samplesZipFile\NServiceBus.Samples.Transports2.zip", $targetSamplesFolder)

[System.IO.Compression.ZipFile]::ExtractToDirectory("$samplesZipFile\NServiceBus.Samples.zip", $targetSamplesFolder)

$copyToPackagesFolder = Resolve-Path '..\Dependencies\packages\'


$res_binaryFolder = Resolve-Path '..\..\NServiceBus\res-binary\'

Write-Host("Copying Dependencies to $res_binaryFolder")

Copy-Item "$copyToPackagesFolder\Particular.CustomActions\*" -Destination $res_binaryFolder -Recurse -force

# bundles\ServiceControl
$bundlesFolder = Resolve-Path '..\..\NServiceBus\bundles\'

Write-Host("Copying Dependencies to $bundlesFolder")

Copy-Item "$copyToPackagesFolder\NServiceBus.ServiceControl\*" -Destination $bundlesFolder -Recurse -force

Write-Host("001_unpackDependencies done.")