#requires -Version 2.0
Set-StrictMode -Version Latest
# private function
function Test-Environment {
    # this module supports only desktop edition
    Set-StrictMode -Version 2.0
    try {
        if ($PSVersionTable.PSEdition -eq "Desktop") {
            return $true
        }
        return $false
    }
    catch {
        # PS5.1 earlier(=Desktop Edition)
        return $true
    }
}
if (-not (Test-Environment)) {
    Write-Warning "[PSBanner]This environment is not supported."
    return
}

<#
.SYNOPSIS
    Get installed font Families.
#>
function Get-FontFamilies {
    return (New-Object "System.Drawing.Text.InstalledFontCollection").Families
}

<#
.SYNOPSIS
    Write banner string to the console.
.PARAMETER InputObject
    Specify the object to write banner string.
    if the object's type is not string, "Name" property value or "ToString()" method result is choosen. 
.PARAMETER FontName
    Specify the font family name.
    Get-FontFamilies cmdlet can get all available font family names.
.PARAMETER FontSize
    Font size(pt).
.PARAMETER Bold
    Specify using Bold for font style.
.PARAMETER Italic
    Specify using Italic for font style.
.PARAMETER Strikeout
    Specify using Strikeout for font style.
.PARAMETER Underline
    Specify using Underline for font style.
.PARAMETER Stream
    Default false.
#>
function Write-Banner {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [psobject]$InputObject,
        [Alias("f")]
        [Parameter(Mandatory = $false)]
        [string]$FontName = "Consolas",
        [Alias("s")]
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 100)]
        [int]$FontSize = 10,
        [Parameter(Mandatory = $false)]
        [switch]$Bold = $false,
        [Parameter(Mandatory = $false)]
        [switch]$Italic = $false,
        [Parameter(Mandatory = $false)]
        [switch]$Strikeout = $false,
        [Parameter(Mandatory = $false)]
        [switch]$Underline = $false,
        [Parameter(Mandatory = $false)]
        [switch]$Stream = $false
    )
    
    begin {
        # check FontName parameter 
        $installedFonts = Get-FontFamilies
        if ($installedFonts -notcontains $FontName) {
            throw "FontName `"$FontName`" is not installed."
        }
    }

    process {
        try {
            # get output string message
            if ($InputObject -is [string]) {
                $message = $InputObject
            }
            else {
                if (Get-Member -InputObject $InputObject -MemberType Properties -Name Name) {
                    $message = $InputObject.Name
                }
                else {
                    $message = $InputObject.ToString()
                }
            }
            
            # set font and font style
            $fontStyle = [System.Drawing.FontStyle]::Regular
            if ($Bold) {
                $fontStyle += [System.Drawing.FontStyle]::Bold
            }
            if ($Italic) {
                $fontStyle += [System.Drawing.FontStyle]::Italic
            }
            if ($Strikeout) {
                $fontStyle += [System.Drawing.FontStyle]::Strikeout
            } 
            if ($Underline) {
                $fontStyle += [System.Drawing.FontStyle]::Underline
            } 
            $font = New-Object "System.Drawing.Font" -ArgumentList @($FontName, $FontSize, $fontStyle)
            
            # draw graphic
            # 多分もっと上手いやり方があるはず...
            $brash = New-Object "System.Drawing.SolidBrush" -ArgumentList @([System.Drawing.Color]::White)
            $format = New-Object "System.Drawing.StringFormat" -ArgumentList @([System.Drawing.StringFormat]::GenericTypographic)
            $bitmap = New-Object "System.Drawing.Bitmap" -ArgumentList @(1, 1)
            $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
            $measuredSize = $graphic.MeasureString($message, $font, (New-Object "System.Drawing.PointF" -ArgumentList @(0, 0)), $format)
            $bitmap = New-Object "System.Drawing.Bitmap" -ArgumentList @([int]$measuredSize.Width, [int]$measuredSize.Height)
            $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
            # draw string
            $graphic.DrawString($message, $font, $brash , 0, 0, $format)
            # for debug
            #$bitmap.Save("$env:TEMP\banner.png", [System.Drawing.Imaging.ImageFormat]::Png)

            # output to the console
            $screenWidth = $Host.UI.RawUI.BufferSize.Width
            $trimWidth = $bitmap.Width
            if ($trimWidth -gt $screenWidth) {
                $trimWidth = $screenWidth
            }
            $line = ""
            for ($y = 0; $y -lt $bitmap.Height; $y++) {
                if ($Stream) {
                    $line = ""
                }
                for ($x = 0; $x -lt $trimWidth; $x++) {
                    $p = $bitmap.GetPixel($x, $y)
                    if ($p.R -eq 0 -and $p.G -eq 0 -and $p.B -eq 0) {
                        $line += " "
                    }
                    else {
                        $line += "#"
                    }
                }
                if ($Stream) {
                    Write-Output $line
                }
                else {
                    $line += [System.Environment]::NewLine
                }
            }
            if (-not $Stream) {
                Write-Output $line
            }
        }
        finally {
            $brash.Dispose()
            $format.Dispose()
            $font.Dispose()
            $graphic.Dispose()
            $bitmap.Dispose()
        }
    }
}
# Alias
Set-Alias -Name psbanner -Value Write-Banner
