# Dot Files Windows
My Dot Files From Windows 11


![](https://github.com/SteavenGamerYT/dot-files-windows/blob/main/Screenshots/1.png?raw=true)

![](https://github.com/SteavenGamerYT/dot-files-windows/blob/main/Screenshots/2.png?raw=true)

![](https://github.com/SteavenGamerYT/dot-files-windows/blob/main/Screenshots/3.png?raw=true)


`Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser`

```
choco install wget curl ffmpeg-full yt-dlp mpv.install -y
winget install --id Microsoft.PowerShell
winget install --id Microsoft.WindowsTerminal
winget install --id Git.Git
winget install starship
winget install --id Fastfetch-cli.Fastfetch
winget install --id=hpjansson.Chafa
Install-Module PSWriteColor -Force
Install-Module PSColor -Force
Install-Module -Name Terminal-Icons -Repository PSGallery -Force
scoop install meow bat
```

```
rd /s /q "D:\Documents\PowerShell"
rd /s /q "D:\Documents\WindowsPowerShell"
mklink /d "D:\Documents\WindowsPowerShell" "D:\Documents\GitHub\Dot-Files-Windows\Documents\PowerShell"
mklink /d "D:\Documents\PowerShell" "D:\Documents\GitHub\Dot-Files-Windows\Documents\PowerShell"
rd /s /q "%USERPROFILE%\.config\starship.toml"
mkdir "%USERPROFILE%\.config"
mklink "%USERPROFILE%\.config\starship.toml" "D:\Documents\GitHub\Dot-Files-Windows\.config\starship.toml"
del /s /q "%localappdata%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
mkdir "%localappdata%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
mklink "%localappdata%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "D:\Documents\GitHub\Dot-Files-Windows\AppData\local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
rd /s /q "D:\AppData\Roaming\BetterDiscord"
mklink /d "D:\AppData\Roaming\BetterDiscord" "D:\Documents\GitHub\Dot-Files-Windows\AppData\Roaming\BetterDiscord"
mkdir "D:\AppData\Roaming"
mklink /d "D:\AppData\Roaming\BetterDiscord" "D:\Documents\GitHub\Dot-Files-Windows\AppData\Roaming\BetterDiscord"
rd /s /q "%USERPROFILE%\.config\winfetch"
mklink /d "%USERPROFILE%\.config\winfetch" "D:\Documents\GitHub\Dot-Files-Windows\.config\winfetch"
rd /s /q "%USERPROFILE%\.config\fastfetch"
mklink /d "%USERPROFILE%\.config\fastfetch" "D:\Documents\GitHub\Dot-Files-Windows\.config\fastfetch"
mklink /d "D:\Documents\AutoHotkey" "D:\Documents\GitHub\Dot-Files-Windows\Documents\AutoHotkey"
rd /s /q "%USERPROFILE%\.glaze-wm"
mklink /d "%USERPROFILE%\.glaze-wm" "D:\Documents\GitHub\Dot-Files-Windows\.glaze-wm"'
rd /s /q "%APPDATA%\alacritty"
mklink /d "%APPDATA%\alacritty" "D:\Documents\GitHub\Dot-Files-Windows\AppData\Roaming\alacritty"
```
