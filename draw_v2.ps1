Param (
    [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
    [string]$ImageFile,
    [ValidateSet('Write')]
    [string]$outType,
    [string]$outFile
)
$SrcImg = [System.Drawing.Image]::FromFile($ImageFile)

$asciiart = ""
Clear-Host
for ($i = 0; $i -lt $SrcImg.Height; $i += 2) {
    for ($j = 0; $j -lt $SrcImg.Width; $j+=1) {
        #Write-Host "Getting X: $j Y: $i"

        $back = $SrcImg.GetPixel($j, $i)
        if ($i -ge $SrcImg.Height - 1) {
            $foreVT = "" 
        } else {
            $fore   = $SrcImg.GetPixel($j, $i + 1)
            $foreVT = "$([char]27)[38;2;$($fore.R);$($fore.G);$($fore.B)m"
        }

        $backVT = "$([char]27)[48;2;$($back.R);$($back.G);$($back.B)m"

        if($fore.A,$back.A -eq 0){
            $asciiart = $asciiart + " "
        }

        if(($fore.A -eq 0) -and ($back.A -gt 0)){
            $backVT = "$([char]27)[38;2;$($back.R);$($back.G);$($back.B)m"
            $asciiart = $asciiart + "$backVT▀$([char]27)[0m"
        }
        
        if(($fore.A -gt 1) -and ($back.A -eq 0)) {
            $asciiart = $asciiart + "$foreVT▄$([char]27)[0m"
        }
        
        if(($fore.A -gt 1) -and ($back.A -gt 1)) {
            $asciiart = $asciiart + "$backVT$foreVT▄$([char]27)[0m"
        }
    }
    $asciiart = $asciiart + "`n"
}

switch ($outType) {
    'Write' {
        echo $asciiart >> $outFile
      }
    Default {
        Write-Host ($asciiart)
    }
}
