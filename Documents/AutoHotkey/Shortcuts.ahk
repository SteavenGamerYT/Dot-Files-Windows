#Enter:: ; Win + Enter
Run, powershell.exe -Command "& {Start-Process wt.exe -Verb RunAs}"
return

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

; Define a hotkey for Win + z
#z::
Run explorer.exe
return


#Persistent

Toggle := False

#Persistent

Toggle := False

#space::
if (Toggle) {
    WinRestore, A
    Toggle := False
} else {
    WinGet, Style, Style, A
    if (Style & 0xC40000) {
        WinSet, Style, -0xC40000, A
    } else {
        WinMaximize, A
        WinSet, Style, +0xC40000, A
    }
    Toggle := True
}
return

#Persistent

Toggle := False

#f::
if (Toggle) {
    WinRestore, A
    Toggle := False
} else {
    WinGet, Style, Style, A
    if (Style & 0xC40000) {
        WinSet, Style, -0xC40000, A
    } else {
        WinMaximize, A
        WinSet, Style, +0xC40000, A
    }
    Toggle := True
}
Send, {F11}
return
