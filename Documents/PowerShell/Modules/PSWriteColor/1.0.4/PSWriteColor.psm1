# PowerForge merged source begin 84a1b8f7a2ffd895184f82323942138f30be816f3b5fc7bafd3c971dd5ef76d5
function Write-Color {
    <#
    .SYNOPSIS
    Write-Color is a wrapper around Write-Host delivering a lot of additional features for easier color options.

    .DESCRIPTION
    Write-Color is a wrapper around Write-Host delivering a lot of additional features for easier color options.

    It provides:
    - Easy manipulation of colors,
    - Logging output to file (log)
    - Nice formatting options out of the box.
    - Ability to use aliases for parameters

    .PARAMETER Text
    Text to display on screen and write to log file if specified.
    Accepts an array of strings.

    .PARAMETER Color
    Color of each text segment. Remaining segments use the first color when there are more strings than colors.
    Available colors are: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

    .PARAMETER BackGroundColor
    Background color of each text segment. When supplied, its count must match Color.
    Remaining segments use the first background color when there are more strings than colors.
    Available colors are: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

    .PARAMETER StartTab
    Number of tabs to add before text. Default is 0.

    .PARAMETER LinesBefore
    Number of empty lines before text. Default is 0.

    .PARAMETER LinesAfter
    Number of empty lines after text. Default is 0.

    .PARAMETER StartSpaces
    Number of spaces to add before text. Default is 0.

    .PARAMETER LogFile
    Literal path to the log file. If not specified no log file will be created.
    Appends joined text with a newline, regardless of NoNewLine. Parent directories must already exist.
    File-write failures produce warnings after up to LogRetry attempts.

    .PARAMETER DateTimeFormat
    Custom date and time format string. Default is yyyy-MM-dd HH:mm:ss

    .PARAMETER LogTime
    If set to $true it will add time to log file. Default is $true.

    .PARAMETER LogRetry
    Maximum number of file-write attempts, including the first attempt. Must be at least 1. Default is 2.

    .PARAMETER Encoding
    Encoding of the log file. Default is Unicode.

    .PARAMETER ShowTime
    Switch to add time to console output. Default is not set.

    .PARAMETER NoNewLine
    Switch to not add new line at the end of the output. Default is not set.

    .PARAMETER NoConsoleOutput
    Switch to not output to console. Default all output goes to console.

    .PARAMETER HorizontalCenter
    Centers single-line text, including its padding, in the visible host window. Odd extra space goes on the right.
    Indentation and timestamps are added after centering. If the host cannot report its window width, no centering spaces are added.

    .PARAMETER PadLeft
    Minimum combined text width, with padding before the first colored segment. Default is 0 (disabled).
    Width counts string characters, not terminal display cells; use single-line text without tabs or ANSI sequences.
    Text is never truncated. Indentation and timestamps are outside this width; log text is unchanged.
    Specify only one positive padding width per call.

    .PARAMETER PadCenter
    Minimum combined text width, with padding on both sides. An odd extra character goes on the right.

    .PARAMETER PadRight
    Minimum combined text width, with padding after the last colored segment.

    .PARAMETER PadCharacter
    Single character used for padding. Default is a space.
    Padding uses the first foreground/background colors. With padding enabled, LinesBefore and LinesAfter
    also fill the requested width with this character and these colors.

    .EXAMPLE
    Write-Color -Text "Red ", "Green ", "Yellow " -Color Red,Green,Yellow

    .EXAMPLE
    Write-Color -Text "This is text in Green ",
                      "followed by red ",
                      "and then we have Magenta... ",
                      "isn't it fun? ",
                      "Here goes DarkCyan" -Color Green,Red,Magenta,White,DarkCyan

    .EXAMPLE
    Write-Color -Text "This is text in Green ",
                      "followed by red ",
                      "and then we have Magenta... ",
                      "isn't it fun? ",
                      "Here goes DarkCyan" -Color Green,Red,Magenta,White,DarkCyan -StartTab 3 -LinesBefore 1 -LinesAfter 1

    .EXAMPLE
    Write-Color "1. ", "Option 1" -Color Yellow, Green
    Write-Color "2. ", "Option 2" -Color Yellow, Green
    Write-Color "3. ", "Option 3" -Color Yellow, Green
    Write-Color "4. ", "Option 4" -Color Yellow, Green
    Write-Color "9. ", "Press 9 to exit" -Color Yellow, Gray -LinesBefore 1

    .EXAMPLE
    $LogPath = Join-Path ([IO.Path]::GetTempPath()) 'PSWriteColor.log'
    Write-Color -LinesBefore 2 -Text "This little ","message is ", "written to log ", "file as well." `
                -Color Yellow, White, Green, Red, Red -LogFile $LogPath -TimeFormat "yyyy-MM-dd HH:mm:ss"
    Write-Color -Text "This can get ","handy if ", "want to display things, and log actions to file ", "at the same time." `
                -Color Yellow, White, Green, Red, Red -LogFile $LogPath

    .EXAMPLE
    Write-Color -T "My text", " is ", "all colorful" -C Yellow, Red, Green -B Green, Green, Yellow
    Write-Color -t "my text" -c yellow -b green
    Write-Color -text "my text" -c red

    .EXAMPLE
    $LogPath = Join-Path ([IO.Path]::GetTempPath()) 'PSWriteColor.log'
    Write-Color -Text "Testuję czy się ładnie zapisze, czy będą problemy" -Encoding unicode -LogFile $LogPath -Color Red -NoConsoleOutput

    .EXAMPLE
    Write-Color '1. ', 'Start backup' -Color Yellow, White -BackgroundColor Blue, Blue -PadRight 32 -LinesBefore 1
    Write-Color '9. ', 'Exit' -Color Yellow, White -BackgroundColor Blue, Blue -PadRight 32 -LinesAfter 1
    Write-Color ' MENU ' -PadCenter 32 -PadCharacter '-' -Color Cyan

    .NOTES
    Understanding Custom date and time format strings: https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings
    Project support: https://github.com/EvotecIT/PSWriteColor
    Original idea: Josh (https://stackoverflow.com/users/81769/josh)

    #>
    [alias('Write-Colour')]
    [CmdletBinding()]
    param (
        [alias ('T')] [String[]]$Text,
        [alias ('C', 'ForegroundColor', 'FGC')] [ConsoleColor[]]$Color = [ConsoleColor]::White,
        [alias ('B', 'BGC')] [ConsoleColor[]]$BackGroundColor = $null,
        [alias ('Indent')][ValidateRange(0, [int]::MaxValue)][int] $StartTab = 0,
        [ValidateRange(0, [int]::MaxValue)][int] $LinesBefore = 0,
        [ValidateRange(0, [int]::MaxValue)][int] $LinesAfter = 0,
        [ValidateRange(0, [int]::MaxValue)][int] $StartSpaces = 0,
        [alias ('L')] [string] $LogFile = '',
        [Alias('DateFormat', 'TimeFormat')][string] $DateTimeFormat = 'yyyy-MM-dd HH:mm:ss',
        [alias ('LogTimeStamp')][bool] $LogTime = $true,
        [ValidateRange(1, [int]::MaxValue)][int] $LogRetry = 2,
        [ValidateSet('unknown', 'string', 'unicode', 'bigendianunicode', 'utf8', 'utf7', 'utf32', 'ascii', 'default', 'oem')][string]$Encoding = 'Unicode',
        [switch] $ShowTime,
        [switch] $NoNewLine,
        [switch] $HorizontalCenter,
        [alias('HideConsole')][switch] $NoConsoleOutput,
        [alias('PL')][ValidateRange(0, [int]::MaxValue)][int] $PadLeft = 0,
        [alias('PC')][ValidateRange(0, [int]::MaxValue)][int] $PadCenter = 0,
        [alias('PR')][ValidateRange(0, [int]::MaxValue)][int] $PadRight = 0,
        [alias('PadChar')][char] $PadCharacter = ' '
    )
    if (@($PadLeft, $PadCenter, $PadRight | Where-Object { $_ -gt 0 }).Count -gt 1) {
        throw 'Specify only one of PadLeft, PadCenter, or PadRight with a positive width.'
    }
    if ($null -eq $Text) {
        $Text = @()
    }
    $TextToFile = $Text -join ''
    # Handle Ignore at this boundary: Windows PowerShell 5.1 cannot pass an inherited
    # Ignore preference through to nested Write-Host calls.
    $SuppressConsole = $NoConsoleOutput -or $PSBoundParameters['InformationAction'] -eq [System.Management.Automation.ActionPreference]::Ignore
    if (-not $SuppressConsole) {
        if ($null -eq $Color -or $Color.Count -eq 0) {
            Write-Error 'Color must contain at least one foreground color.'
            return
        }
        $DefaultColor = $Color[0]
        if ($null -ne $BackGroundColor -and $BackGroundColor.Count -ne $Color.Count) {
            Write-Error "Colors, BackGroundColors parameters count doesn't match. Terminated."
            return
        }
        $PaddingWidth = [Math]::Max($PadLeft, [Math]::Max($PadCenter, $PadRight))
        $MessageLength = $TextToFile.Length
        $PaddingLength = [Math]::Max(0, $PaddingWidth - $MessageLength)
        $LeftPaddingLength = 0
        if ($PadLeft -gt 0) {
            $LeftPaddingLength = $PaddingLength
        }
        elseif ($PadCenter -gt 0) {
            $LeftPaddingLength = [int][Math]::Floor($PaddingLength / 2)
        }
        $RightPaddingLength = $PaddingLength - $LeftPaddingLength
        $PaddingColors = @{ ForegroundColor = $DefaultColor }
        if ($null -ne $BackGroundColor) {
            $PaddingColors.BackgroundColor = $BackGroundColor[0]
        }
        $EmptyLine = "`n"
        if ($PaddingWidth -gt 0 -and ($LinesBefore -gt 0 -or $LinesAfter -gt 0)) {
            $EmptyLine = ([string]$PadCharacter * $PaddingWidth) + "`n"
        }
        for ($i = 0; $i -lt $LinesBefore; $i++) {
            if ($PaddingWidth -gt 0) {
                Write-Host -Object $EmptyLine @PaddingColors -NoNewline
            }
            else {
                Write-Host -Object $EmptyLine -NoNewline
            }
        }
        if ($HorizontalCenter) {
            $MessageLength = [Math]::Max($MessageLength, $PaddingWidth)

            try {
                $WindowWidth = [int](Get-Host).UI.RawUI.WindowSize.Width
            }
            catch {
                # Non-interactive and custom hosts may not implement RawUI.
                $WindowWidth = 0
            }
            $CenterPosition = [int][Math]::Max(0, [Math]::Floor(($WindowWidth - $MessageLength) / 2))
            if ($CenterPosition -gt 0) {
                Write-Host -Object (' ' * $CenterPosition) -NoNewline
            }
        } # Center the line horizontally according to the powershell window size
        if ($StartTab -ne 0) {
            for ($i = 0; $i -lt $StartTab; $i++) {
                Write-Host -Object "`t" -NoNewline
            }
        }  # Add TABS before text
        if ($StartSpaces -ne 0) {
            for ($i = 0; $i -lt $StartSpaces; $i++) {
                Write-Host -Object ' ' -NoNewline
            }
        }  # Add SPACES before text
        if ($ShowTime) {
            Write-Host -Object "[$([datetime]::Now.ToString($DateTimeFormat))] " -NoNewline
        } # Add Time before output
        if ($LeftPaddingLength -gt 0) {
            Write-Host -Object ([string]$PadCharacter * $LeftPaddingLength) @PaddingColors -NoNewline
        }
        for ($i = 0; $i -lt $Text.Count; $i++) {
            $ColorIndex = 0
            if ($i -lt $Color.Count) {
                $ColorIndex = $i
            }
            if ($null -eq $BackGroundColor) {
                Write-Host -Object $Text[$i] -ForegroundColor $Color[$ColorIndex] -NoNewline
            }
            else {
                Write-Host -Object $Text[$i] -ForegroundColor $Color[$ColorIndex] -BackgroundColor $BackGroundColor[$ColorIndex] -NoNewline
            }
        }
        if ($RightPaddingLength -gt 0) {
            Write-Host -Object ([string]$PadCharacter * $RightPaddingLength) @PaddingColors -NoNewline
        }
        if ($NoNewLine -eq $true) {
            Write-Host -NoNewline
        }
        else {
            Write-Host
        } # Support for no new line
        for ($i = 0; $i -lt $LinesAfter; $i++) {
            if ($PaddingWidth -gt 0) {
                Write-Host -Object $EmptyLine @PaddingColors -NoNewline
            }
            else {
                Write-Host -Object $EmptyLine -NoNewline
            }
        }
    }
    if ($Text.Count -and $LogFile) {
        $Saved = $false
        $Retry = 0
        do {
            $Retry++
            try {
                if ($LogTime) {
                    "[$([datetime]::Now.ToString($DateTimeFormat))] $TextToFile" | Out-File -LiteralPath $LogFile -Encoding $Encoding -Append -ErrorAction Stop -WhatIf:$false
                }
                else {
                    $TextToFile | Out-File -LiteralPath $LogFile -Encoding $Encoding -Append -ErrorAction Stop -WhatIf:$false
                }
                $Saved = $true
            }
            catch {
                if ($Saved -eq $false -and $Retry -eq $LogRetry) {
                    Write-Warning "Write-Color - Couldn't write to log file $($_.Exception.Message). Tried ($Retry/$LogRetry)"
                }
                else {
                    Write-Warning "Write-Color - Couldn't write to log file $($_.Exception.Message). Retrying... ($Retry/$LogRetry)"
                }
            }
        } until ($Saved -eq $true -or $Retry -ge $LogRetry)
    }
}
# PowerForge merged source end 84a1b8f7a2ffd895184f82323942138f30be816f3b5fc7bafd3c971dd5ef76d5

$FunctionsToExport = @('Write-Color')
$CmdletsToExport = @()
$AliasesToExport = @('Write-Colour')
Export-ModuleMember -Function $FunctionsToExport -Alias $AliasesToExport -Cmdlet $CmdletsToExport

# SIG # Begin signature block
# MIIt7AYJKoZIhvcNAQcCoIIt3TCCLdkCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDw++zUH4nuQq/s
# dG44613kto8oRrtU2+352fAKH+9UxqCCJukwggWNMIIEdaADAgECAhAOmxiO+dAt
# 5+/bUOIIQBhaMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNV
# BAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yMjA4MDEwMDAwMDBa
# Fw0zMTExMDkyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2Vy
# dCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lD
# ZXJ0IFRydXN0ZWQgUm9vdCBHNDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoC
# ggIBAL/mkHNo3rvkXUo8MCIwaTPswqclLskhPfKK2FnC4SmnPVirdprNrnsbhA3E
# MB/zG6Q4FutWxpdtHauyefLKEdLkX9YFPFIPUh/GnhWlfr6fqVcWWVVyr2iTcMKy
# unWZanMylNEQRBAu34LzB4TmdDttceItDBvuINXJIB1jKS3O7F5OyJP4IWGbNOsF
# xl7sWxq868nPzaw0QF+xembud8hIqGZXV59UWI4MK7dPpzDZVu7Ke13jrclPXuU1
# 5zHL2pNe3I6PgNq2kZhAkHnDeMe2scS1ahg4AxCN2NQ3pC4FfYj1gj4QkXCrVYJB
# MtfbBHMqbpEBfCFM1LyuGwN1XXhm2ToxRJozQL8I11pJpMLmqaBn3aQnvKFPObUR
# WBf3JFxGj2T3wWmIdph2PVldQnaHiZdpekjw4KISG2aadMreSx7nDmOu5tTvkpI6
# nj3cAORFJYm2mkQZK37AlLTSYW3rM9nF30sEAMx9HJXDj/chsrIRt7t/8tWMcCxB
# YKqxYxhElRp2Yn72gLD76GSmM9GJB+G9t+ZDpBi4pncB4Q+UDCEdslQpJYls5Q5S
# UUd0viastkF13nqsX40/ybzTQRESW+UQUOsxxcpyFiIJ33xMdT9j7CFfxCBRa2+x
# q4aLT8LWRV+dIPyhHsXAj6KxfgommfXkaS+YHS312amyHeUbAgMBAAGjggE6MIIB
# NjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTs1+OC0nFdZEzfLmc/57qYrhwP
# TzAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzAOBgNVHQ8BAf8EBAMC
# AYYweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdp
# Y2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNv
# bS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0
# aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENB
# LmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQEMBQADggEBAHCgv0Nc
# Vec4X6CjdBs9thbX979XB72arKGHLOyFXqkauyL4hxppVCLtpIh3bb0aFPQTSnov
# Lbc47/T/gLn4offyct4kvFIDyE7QKt76LVbP+fT3rDB6mouyXtTP0UNEm0Mh65Zy
# oUi0mcudT6cGAxN3J0TU53/oWajwvy8LpunyNDzs9wPHh6jSTEAZNUZqaVSwuKFW
# juyk1T3osdz9HNj0d1pcVIxv76FQPfx2CWiEn2/K2yCNNWAcAgPLILCsWKAOQGPF
# mCLBsln1VWvPJ6tsds5vIy30fnFqI2si/xK4VC0nftg62fC2h5b9W9FcrBjDTZ9z
# twGpn1eqXijiuZQwggWQMIIDeKADAgECAhAFmxtXno4hMuI5B72nd3VcMA0GCSqG
# SIb3DQEBDAUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMx
# GTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRy
# dXN0ZWQgUm9vdCBHNDAeFw0xMzA4MDExMjAwMDBaFw0zODAxMTUxMjAwMDBaMGIx
# CzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3
# dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBH
# NDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAL/mkHNo3rvkXUo8MCIw
# aTPswqclLskhPfKK2FnC4SmnPVirdprNrnsbhA3EMB/zG6Q4FutWxpdtHauyefLK
# EdLkX9YFPFIPUh/GnhWlfr6fqVcWWVVyr2iTcMKyunWZanMylNEQRBAu34LzB4Tm
# dDttceItDBvuINXJIB1jKS3O7F5OyJP4IWGbNOsFxl7sWxq868nPzaw0QF+xembu
# d8hIqGZXV59UWI4MK7dPpzDZVu7Ke13jrclPXuU15zHL2pNe3I6PgNq2kZhAkHnD
# eMe2scS1ahg4AxCN2NQ3pC4FfYj1gj4QkXCrVYJBMtfbBHMqbpEBfCFM1LyuGwN1
# XXhm2ToxRJozQL8I11pJpMLmqaBn3aQnvKFPObURWBf3JFxGj2T3wWmIdph2PVld
# QnaHiZdpekjw4KISG2aadMreSx7nDmOu5tTvkpI6nj3cAORFJYm2mkQZK37AlLTS
# YW3rM9nF30sEAMx9HJXDj/chsrIRt7t/8tWMcCxBYKqxYxhElRp2Yn72gLD76GSm
# M9GJB+G9t+ZDpBi4pncB4Q+UDCEdslQpJYls5Q5SUUd0viastkF13nqsX40/ybzT
# QRESW+UQUOsxxcpyFiIJ33xMdT9j7CFfxCBRa2+xq4aLT8LWRV+dIPyhHsXAj6Kx
# fgommfXkaS+YHS312amyHeUbAgMBAAGjQjBAMA8GA1UdEwEB/wQFMAMBAf8wDgYD
# VR0PAQH/BAQDAgGGMB0GA1UdDgQWBBTs1+OC0nFdZEzfLmc/57qYrhwPTzANBgkq
# hkiG9w0BAQwFAAOCAgEAu2HZfalsvhfEkRvDoaIAjeNkaA9Wz3eucPn9mkqZucl4
# XAwMX+TmFClWCzZJXURj4K2clhhmGyMNPXnpbWvWVPjSPMFDQK4dUPVS/JA7u5iZ
# aWvHwaeoaKQn3J35J64whbn2Z006Po9ZOSJTROvIXQPK7VB6fWIhCoDIc2bRoAVg
# X+iltKevqPdtNZx8WorWojiZ83iL9E3SIAveBO6Mm0eBcg3AFDLvMFkuruBx8lbk
# apdvklBtlo1oepqyNhR6BvIkuQkRUNcIsbiJeoQjYUIp5aPNoiBB19GcZNnqJqGL
# FNdMGbJQQXE9P01wI4YMStyB0swylIQNCAmXHE/A7msgdDDS4Dk0EIUhFQEI6FUy
# 3nFJ2SgXUE3mvk3RdazQyvtBuEOlqtPDBURPLDab4vriRbgjU2wGb2dVf0a1TD9u
# KFp5JtKkqGKX0h7i7UqLvBv9R0oN32dmfrJbQdA75PQ79ARj6e/CVABRoIoqyc54
# zNXqhwQYs86vSYiv85KZtrPmYQ/ShQDnUBrkG5WdGaG5nLGbsQAe79APT0JsyQq8
# 7kP6OnGlyE0mpTX9iV28hWIdMtKgK1TtmlfB2/oQzxm3i0objwG2J5VT6LaJbVu8
# aNQj6ItRolb58KaAoNYes7wPD1N1KarqE3fk3oyBIa0HEEcRrYc9B9F1vM/zZn4w
# ggawMIIEmKADAgECAhAIrUCyYNKcTJ9ezam9k67ZMA0GCSqGSIb3DQEBDAUAMGIx
# CzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3
# dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBH
# NDAeFw0yMTA0MjkwMDAwMDBaFw0zNjA0MjgyMzU5NTlaMGkxCzAJBgNVBAYTAlVT
# MRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1
# c3RlZCBHNCBDb2RlIFNpZ25pbmcgUlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwggIi
# MA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDVtC9C0CiteLdd1TlZG7GIQvUz
# jOs9gZdwxbvEhSYwn6SOaNhc9es0JAfhS0/TeEP0F9ce2vnS1WcaUk8OoVf8iJnB
# kcyBAz5NcCRks43iCH00fUyAVxJrQ5qZ8sU7H/Lvy0daE6ZMswEgJfMQ04uy+wjw
# iuCdCcBlp/qYgEk1hz1RGeiQIXhFLqGfLOEYwhrMxe6TSXBCMo/7xuoc82VokaJN
# TIIRSFJo3hC9FFdd6BgTZcV/sk+FLEikVoQ11vkunKoAFdE3/hoGlMJ8yOobMubK
# wvSnowMOdKWvObarYBLj6Na59zHh3K3kGKDYwSNHR7OhD26jq22YBoMbt2pnLdK9
# RBqSEIGPsDsJ18ebMlrC/2pgVItJwZPt4bRc4G/rJvmM1bL5OBDm6s6R9b7T+2+T
# YTRcvJNFKIM2KmYoX7BzzosmJQayg9Rc9hUZTO1i4F4z8ujo7AqnsAMrkbI2eb73
# rQgedaZlzLvjSFDzd5Ea/ttQokbIYViY9XwCFjyDKK05huzUtw1T0PhH5nUwjeww
# k3YUpltLXXRhTT8SkXbev1jLchApQfDVxW0mdmgRQRNYmtwmKwH0iU1Z23jPgUo+
# QEdfyYFQc4UQIyFZYIpkVMHMIRroOBl8ZhzNeDhFMJlP/2NPTLuqDQhTQXxYPUez
# +rbsjDIJAsxsPAxWEQIDAQABo4IBWTCCAVUwEgYDVR0TAQH/BAgwBgEB/wIBADAd
# BgNVHQ4EFgQUaDfg67Y7+F8Rhvv+YXsIiGX0TkIwHwYDVR0jBBgwFoAU7NfjgtJx
# XWRM3y5nP+e6mK4cD08wDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGln
# aWNlcnQuY29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5j
# b20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNydDBDBgNVHR8EPDA6MDigNqA0hjJo
# dHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNy
# bDAcBgNVHSAEFTATMAcGBWeBDAEDMAgGBmeBDAEEATANBgkqhkiG9w0BAQwFAAOC
# AgEAOiNEPY0Idu6PvDqZ01bgAhql+Eg08yy25nRm95RysQDKr2wwJxMSnpBEn0v9
# nqN8JtU3vDpdSG2V1T9J9Ce7FoFFUP2cvbaF4HZ+N3HLIvdaqpDP9ZNq4+sg0dVQ
# eYiaiorBtr2hSBh+3NiAGhEZGM1hmYFW9snjdufE5BtfQ/g+lP92OT2e1JnPSt0o
# 618moZVYSNUa/tcnP/2Q0XaG3RywYFzzDaju4ImhvTnhOE7abrs2nfvlIVNaw8rp
# avGiPttDuDPITzgUkpn13c5UbdldAhQfQDN8A+KVssIhdXNSy0bYxDQcoqVLjc1v
# djcshT8azibpGL6QB7BDf5WIIIJw8MzK7/0pNVwfiThV9zeKiwmhywvpMRr/Lhlc
# OXHhvpynCgbWJme3kuZOX956rEnPLqR0kq3bPKSchh/jwVYbKyP/j7XqiHtwa+ag
# uv06P0WmxOgWkVKLQcBIhEuWTatEQOON8BUozu3xGFYHKi8QxAwIZDwzj64ojDzL
# j4gLDb879M4ee47vtevLt/B3E+bnKD+sEq6lLyJsQfmCXBVmzGwOysWGw/YmMwwH
# S6DTBwJqakAwSEs0qFEgu60bhQjiWQ1tygVQK+pKHJ6l/aCnHwZ05/LWUpD9r4VI
# IflXO7ScA+2GRfS0YW6/aOImYIbqyK+p/pQd52MbOoZWeE4wgga0MIIEnKADAgEC
# AhANx6xXBf8hmS5AQyIMOkmGMA0GCSqGSIb3DQEBCwUAMGIxCzAJBgNVBAYTAlVT
# MRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5j
# b20xITAfBgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDAeFw0yNTA1MDcw
# MDAwMDBaFw0zODAxMTQyMzU5NTlaMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5E
# aWdpQ2VydCwgSW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBUaW1l
# U3RhbXBpbmcgUlNBNDA5NiBTSEEyNTYgMjAyNSBDQTEwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQC0eDHTCphBcr48RsAcrHXbo0ZodLRRF51NrY0NlLWZ
# loMsVO1DahGPNRcybEKq+RuwOnPhof6pvF4uGjwjqNjfEvUi6wuim5bap+0lgloM
# 2zX4kftn5B1IpYzTqpyFQ/4Bt0mAxAHeHYNnQxqXmRinvuNgxVBdJkf77S2uPoCj
# 7GH8BLuxBG5AvftBdsOECS1UkxBvMgEdgkFiDNYiOTx4OtiFcMSkqTtF2hfQz3zQ
# Sku2Ws3IfDReb6e3mmdglTcaarps0wjUjsZvkgFkriK9tUKJm/s80FiocSk1VYLZ
# lDwFt+cVFBURJg6zMUjZa/zbCclF83bRVFLeGkuAhHiGPMvSGmhgaTzVyhYn4p0+
# 8y9oHRaQT/aofEnS5xLrfxnGpTXiUOeSLsJygoLPp66bkDX1ZlAeSpQl92QOMeRx
# ykvq6gbylsXQskBBBnGy3tW/AMOMCZIVNSaz7BX8VtYGqLt9MmeOreGPRdtBx3yG
# OP+rx3rKWDEJlIqLXvJWnY0v5ydPpOjL6s36czwzsucuoKs7Yk/ehb//Wx+5kMqI
# MRvUBDx6z1ev+7psNOdgJMoiwOrUG2ZdSoQbU2rMkpLiQ6bGRinZbI4OLu9BMIFm
# 1UUl9VnePs6BaaeEWvjJSjNm2qA+sdFUeEY0qVjPKOWug/G6X5uAiynM7Bu2ayBj
# UwIDAQABo4IBXTCCAVkwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQU729T
# SunkBnx6yuKQVvYv1Ensy04wHwYDVR0jBBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4c
# D08wDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMIMHcGCCsGAQUF
# BwEBBGswaTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEEG
# CCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRU
# cnVzdGVkUm9vdEc0LmNydDBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsMy5k
# aWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNybDAgBgNVHSAEGTAX
# MAgGBmeBDAEEAjALBglghkgBhv1sBwEwDQYJKoZIhvcNAQELBQADggIBABfO+xaA
# HP4HPRF2cTC9vgvItTSmf83Qh8WIGjB/T8ObXAZz8OjuhUxjaaFdleMM0lBryPTQ
# M2qEJPe36zwbSI/mS83afsl3YTj+IQhQE7jU/kXjjytJgnn0hvrV6hqWGd3rLAUt
# 6vJy9lMDPjTLxLgXf9r5nWMQwr8Myb9rEVKChHyfpzee5kH0F8HABBgr0UdqirZ7
# bowe9Vj2AIMD8liyrukZ2iA/wdG2th9y1IsA0QF8dTXqvcnTmpfeQh35k5zOCPmS
# Nq1UH410ANVko43+Cdmu4y81hjajV/gxdEkMx1NKU4uHQcKfZxAvBAKqMVuqte69
# M9J6A47OvgRaPs+2ykgcGV00TYr2Lr3ty9qIijanrUR3anzEwlvzZiiyfTPjLbnF
# RsjsYg39OlV8cipDoq7+qNNjqFzeGxcytL5TTLL4ZaoBdqbhOhZ3ZRDUphPvSRmM
# Thi0vw9vODRzW6AxnJll38F0cuJG7uEBYTptMSbhdhGQDpOXgpIUsWTjd6xpR6oa
# Qf/DJbg3s6KCLPAlZ66RzIg9sC+NJpud/v4+7RWsWCiKi9EOLLHfMR2ZyJ/+xhCx
# 9yHbxtl5TPau1j/1MIDpMPx0LckTetiSuEtQvLsNz3Qbp7wGWqbIiOWCnb5WqxL3
# /BAPvIXKUjPSxyZsq8WhbaM2tszWkPZPubdcMIIG7TCCBNWgAwIBAgIQCE/cM09+
# RU7bww+P+ZIYNTANBgkqhkiG9w0BAQsFADBpMQswCQYDVQQGEwJVUzEXMBUGA1UE
# ChMORGlnaUNlcnQsIEluYy4xQTA/BgNVBAMTOERpZ2lDZXJ0IFRydXN0ZWQgRzQg
# VGltZVN0YW1waW5nIFJTQTQwOTYgU0hBMjU2IDIwMjUgQ0ExMB4XDTI2MDgwNTAw
# MDAwMFoXDTM3MTEwNDIzNTk1OVowYzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRp
# Z2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBTSEEyNTYgUlNBNDA5NiBU
# aW1lc3RhbXAgUmVzcG9uZGVyIDIwMjYgMTCCAiIwDQYJKoZIhvcNAQEBBQADggIP
# ADCCAgoCggIBALZ7pvLJ/s1K+NSbTGWz/TjGMPh8CQ6RucZCLv5anHzWJjF/NWJr
# FIhy24fcpKXlgRiky4WAawDfU3YP0BMxt9l3Dm5oCG5Z69AqEN1kgHg2epx+l+lZ
# BcmJCcN0ASURML5uFIS80sZsDwO3BSkUxDjLJhBI+qiZP3aixAC/qEGLjsBNlLol
# 9VZ7pfGEXiMlneJIC5/YKuizVzNFKZZEeoy/0B8Zm+nzKBgSWG52lCO1w+nCg6Xp
# CtklTJXeIg283hw7TmmsZXR+SMbjbrEOvZ3fP2VxIgeR28Y90ZStd3F9VuA5RVyn
# b/whITPAo9b75Zr4Ta6Mj3URm26QZYMn/FnbuTegcoRcFEZ9FOqM5T6MTdtr/n74
# lIT/ug0eeOzmZ6QTFg33otX+bFRsIolvykE1jive4PuESaT8zzVeFWDAMDtozNgL
# ctkGD1ZjkEyZtJrLl5ya0m5doH/ScpaZCZVl6pNUOCybMc/kxC6EAmSJY24L0yYK
# D1Nkddsnb/ItVKi/2nXpQNMu1PT5prW83vV8d67WowuUs0HdY4H8AMLGvdL/WHEj
# 3ZnqMqAQQP9u3Ai9t+5eQ02GDwy0ODjdzi0xlp70W+ow63/0++YDEX1M0iwgUHwb
# rJvfpklkZQvw3+kv3vUPItdwroczk9icflf55W1zOEKAcJVAIXpcMCU9AgMBAAGj
# ggGVMIIBkTAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBQUyWOKMC7USvtulPPm40B+
# 9ezN4jAfBgNVHSMEGDAWgBTvb1NK6eQGfHrK4pBW9i/USezLTjAOBgNVHQ8BAf8E
# BAMCB4AwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwgZUGCCsGAQUFBwEBBIGIMIGF
# MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wXQYIKwYBBQUH
# MAKGUWh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRH
# NFRpbWVTdGFtcGluZ1JTQTQwOTZTSEEyNTYyMDI1Q0ExLmNydDBfBgNVHR8EWDBW
# MFSgUqBQhk5odHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVk
# RzRUaW1lU3RhbXBpbmdSU0E0MDk2U0hBMjU2MjAyNUNBMS5jcmwwIAYDVR0gBBkw
# FzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3DQEBCwUAA4ICAQCNxTph
# Hp1SCt+ZrAmAfn0oQLFr0mLywSLaDXQIENoyKqxrFbJblzCVP/pkXmwXOdrOpWyg
# LzlT12os5ipDCy35RBCg2UMeApEtrfGhz45F4Wt4WGdNdIbRWt3YTYJmpR+b7lr4
# d7Uwn+H600u4D7RnOGf8Wj4UNgAdZkfHhHv1mx9EVh71SJelcEN/oORSjXzdjfw1
# iZH9d8Nh/thn6hH23d+VsPAr6GAYyzSA02nXD1nYLI7Ijmiv+xLCiYC41DSFYL3G
# hTiy0PxpawPtGRyaBVGzq+UiTfM8pD7KVyF5aQyWP4KhVGUUTnmm/RlYJoW3TiXA
# /+t0YcT2oRVBm3JETjajHug2AL+v5jhtKVnd3D0rbHXEu27o+Q8p4sEWPMqKDB+q
# bceb6T/6WcwTwXmQ9lOCLLYcsQeSWmvKqzpAec9etE14jOQAzLKWdE3w/TCaKtLR
# aRT7LCkRYVnhA2D73FLje1O5b3HR5eHs0NzU/+xX7NbEdcofy0W3Wdwd1XOqtlpg
# /JgwtKfZM5dqO94lbUveOiJBI+xZEbGRsMNbXmMREUTgu+Oca7Y73MPWcslIx2Vh
# kSKSXjDbD6rgg39H5Mh7QfieAIjWagkJNt68Yfim6cjEzVSiLSeZfdkr5dtFPTW6
# jATlWJdYeeDRGCyatf8R1hSjzSvdN8yWQPT9gzCCB2MwggVLoAMCAQICEAhTOt+G
# wz3QWpc3Z3ZgARUwDQYJKoZIhvcNAQELBQAwaTELMAkGA1UEBhMCVVMxFzAVBgNV
# BAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVkIEc0
# IENvZGUgU2lnbmluZyBSU0E0MDk2IFNIQTM4NCAyMDIxIENBMTAeFw0yNTEyMjYw
# MDAwMDBaFw0yODEyMjcyMzU5NTlaMGsxCzAJBgNVBAYTAlBMMRIwEAYDVQQHDAlN
# aWtvxYLDs3cxIzAhBgNVBAoTGkV2b3RlYyBTZXJ2aWNlcyBzcC4geiBvLm8uMSMw
# IQYDVQQDExpFdm90ZWMgU2VydmljZXMgc3AuIHogby5vLjCCAiIwDQYJKoZIhvcN
# AQEBBQADggIPADCCAgoCggIBANxbP/C0CFW8Z1gxi5+MxwMPmc5G8c3fIiV9S9FY
# Lic5MEFf2hrQJ2PIx/Xf7bsfkuk0cSeUTnTL/sZYI9U9Hjah1EAxSvryILnhjoyZ
# eedLTjOJkyWjoIs8cquJ8QAJgGYW8xhYp4e52MQGv8nHFkytFLebmrNJ88czDh4F
# 5+UvvYovOkxJ68kvAXU0MMdiF3SOLii+gWQRcmRFQNghMJo4jS0jDfp7EzKN5GHY
# iNbT5/xc1H16olQHZ37kIzGQlCel9+hTnPxf94eVouHo+HOQWlC55nujZAGFkID1
# h9EuRFCpPfapQVKmKSH8kxcJ1Ml11VQOE2HvFuMnOzE0DTq4qUSY7OZa5ddPXz5e
# usNIwiIVEIXfKZD+UHRZkmdoSEGoCNVJHLRDTEKxnNJeaGKihE/K+DgeCYVipITP
# 5MOwgG5nvOxILPs7CmxqaEGH9iT/xuJ4wiiBtLmvJiyJlHUOsVj0GtTdxMP5jjg2
# tIWVRAMkLRsfqSz31c9DbENEh7n8u6qqWAW3U2pWktY1i0PZt9vwfJnboZQnP91h
# +Lee9/3YGnVyXq6J/x0TkBD9tg3CD5cTBDtA3MyDYQ4AYkYoToj6QP8fJnecOHx7
# 8UuU+f3N//gAfAu1UR3cM044N3Btm6IuyaXaRrFCro8L0nAV0WFMGz/W1FWnqTfT
# SQ/XAgMBAAGjggIDMIIB/zAfBgNVHSMEGDAWgBRoN+Drtjv4XxGG+/5hewiIZfRO
# QjAdBgNVHQ4EFgQUehhCwq/shewf/KCCM+q+nhvZG/wwPgYDVR0gBDcwNTAzBgZn
# gQwBBAEwKTAnBggrBgEFBQcCARYbaHR0cDovL3d3dy5kaWdpY2VydC5jb20vQ1BT
# MA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzCBtQYDVR0fBIGt
# MIGqMFOgUaBPhk1odHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVz
# dGVkRzRDb2RlU2lnbmluZ1JTQTQwOTZTSEEzODQyMDIxQ0ExLmNybDBToFGgT4ZN
# aHR0cDovL2NybDQuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0Q29kZVNp
# Z25pbmdSU0E0MDk2U0hBMzg0MjAyMUNBMS5jcmwwgZQGCCsGAQUFBwEBBIGHMIGE
# MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wXAYIKwYBBQUH
# MAKGUGh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRH
# NENvZGVTaWduaW5nUlNBNDA5NlNIQTM4NDIwMjFDQTEuY3J0MAkGA1UdEwQCMAAw
# DQYJKoZIhvcNAQELBQADggIBAD/YXkCSn1GzVQkE3O/LO2XlSbJYUNUFpAN4F4JZ
# qAjQN1KCIdzWBPCOA844XDWo3fZox3sO/KF0tXVF2QeD7scK5bpd2gVE0tTqsWO0
# 9wR5VvzBHWZI3vWk6JfBT8pZK3++7iqpOYtZPQFYhHCk0pKqwL8K5ajrSRNoXcKK
# VK8+ITMgVuwKqRtYpCs3VjX/kEPZtVTXAOLWB875hcuaqWhHye199ZCtuV0xgp4k
# v1Euk42sN4s5nuFgS0M3ZTAAujJLSFsKnbGv086tbBiOjj/ntPwbKd2jwZu1MDSK
# rZjvKRvUvU2sK4xVu185n5Lfz4CU6j7XRVFAYYYDxvYfMJ9ABKiZgl5o++PPx66d
# gLxDKNC30YIAnQXgExaFEp1u5OCEQNJ/VmYjwl8SRvMy4A20sb9bczlFww8tpRb6
# 2WCRdhZck7rPLsPBjQgvkreachnOQAO8hMY5R4i9t88vBVq+cxj3tg0PMgqv7MWO
# mrgzBeTow7twTnSU9w1SgVoUi39M7t8pwX1E6xJQiJL+SFlBH+AJK0iByN7YZjW7
# 65xxum54/kolZb9hgWiGQABNQMBHhEGYG8LLuLdBotIFs4sL+aP7IJv5N0mierbK
# N5ROlavUwY4YIVqQSj+c1BU+f+uljQkZ5YFFt1y8oiYvTHkUkLYjL8cHVLvxTzsT
# Nd1ZMYIGWTCCBlUCAQEwfTBpMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNl
# cnQsIEluYy4xQTA/BgNVBAMTOERpZ2lDZXJ0IFRydXN0ZWQgRzQgQ29kZSBTaWdu
# aW5nIFJTQTQwOTYgU0hBMzg0IDIwMjEgQ0ExAhAIUzrfhsM90FqXN2d2YAEVMA0G
# CWCGSAFlAwQCAQUAoIGEMBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZI
# hvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcC
# ARUwLwYJKoZIhvcNAQkEMSIEIP+5NX+jXWyY0II4p1n2dxjvhQqdRwoA60xHnB9J
# WxloMA0GCSqGSIb3DQEBAQUABIICAACF8xMJPz6XOJbHX/Xia7RZpB0HLWYcS1EK
# IjV9/Zrojli+apsESrdCHOSGHXMZmfipFr4E64WqivoCb476Ediob5O7Ya9iLTjy
# s6WLsqd3bBc0q/F+DXnKeCtS0PYv4kX6Nhm8u0XDNufJ8Q3aYqatzVWcfVAgGmZY
# tdXQ+7CJ2PS+Erog2navcF8yhoKn+Di1JrvNn9skY/pNzomnBGvYo5pgoCzODG6N
# DZemyLETOLzOYfLbiZd6D75/l2ycP4Jaqy9rjCkNQ76Oz3LLuB7ZEmEyq9P7WEeU
# xRyDUs+e87RkQs1ickm8+3bHP6m5sSDeoiEGRV9sdInkM4awSuwW36BzTfqVnwb7
# FU1bExt3COlEBPX2K+cIq4oZbYlqTQ3DnhF0fGLbJarNrMRDrqYpVhPC5yP3gi/e
# KA7YT/Cvx8c56hx7I4HYJ6oIXHHmnuQSN6HrSZf6G6WhPL/KQoW4YHfi2zlGRzHl
# GSJzylrFDeAgNmwa7bha03TDOo31wV6IDbyLu6i/rj17UHRbXW2dREtEVaIj3CMe
# 0KsNgqh6zzhynKv5a0+rcXS9jdVt5I3gfJ8kyNSWhfTknXQGvXrcKwel2ouVHKdF
# KDliKIoYZxtwKvXv5U36Bj0V1FaWPEPUFdVK5urLgdU4osORVii2O4/FZSo21z0z
# XeB32lq8oYIDJjCCAyIGCSqGSIb3DQEJBjGCAxMwggMPAgEBMH0waTELMAkGA1UE
# BhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQDEzhEaWdpQ2Vy
# dCBUcnVzdGVkIEc0IFRpbWVTdGFtcGluZyBSU0E0MDk2IFNIQTI1NiAyMDI1IENB
# MQIQCE/cM09+RU7bww+P+ZIYNTANBglghkgBZQMEAgEFAKBpMBgGCSqGSIb3DQEJ
# AzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDkyMDE2NTAxMlowLwYJ
# KoZIhvcNAQkEMSIEIMu2OWgiy4yGKu0urSebRtf1WSi85BikHHH5yEfHp4+yMA0G
# CSqGSIb3DQEBAQUABIICAKStSOkvUVTVKUsOcOY3rOBut4LaMEY8J4XQTKWrKoBZ
# oIrcmvov0KzExYnVWvA+QaBfNihAbzq1KQAgX6H44xV4NwRFObmtYRLehYYzaVrC
# rBN3UHhVamcX6TvOgwtmhY7/dlvomRERiJ7foUa/11aT5/fF/tHGX12dXAihiS1H
# jEE+fz2RBEwqDd8FK1OFua27toZ0DHrjU32iMXNC4fJWWeKJkwyGQgkdGWNMJlPS
# 1NMqzE9j58ELJWA7QhB/zGDdp0+KvMWzKXvMUZLpSuddz1faf1zGSpaVl8+zMaEf
# o6ce15iCUgfENqSxWxQvE/qrvP6rSvqnRD4VFGgwObtmmZkCRYgcjRAI+PxWjScN
# IQnnRVgCljglpNwb/6u41KlE1blNO1mI3uja/WJgF2Tshrz2AM6UsyHO4aWze+8v
# 1NY45yPyOzyvuM3+XMXiApbX4DZjolXS3I754cfHHOS2SIx4pELQ+Bp7ovCXo/3y
# TaPkdWPqPJFtjlLaXksa6R3BxBzu81YLjebLh8fIGU08zuYCZDxQBeq14jymWf2i
# preyWgzkFSrf7Zj+Ex3L23/MobBKzkbSKzrhCBA7LbEOA48rWrZubUtquS64k4op
# bJKYL3bBF/KDKp7LDjPv/ixAsPD/db7HuHOCtGu3t6DF288uEGzhrX8Eo7p3b4t1
# SIG # End signature block
