Invoke-Expression (&starship init powershell)
Set-Location $env:USERPROFILE

# Import Terminal Icons
Import-Module -Name Terminal-Icons

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

function ix ($file) {
  curl.exe -F "f:1=@$file" ix.io
}

function Get-PubIP {
    (Invoke-WebRequest http://ifconfig.me/ip ).Content
}

function Git-Upload {
  git add .
  git commit -m "$args"
  git push
}
function git-push {
  git add .
  git commit -m "$args"
  git push
}
function cdgit($name) {
  Set-Location "$env:USERPROFILE\Documents\GitHub\$name"
}

function touch($file) {
  "" | Out-File $file -Encoding ASCII
}
function which($name) {
  Get-Command $name | Select-Object -ExpandProperty Definition
}
function pkill($name) {
  Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}
function g { Set-Location $HOME\Documents\Github }

New-Alias -Name neofetch -Value winfetch
function neofetch-image {
  winfetch -image "$env:USERPROFILE\Documents\GitHub\Dot-Files-Windows\.config\winfetch\Toad_Artwork_-_Super_Mario_3D_World.png"
}

# Youtube
function yta-aac($name) {
  yt-dlp --extract-audio --audio-format aac --embed-metadata --embed-thumbnail $name
}
function yta-best($name) {
  yt-dlp --extract-audio --audio-format best --embed-metadata --embed-thumbnail $name
}
function yta-flac($name) {
  yt-dlp --extract-audio --audio-format flac --embed-metadata --embed-thumbnail $name
}
function yta-m4a($name) {
  yt-dlp --extract-audio --audio-format m4a --embed-metadata --embed-thumbnail $name
}
function yta-mp3($name) {
  yt-dlp --extract-audio --audio-format mp3 --embed-metadata --embed-thumbnail $name
}
function yta-opus($name) {
  yt-dlp --extract-audio --audio-format opus --embed-metadata --embed-thumbnail $name
}
function yta-vorbis($name) {
  yt-dlp --extract-audio --audio-format vorbis --embed-metadata --embed-thumbnail $name
}
function yta-wav($name) {
  yt-dlp --extract-audio --audio-format wav --embed-metadata --embed-thumbnail $name
}
function ytv-best($name) {
  yt-dlp -f bestvideo+bestaudio --embed-metadata --embed-thumbnail --embed-chapters $name
}
function ytv-best-mp4($name) {
  yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --embed-metadata --embed-thumbnail --embed-chapters $name
}
function ytv-best-mp4-1080p($name) {
  yt-dlp -f "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --embed-metadata --embed-thumbnail --embed-chapters $name
}
# bat-cat
Remove-Item -Path alias:cat
New-Alias -Name cat -Value bat
# Import the PSWriteColor module
Import-Module PSWriteColor
# ll
function ll {
  function Get-FolderSize($path) {
      $size = 0

      Get-ChildItem $path -Recurse -File -Force -ErrorAction SilentlyContinue | ForEach-Object {
          $size += $_.Length
      }

      return $size
  }

  function Format-Size($size) {
      $suffixes = "B", "KB", "MB", "GB", "TB"
      $index = 0

      while ($size -ge 1KB -and $index -lt $suffixes.Length) {
          $size /= 1KB
          $index++
      }

      return "{0:N2} {1}" -f $size, $suffixes[$index]
  }

  $currentPath = Get-Location

  $items = Get-ChildItem $currentPath -Force

  $fileCount = 0
  $folderCount = 0
  $totalSize = 0

  foreach ($item in $items) {
      if ($item.PSIsContainer) {
          $mode = "d"
          $folderCount++
      } else {
          $mode = "-"
          $fileCount++
      }

      $size = if ($item.PSIsContainer) {
          Get-FolderSize $item.FullName
      } else {
          $item.Length
      }

      $totalSize += $size

      $time = $item.LastWriteTime.ToString("MMM dd, yyyy hh:mm tt")  # Example: Aug 20, 2022 03:25 PM
      $formattedSize = Format-Size $size

      Write-Host -NoNewline -ForegroundColor Green ("{0}  " -f $item.Mode)
      Write-Host -NoNewline $item.LastWriteTime
      Write-Host -NoNewline -ForegroundColor Cyan ("  {0,12}" -f $formattedSize)
      Write-Host -NoNewline "  "
      Write-Host -NoNewline -ForegroundColor Green ($item.Attributes + " ")
      Write-Host -NoNewline "  "
      Write-Host $item.Name
  }

  $formattedTotalSize = Format-Size $totalSize
  
  Write-Host ""
  Write-Host -NoNewline -ForegroundColor DarkGray ("Total Files: {0}  " -f $fileCount)
  Write-Host -NoNewline -ForegroundColor DarkGray ("Total Folders: {0}  " -f $folderCount)
  Write-Host -NoNewline -ForegroundColor DarkGray ("Total Size: {0}" -f $formattedTotalSize)
}


# Create PowerShell functions for tar-like commands
function mktar {
  param(
      [Parameter(Position = 0, Mandatory = $true)]
      [Alias("Path")]
      [string[]]$SourcePath,
      
      [Parameter(Position = 1, Mandatory = $true)]
      [Alias("DestinationPath")]
      [string]$OutputPath
  )
  
  Compress-Archive -Path $SourcePath -DestinationPath $OutputPath
}

function mkbz2 {
  param(
      [Parameter(Position = 0, Mandatory = $true)]
      [Alias("Path")]
      [string[]]$SourcePath,
      
      [Parameter(Position = 1, Mandatory = $true)]
      [Alias("DestinationPath")]
      [string]$OutputPath
  )
  
  Compress-Archive -Path $SourcePath -DestinationPath $OutputPath -CompressionLevel Optimal
}

function mkgz {
  param(
      [Parameter(Position = 0, Mandatory = $true)]
      [Alias("Path")]
      [string[]]$SourcePath,
      
      [Parameter(Position = 1, Mandatory = $true)]
      [Alias("DestinationPath")]
      [string]$OutputPath
  )
  
  Compress-Archive -Path $SourcePath -DestinationPath $OutputPath -CompressionLevel Optimal
}

function mkrar {
  param(
      [Parameter(Position = 0, Mandatory = $true)]
      [Alias("Path")]
      [string[]]$SourcePath,
      
      [Parameter(Position = 1, Mandatory = $true)]
      [Alias("DestinationPath")]
      [string]$OutputPath
  )
  
  7z a -r $OutputPath $SourcePath
}


function untar {
  param(
      [Parameter(Position = 0, Mandatory = $true)]
      [Alias("Path")]
      [string]$SourcePath,

      [Parameter(Position = 1)]
      [Alias("DestinationPath")]
      [string]$OutputPath = (Join-Path -Path (Split-Path -Path $SourcePath -LeafBase) -ChildPath "")
  )
  
  & 7z e $SourcePath -o$OutputPath
}
function unbz2 {
  param(
      [Parameter(Position = 0, Mandatory = $true)]
      [Alias("Path")]
      [string]$SourcePath,

      [Parameter(Position = 1)]
      [Alias("DestinationPath")]
      [string]$OutputPath = (Join-Path -Path (Split-Path -Path $SourcePath -LeafBase) -ChildPath "")
  )
  
  & 7z e $SourcePath -o$OutputPath
}
function unbz2 {
  param(
      [Parameter(Position = 0, Mandatory = $true)]
      [Alias("Path")]
      [string]$SourcePath,

      [Parameter(Position = 1)]
      [Alias("DestinationPath")]
      [string]$OutputPath = (Join-Path -Path (Split-Path -Path $SourcePath -LeafBase) -ChildPath "")
  )
  
  & 7z e $SourcePath -o$OutputPath
}

function ungz {
  param(
      [Parameter(Position = 0, Mandatory = $true)]
      [Alias("Path")]
      [string]$SourcePath,

      [Parameter(Position = 1)]
      [Alias("DestinationPath")]
      [string]$OutputPath = (Join-Path -Path (Split-Path -Path $SourcePath -LeafBase) -ChildPath "")
  )
  
  & 7z e $SourcePath -o$OutputPath
}
function unzip {
  param(
      [Parameter(Position = 0, Mandatory = $true)]
      [Alias("Path")]
      [string]$SourcePath,

      [Parameter(Position = 1)]
      [Alias("DestinationPath")]
      [string]$OutputPath = (Join-Path -Path (Split-Path -Path $SourcePath -LeafBase) -ChildPath "")
  )
  
  & 7z e $SourcePath -o$OutputPath
}
function unrar {
  param(
      [Parameter(Position = 0, Mandatory = $true)]
      [Alias("Path")]
      [string]$SourcePath,

      [Parameter(Position = 1)]
      [Alias("DestinationPath")]
      [string]$OutputPath = (Join-Path -Path (Split-Path -Path $SourcePath -LeafBase) -ChildPath "")
  )
  
  & 7z e $SourcePath -o$OutputPath
}


# Play video and audio files in current dir by type
function playmp3 {
  Get-ChildItem -Filter *.mp3 | ForEach-Object { Start-Process -FilePath $_.FullName -Verb Open }
}
function playavi {
  Get-ChildItem -Filter *.avi | ForEach-Object { Start-Process -FilePath $_.FullName -Verb Open }
}
function playmov {
  Get-ChildItem -Filter *.mov | ForEach-Object { Start-Process -FilePath $_.FullName -Verb Open }
}
function playmp4 {
  Get-ChildItem -Filter *.mp4 | ForEach-Object { Start-Process -FilePath $_.FullName -Verb Open }
}
Remove-Item -Path alias:cp
Set-Alias -Name cp -Value Copy-Item
Remove-Item Alias:mv
Set-Alias -Name mv -Value Move-Item
Remove-Item Alias:rm
Set-Alias -Name rm -Value Remove-Item
function mkdir {
  param(
      [string]$Path
  )

  New-Item -ItemType Directory -Path $Path
}
Remove-Item Alias:ps
Set-Alias -Name ps -Value Get-Process
Set-Alias -Name ping -Value Test-Connection
Set-Alias -Name less -Value Get-Content

function Get-Uptime {
  # Get the current system uptime
  $uptime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
  $uptime = (Get-Date) - $uptime

  # Format the uptime in a readable way
  $uptimeString = "{0} days, {1} hours, {2} minutes, {3} seconds" -f $uptime.Days, $uptime.Hours, $uptime.Minutes, $uptime.Seconds

  return $uptimeString
}
function df {
  get-volume
}
function sed($file, $find, $replace) {
  (Get-Content $file).replace("$find", $replace) | Set-Content $file
}
function which($name) {
  Get-Command $name | Select-Object -ExpandProperty Definition
}
function export($name, $value) {
  set-item -force -path "env:$name" -value $value;
}
function pkill($name) {
  Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}
function pgrep($name) {
  Get-Process $name
}