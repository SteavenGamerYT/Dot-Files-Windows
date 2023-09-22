# Dot Files Windows
 My Dot Files From Windows 10

`Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser`

```
rd /s /q mklink /d "C:\Users\Omar Hany Kasban\Documents\WindowsPowerShell"
mkdr mklink /d "C:\Users\Omar Hany Kasban\Documents\WindowsPowerShell"
mklink /d "C:\Users\Omar Hany Kasban\Documents\WindowsPowerShell" "C:\Users\Omar Hany Kasban\Documents\GitHub\Dot-Files-Windows\Documents\WindowsPowerShell"
mklink /d "C:\Users\Omar Hany Kasban\Documents\PowerShell" "C:\Users\Omar Hany Kasban\Documents\GitHub\Dot-Files-Windows\Documents\PowerShell"
rd /s /q "C:\Users\Omar Hany Kasban\.config\starship.toml"
mkdir "C:\Users\Omar Hany Kasban\.config"
mklink "C:\Users\Omar Hany Kasban\.config\starship.toml" "C:\Users\Omar Hany Kasban\Documents\GitHub\Dot-Files-Windows\.config\starship.toml"
rd /s /q "C:\Users\Omar Hany Kasban\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
mkdir "C:\Users\Omar Hany Kasban\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" 
mklink "C:\Users\Omar Hany Kasban\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "C:\Users\Omar Hany Kasban\Documents\GitHub\Dot-Files-Windows\AppData\local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
rd /s /q "C:\Users\Omar Hany Kasban\AppData\Roaming\BetterDiscord"
mkdir mklink /d "C:\Users\Omar Hany Kasban\AppData\Roaming"
mklink /d "C:\Users\Omar Hany Kasban\AppData\Roaming\BetterDiscord" "C:\Users\Omar Hany Kasban\Documents\GitHub\Dot-FileS-Windows\AppData\Roaming\BetterDiscord"
```