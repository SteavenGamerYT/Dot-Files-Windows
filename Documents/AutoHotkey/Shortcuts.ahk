; Load DLL
hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", "VirtualDesktopAccessor.dll", "Ptr")
GoToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GoToDesktopNumber", "Ptr")

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

#d::
Send, #!{Space}
return



; Function
GoToDesktopNumber(num) {
    global GoToDesktopNumberProc
    DllCall(GoToDesktopNumberProc, "Int", num, "Int")
}

; Hotkeys Win+1 to Win+0 (0 is actually number 9 in key layout, but we'll map it to desktop 9)
#1::GoToDesktopNumber(0)
#2::GoToDesktopNumber(1)
#3::GoToDesktopNumber(2)
#4::GoToDesktopNumber(3)
#5::GoToDesktopNumber(4)
#6::GoToDesktopNumber(5)
#7::GoToDesktopNumber(6)
#8::GoToDesktopNumber(7)
#9::GoToDesktopNumber(8)
#0::GoToDesktopNumber(9)