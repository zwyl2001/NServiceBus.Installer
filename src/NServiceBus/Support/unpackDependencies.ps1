[System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')



$samplesZipFile = Resolve-Path '..\Dependencies'

$targetSamplesFolder = Resolve-Path '..\..\samples'

[System.IO.Compression.ZipFile]::ExtractToDirectory( "$samplesZipFile\NServiceBus.Samples.Transports1.zip", $targetSamplesFolder)

[System.IO.Compression.ZipFile]::ExtractToDirectory("$samplesZipFile\NServiceBus.Samples.Transports2.zip", $targetSamplesFolder)

[System.IO.Compression.ZipFile]::ExtractToDirectory("$samplesZipFile\NServiceBus.Samples.zip", $targetSamplesFolder)

$copyToPackagesFolder = Resolve-Path '..\Dependencies\packages\*'
