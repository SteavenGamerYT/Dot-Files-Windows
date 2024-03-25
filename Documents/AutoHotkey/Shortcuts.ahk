#x:: ; Win + X
Run, powershell.exe -Command "& {Start-Process wt.exe -Verb RunAs}"
return
#b:: ; Win + B
Run, "C:\Program Files\Google\Chrome\Application\chrome.exe"
return

#IfWinActive

; Define hotkey Win + Shift + Q to simulate Alt + F4
#+q:: 
    SendInput, {Alt down}{F4}{Alt up}
return

#IfWinActive


#Persistent

; Define a hotkey for Left Alt + Caps Lock
LAlt & CapsLock:: 
    Send, {LAlt Down}{LShift Down}{LShift Up}{LAlt Up}
return