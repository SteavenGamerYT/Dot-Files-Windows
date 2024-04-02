RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation, 1


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


#Persistent
#InstallKeybdHook
#UseHook

#IfWinNotActive ahk_class Shell_TrayWnd
{
    #1::Send {Alt Down}1{Alt Up}
    #2::Send {Alt Down}2{Alt Up}
    #3::Send {Alt Down}3{Alt Up}
    #4::Send {Alt Down}4{Alt Up}
    #5::Send {Alt Down}5{Alt Up}
    #6::Send {Alt Down}6{Alt Up}
    #7::Send {Alt Down}7{Alt Up}
    #8::Send {Alt Down}8{Alt Up}
    #9::Send {Alt Down}9{Alt Up}
    #0::Send {Alt Down}0{Alt Up}

}

~LAlt & 1::Send {Alt Down}1{Alt Up}
~LAlt & 2::Send {Alt Down}2{Alt Up}
~LAlt & 3::Send {Alt Down}3{Alt Up}
~LAlt & 4::Send {Alt Down}4{Alt Up}
~LAlt & 5::Send {Alt Down}5{Alt Up}
~LAlt & 6::Send {Alt Down}6{Alt Up}
~LAlt & 7::Send {Alt Down}7{Alt Up}
~LAlt & 8::Send {Alt Down}8{Alt Up}
~LAlt & 9::Send {Alt Down}9{Alt Up}
~LAlt & 0::Send {Alt Down}0{Alt Up}


#Left::
    Send, {LAlt Down}{Left}{LAlt Up}
    return

#Right::
    Send, {LAlt Down}{Right}{LAlt Up}
    return

#Up::
    Send, {LAlt Down}{Up}{LAlt Up}
    return

#Down::
    Send, {LAlt Down}{Down}{LAlt Up}
    return



; Define hotkey Win + Shift + Left to simulate Alt + Shift + Left
#+Left::
    SendInput, {LAlt down}{LShift down}{Left}{LShift up}{LAlt up}
return

; Define hotkey Win + Shift + Right to simulate Alt + Shift + Right
#+Right::
    SendInput, {LAlt down}{LShift down}{Right}{LShift up}{LAlt up}
return

; Define hotkey Win + Shift + Up to simulate Alt + Shift + Up
#+Up::
    SendInput, {LAlt down}{LShift down}{Up}{LShift up}{LAlt up}
return

; Define hotkey Win + Shift + Down to simulate Alt + Shift + Down
#+Down::
    SendInput, {LAlt down}{LShift down}{Down}{LShift up}{LAlt up}
return
