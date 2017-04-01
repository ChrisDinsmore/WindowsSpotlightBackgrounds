$pathImageDestination = "$env:USERPROFILE\Pictures\Backgrounds";
$sourcePath = "$env:USERPROFILE\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\"

Add-Type -AssemblyName System.Drawing 

function Get-Image{ 
process {
          $file = $_
          [Drawing.Image]::FromFile($_.FullName) |
          ForEach-Object{           
            $_ | Add-Member -PassThru NoteProperty FullName ('{0}' -f $file.FullName)			
          }		  
         }
}

If(!(test-path $pathImageDestination))
{
	New-Item -ItemType Directory -Force -Path $pathImageDestination
}

Get-ChildItem -Path $sourcePath -Filter *.* -Recurse | Get-Image | ? { $_.Width -gt 1280 } | select -expa Fullname | get-item | % { Copy-Item -Path $_ -Destination $pathImageDestination -Force -Container }
#-or $_.Height -gt 1280

Get-ChildItem -Path $pathImageDestination -Exclude *.jpg | WHere-Object{!$_.PsIsContainer} | ForEach-Object {
    $NewName = $_.Name + ".jpg"
    $Destination = Join-Path -Path $_.Directory.FullName -ChildPath $NewName
    Move-Item -Path $_.FullName -Destination $Destination -Force
}