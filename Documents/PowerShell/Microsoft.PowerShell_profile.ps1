Invoke-Expression (&starship init powershell)
Set-Location "C:\Users\Omar Hany Kasban"
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
function ll { Get-ChildItem -Path $pwd -File }

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
function youtube-download($name) {
  yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --embed-metadata --embed-thumbnail --embed-chapters $name
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
    
    Get-ChildItem $path -Force | ForEach-Object {
        if ($_.PSIsContainer) {
            $size += Get-FolderSize $_.FullName
        } else {
            $size += $_.Length
        }
    }
    
    return $size
}

Get-ChildItem -Directory -Force | ForEach-Object {
    $item = $_
    $mode = $item.Mode
    $size = Get-FolderSize $item.FullName
    $time = $item.LastWriteTime.ToString("hh:mm tt")  # Format time as 12-hour clock

    $suffixes = "B", "KB", "MB", "GB", "TB"
    $index = 0

    while ($size -ge 1KB -and $index -lt $suffixes.Length) {
        $size /= 1KB
        $index++
    }

    Write-Color -Text $mode -ForegroundColor Green -NoNewline
    Write-Color -Text " $time" -NoNewline
    Write-Color -Text (" {0:N2} {1}" -f $size, $suffixes[$index]) -ForegroundColor Cyan -NoNewline
    Write-Color -Text " " -NoNewline  # Add space after size
    Write-Color -Text $item.Name
}
}