Param (
    [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
    [string]$ImageFile,
    [ValidateSet('FillTerminal', 'Fit')]
    [string]$Fit = 'Fit'
)

$null   = [Reflection.Assembly]::LoadWithPartialName('System.Drawing')
$SrcImg = [System.Drawing.Image]::FromFile($ImageFile)

#[double]$ratio  = $SrcImg.Height / $SrcImg.Width
switch ($Fit) {
    'FillTerminal' {
        [int]$newWidth  = $host.UI.rawui.WindowSize.Width
        [int]$newHeight = $host.UI.rawui.WindowSize.Height * 2
        $SrcImg = $SrcImg.GetThumbnailImage($newWidth, $newHeight, $null, 2)
    }
    'Fit' {
        [float]$imgRatio = $SrcImg.Width / $SrcImg.Height
        [float]$conRatio = $host.UI.rawui.WindowSize.Width / ($host.UI.rawui.WindowSize.Height * 2)

        if ([Math]::Abs(1 - $imgRatio) -gt [Math]::Abs(1 - $conRatio)) {
            # Bild entscheidet Format
            if ($imgRatio -lt 1) {
                [int]$newHeight = $host.UI.RawUI.WindowSize.Height * 2
                [int]$newWidth  = $newHeight * $imgRatio
            } else {
                [int]$newWidth  = $host.UI.rawui.WindowSize.Width
                [int]$newHeight = $newWidth / $imgRatio
            }
        } else {
            # Konsole hat krasseres Format und entscheidet
            Write-Host "Konsole ist weiter weg von 1:1"
            if ($conRatio -lt 1) {
                [int]$newWidth  = $host.UI.rawui.WindowSize.Width
                [int]$newHeight = $newWidth / $imgRatio
            } else {
                [int]$newHeight = $host.UI.RawUI.WindowSize.Height * 2
                [int]$newWidth  = $newHeight * $imgRatio
            }
        }

        $SrcImg = $SrcImg.GetThumbnailImage($newWidth, $newHeight, $null, 2)
    }
}

#▀▄

for ($i = 0; $i -lt $SrcImg.Height; $i += 2) {
    for ($j = 0; $j -lt $SrcImg.Width; $j++) {
        #Write-Host "Getting X: $j Y: $i"

        $back = $SrcImg.GetPixel($j, $i)
        if ($i -ge $SrcImg.Height - 1) {
            $foreVT = "" 
        } else {
            $fore   = $SrcImg.GetPixel($j, $i + 1)
            $foreVT = "$([char]27)[38;2;$($fore.R);$($fore.G);$($fore.B)m"
        }

        $backVT = "$([char]27)[48;2;$($back.R);$($back.G);$($back.B)m"

        Write-Host "$backVT$foreVT▄$([char]27)[0m" -NoNewline
    }
    Write-Host ""
}
