# Dot Files Windows
 My Dot Files From Windows 10


![](https://github.com/SteavenGamerYT/dot-files-windows/blob/main/Screenshots/1.png?raw=true)

`Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser`

```
winget install starship
Install-Module PSWriteColor -Force
Install-Module PSColor -Force
Install-Module -Name Terminal-Icons -Repository PSGallery -Force
scoop install meow
```

```
rd /s /q "%USERPROFILE%\Documents\PowerShell"
rd /s /q "%USERPROFILE%\Documents\WindowsPowerShell"
mkdir "%USERPROFILE%\Documents\WindowsPowerShell"
mklink /d "%USERPROFILE%\Documents\WindowsPowerShell" "%USERPROFILE%\Documents\GitHub\Dot-Files-Windows\Documents\WindowsPowerShell"
mklink /d "%USERPROFILE%\Documents\PowerShell" "%USERPROFILE%\Documents\GitHub\Dot-Files-Windows\Documents\PowerShell"
rd /s /q "%USERPROFILE%\.config\starship.toml"
mkdir "%USERPROFILE%\.config"
mklink "%USERPROFILE%\.config\starship.toml" "%USERPROFILE%\Documents\GitHub\Dot-Files-Windows\.config\starship.toml"
del /s /q "%USERPROFILE%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
mkdir "%USERPROFILE%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
mklink "%USERPROFILE%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "%USERPROFILE%\Documents\GitHub\Dot-Files-Windows\AppData\local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
rd /s /q "%USERPROFILE%\AppData\Roaming\BetterDiscord"
mklink /d "%USERPROFILE%\AppData\Roaming\BetterDiscord" "%USERPROFILE%\Documents\GitHub\Dot-Files-Windows\AppData\Roaming\BetterDiscord"
mkdir "%USERPROFILE%\AppData\Roaming"
mklink /d "%USERPROFILE%\AppData\Roaming\BetterDiscord" "%USERPROFILE%\Documents\GitHub\Dot-Files-Windows\AppData\Roaming\BetterDiscord"
rd /s /q "%USERPROFILE%\.config\winfetch"
mklink /d "%USERPROFILE%\.config\winfetch" "%USERPROFILE%\Documents\GitHub\Dot-Files-Windows\.config\winfetch"
mklink /d "%USERPROFILE%\Documents\AutoHotkey" "%USERPROFILE%\Documents\GitHub\Dot-Files-Windows\Documents\AutoHotkey"
rd /s /q "%USERPROFILE%\.glaze-wm"
mklink /d "%USERPROFILE%\.glaze-wm" "%USERPROFILE%\Documents\GitHub\Dot-Files-Windows\.glaze-wm"
```