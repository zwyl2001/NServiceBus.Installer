[System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')

$samplesZipFile = Resolve-Path '..\Dependencies'

$targetSamplesFolder = Resolve-Path '..\..\Release\samples'

 Write-Host("Extracting Samples to $targetSamplesFolder")

[System.IO.Compression.ZipFile]::ExtractToDirectory( "$samplesZipFile\NServiceBus.Samples.Transports1.zip", $targetSamplesFolder)

[System.IO.Compression.ZipFile]::ExtractToDirectory("$samplesZipFile\NServiceBus.Samples.Transports2.zip", $targetSamplesFolder)

[System.IO.Compression.ZipFile]::ExtractToDirectory("$samplesZipFile\NServiceBus.Samples.zip", $targetSamplesFolder)

$copyToPackagesFolder = Resolve-Path '..\Dependencies\packages\*'


$packagesFolder = Resolve-Path '..\..\packages\'

Write-Host("Copying Dependencies to $packagesFolder")

Copy-Item $copyToPackagesFolder -Destination $packagesFolder -Recurse -force

Write-Host("001_unpackDependencies done.")