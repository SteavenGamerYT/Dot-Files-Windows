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