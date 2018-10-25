;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         cy18 <thecy18@gmail.com>
;
; An improved script to use space as modifier
; In normal cases, if space is pressed for more than 0.1 second, it becomes a modifier, this time could be modified in the script
; If no other keys are pressed during space is pressed, a space is output when space is released
; Severial tunes are made so that the script works well when typing in fast speed
; Note that repeating space no longer works

﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

AnyKeyPressedOtherThanSpace(mode = "P") {
    keys = 1234567890-=qwertyuiop[]\asdfghjkl;'zxcvbnm,./
    Loop, Parse, keys
    {
        isDown :=  GetKeyState(A_LoopField, mode)
        if(isDown)
            return True
    }

    return False
}


supressed := False
RestoreInput(){
    BlockInput, Off
    Global supressed
    supressed := False
}

SupressInput(){
    Global supressed
    supressed := True
    BlockInput, On
    SetTimer, RestoreInput, -180
}

ModifierStates := ""
UpdateModifierStates(){
    Global ModifierStates
    if (supressed){
        return
    }
    ModifierStates := ""

    if GetKeyState("LWin", "P") || GetKeyState("RWin", "P")    {
        ModifierStates .= "#"
    }

    if GetKeyState("Ctrl", "P"){
        ModifierStates .= "^"
    }

    if GetKeyState("Alt", "P"){
        ModifierStates .= "!"
    }

    if GetKeyState("Shift", "P"){
        ModifierStates .= "+"
    }
}

SendKey(Key, num=1){
    Global ModifierStates
    Loop, %num%{
        Send, %ModifierStates%%Key%
    }
}

ReleaseModifier(){
    global space_up
    if (not space_up){
        space_up := true
    }
    Send, {RControl}
}

Space Up::
    Send {Blind}{Space up}
    space_up := true
    SendEvent, {RControl}
    return
Space::
    if AnyKeyPressedOtherThanSpace(){
        SendInput, {Blind}{Space}
        Return
    }
    if (GetKeyState(LShift, mode)){
        SendInput ^{Space}
        Return
    }
    inputed := False
    space_up := False
    input, UserInput, L1 T0.05, {RControl}
    if (space_up) {
        Send, {Blind}{Space}
        return
    }else if (StrLen(UserInput) == 1){
        Send, {Space}%UserInput%
        return
    }
    SetTimer, ReleaseModifier, -18000
    while true{
        input, UserInput, L1, {RControl}
        if (space_up) {
            if (!inputed){
                Send, {Blind}{Space}
            }
            break
        }else{
            inputed := True
            StringLower, UserInput, UserInput
            UpdateModifierStates()
            SupressInput()
            if (UserInput == "e")
                SendKey("{Up}")
            else if (UserInput == "d")
                SendKey("{Down}")
            else if (UserInput == "s")
                SendKey("{Left}")
            else if (UserInput == "a"){
                if WinExist("ahk_exe atom.exe")
                    {
                    WinActivate, ahk_exe atom.exe
                    }
                else
                run, C:\Users\garyfan\AppData\Local\atom\atom.exe
            }else if (UserInput == "f")
                SendKey("{Right}")
            ;else if (UserInput == "g")
                ;SendKey("{Right}", 8)
            else if (UserInput == "w")
                SendKey("{Home}")
            else if (UserInput == "r")
                SendKey("{End}")
            else if (UserInput == "c"){
                if WinExist("ahk_exe chrome.exe")
                    {
                    WinActivate, ahk_exe chrome.exe
                    }
                else
                run, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
            }else if (UserInput == "x")
                SendKey("{BS}", 6)
            else if (UserInput == "v"){
                if WinExist("ahk_exe wechat.exe")
                    {
                    WinActivate, ahk_exe wechat.exe
                    }
                else
                run, C:\Program Files (x86)\Tencent\WeChat\wechat.exe
            }else if (UserInput == "b")
                SendKey("{DEL}")
            else if (UserInput == "t"){
                if WinExist("ahk_exe typora.exe")
                    {
                    WinActivate, ahk_exe typora.exe
                    }
                else
                run, C:\Program Files\Typora\Typora.exe
            }else if (UserInput == "8"){
                RestoreInput()
                break
            }else if (UserInput == "`t")
                SendKey(" ")
            else
                Send, {Blind}%UserInput%
        }
    }
    RestoreInput()
    return
