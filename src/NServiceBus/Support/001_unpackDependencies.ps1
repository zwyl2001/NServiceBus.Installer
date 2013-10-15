[System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')

$samplesZipFile = Resolve-Path ..\Dependencies
$targetSamplesFolder = (Resolve-Path '..\..\').Path + '\Release\Samples'

Write-Host("Extracting Samples to $targetSamplesFolder")

if(!(Test-Path $targetSamplesFolder)){ md $targetSamplesFolder;}
[System.IO.Compression.ZipFile]::ExtractToDirectory("$samplesZipFile\NServiceBus.Samples.zip", $targetSamplesFolder)

Write-Host("001_unpackDependencies done.")