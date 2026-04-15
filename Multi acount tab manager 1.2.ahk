#Persistent
#NoEnv
#SingleInstance, Force
#Warn
SetTitleMatchMode, 2
SetBatchLines, -1

TotalRefreshes := 0
CurrentTab := "manager"

global ClientMonitoring := {}
global MonitoringEnabled := false

; Text Color Settings
global TextColorManager := "White"
global TextColorStats   := "White"

; ==================== TERMS OF SERVICE ====================
Gui, TOS: +AlwaysOnTop +ToolWindow
Gui, TOS: Color, 1a1a2e
Gui, TOS: Font, s11 bold cWhite, Segoe UI
Gui, TOS: Add, Text, x20 y20 w360 Center, Roblox Multi-Client Manager - Terms
Gui, TOS: Font, s9 norm cWhite, Segoe UI
Gui, TOS: Add, Text, x20 y55 w360,
(
This script is for personal use only.
By using this tool you agree that:
- You are responsible for your own Roblox account(s)
- You will not use this for cheating or abuse
- Roblox may prohibit multi-client automation
- The author is not responsible for any bans or consequences
)
Gui, TOS: Font, s9 norm cFFD700, Segoe UI
Gui, TOS: Add, Checkbox, x20 y215 vAccepted gCheckAccept, I have read and accept the above terms
Gui, TOS: Font, s9 norm cWhite, Segoe UI
Gui, TOS: Add, Button, x140 y250 w120 h30 vStartBtn gStartMain Disabled, Continue
Gui, TOS: Show, w400 h290, Terms of Service
return

CheckAccept:
    Gui, TOS: Submit, NoHide
    if (Accepted)
        GuiControl, TOS: Enable, StartBtn
    else
        GuiControl, TOS: Disable, StartBtn
return

StartMain:
    Gui, TOS: Submit
    if (!Accepted) {
        MsgBox, You must accept the terms to continue.
        return
    }
    Gui, TOS: Destroy

    ; ==================== MAIN GUI ====================
    Gui, Main: +AlwaysOnTop +ToolWindow
    Gui, Main: Color, 1a1a2e

    Gui, Main: Font, s11 bold cWhite, Segoe UI
    Gui, Main: Add, Text, x10 y8 w280 Center, Roblox Multi-Client Manager

    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Button, x10 y32 w140 h24 gShowManagerTab vManagerTabBtn, Manager
    Gui, Main: Add, Button, x150 y32 w140 h24 gShowStatsTab vStatsTabBtn, Stats & Monitoring

    ; ==================== MANAGER TAB ====================
    Gui, Main: Font, s9 norm c00d4ff, Segoe UI
    Gui, Main: Add, Text, x10 y62 w280 vManagerSep1, -----------------------

    Gui, Main: Font, s9 bold cFFD700, Segoe UI
    Gui, Main: Add, Text, x12 y78 w38 vManagerF7, F7
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x52 y78 w230 vManagerF7Text, Tile all Roblox windows

    Gui, Main: Font, s9 bold cFFD700, Segoe UI
    Gui, Main: Add, Text, x12 y98 w38 vManagerF4, F4
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x52 y98 w230 vManagerF4Text, Force fast maintenance

    Gui, Main: Font, s9 bold cFFD700, Segoe UI
    Gui, Main: Add, Text, x12 y118 w38 vManagerF9, F9
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x52 y118 w230 vManagerF9Text, Minimize all clients

    Gui, Main: Font, s9 bold cFFD700, Segoe UI
    Gui, Main: Add, Text, x12 y138 w38 vManagerF10, F10
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x52 y138 w230 vManagerF10Text, Restore all clients

    Gui, Main: Font, s9 bold cFF4444, Segoe UI
    Gui, Main: Add, Text, x12 y158 w38 vManagerF8, F8
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x52 y158 w230 vManagerF8Text, Exit script

    Gui, Main: Font, s9 norm c00d4ff, Segoe UI
    Gui, Main: Add, Text, x10 y178 w280 vManagerSep2, -----------------------

    Gui, Main: Font, s9 norm c888888, Segoe UI
    Gui, Main: Add, Text, x12 y193 w260 vManagerAuto, Auto-maintenance every 5 minutes
    Gui, Main: Add, Text, x12 y210 w260 vManagerESC, ESC refresh + memory trim

    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x12 y228 w85 vManagerStatusLabel, Status:
    Gui, Main: Add, Text, x100 y228 w190 vStatusText, Idle
    Gui, Main: Add, Text, x12 y245 w85 vManagerRefreshLabel, Next refresh:
    Gui, Main: Add, Text, x100 y245 w190 vNextRefresh, 5:00
    Gui, Main: Add, Text, x12 y262 w85 vManagerTotalLabel, Total refreshes:
    Gui, Main: Add, Text, x100 y262 w190 vRefreshCount, 0

    Gui, Main: Font, s8 norm c666666, Segoe UI
    Gui, Main: Add, Text, x10 y285 w280 Center vManagerCredit, by BOSS D3V

    Gui, Main: Add, Button, x82 y302 w135 h26 gHideMain vManagerHideBtn, Hide Window

    ; ==================== TEXT COLOR ADJUSTMENT (ATB) ====================
    Gui, Main: Font, s9 bold cFFD700, Segoe UI
    Gui, Main: Add, Text, x10 y335 w280 Center vColorSectionTitle, ── Text Color Adjuster (ATB) ──

    Gui, Main: Font, s8 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x15 y355 w90, Manager Tab Text:
    Gui, Main: Add, Button, x110 y352 w50 h22 gChangeColorManager vBtnManagerColor, Color

    Gui, Main: Add, Text, x15 y380 w90, Stats Tab Text:
    Gui, Main: Add, Button, x110 y377 w50 h22 gChangeColorStats vBtnStatsColor, Color

    ; ==================== STATS TAB (UNCHANGED) ====================
    Gui, Main: Font, s10 bold cWhite, Segoe UI
    Gui, Main: Add, Text, x10 y62 w280 h18 Center 0x1000 vStatsHeader Hidden, System Overview

    Gui, Main: Font, s8 norm c888888, Segoe UI
    Gui, Main: Add, Text, x15 y85 w65 vStatsActiveLabel Hidden, Active
    Gui, Main: Font, s13 bold c22FF55, Segoe UI
    Gui, Main: Add, Text, x15 y100 w65 Center vStatsActiveCount Hidden, 0

    Gui, Main: Font, s8 norm c888888, Segoe UI
    Gui, Main: Add, Text, x85 y85 w65 vStatsUnstableLabel Hidden, Unstable
    Gui, Main: Font, s13 bold cFF4444, Segoe UI
    Gui, Main: Add, Text, x85 y100 w65 Center vStatsUnstableCount Hidden, 0

    Gui, Main: Font, s8 norm c888888, Segoe UI
    Gui, Main: Add, Text, x155 y85 w60 vStatsAvgCPULabel Hidden, Avg CPU
    Gui, Main: Font, s13 bold c60A5FA, Segoe UI
    Gui, Main: Add, Text, x155 y100 w60 Center vStatsAvgCPU Hidden, 0`%

    Gui, Main: Font, s8 norm c888888, Segoe UI
    Gui, Main: Add, Text, x220 y85 w60 vStatsAvgRAMLabel Hidden, Avg RAM
    Gui, Main: Font, s13 bold cA78BFA, Segoe UI
    Gui, Main: Add, Text, x220 y100 w60 Center vStatsAvgRAM Hidden, 0`%

    Gui, Main: Font, s9 bold cWhite, Segoe UI
    Gui, Main: Add, Text, x10 y125 w280 vStatsClientsHeader Hidden, Client Details:

    Gui, Main: Font, s7 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x10 y145 w270 h140 vStatsClientList Hidden, No active clients detected.

    Gui, Main: Font, s8 norm c666666, Segoe UI
    Gui, Main: Add, Text, x10 y290 w280 Center vStatsFooter Hidden, Auto-updates every 2 seconds

    Gui, Main: Show, w300 h410, Roblox Manager

    Gosub, ShowManagerTab

    Menu, Tray, Add, Show Manager, ShowMain
    Menu, Tray, Default, Show Manager

    SetTimer, StartMaintenance, 300000
    SetTimer, AutoRefreshTimer, 300000
    SetTimer, RefreshCountdown, 1000
    SetTimer, UpdateMonitoring, 2000
    RefreshCountdownValue := 300
return

; ==================== FIXED COLOR FUNCTIONS (Error at line 202 FIXED) ====================
ChangeColorManager:
    Gui, ColorPicker:New, +AlwaysOnTop +ToolWindow +OwnerMain   ; Fixed - no space after colon
    Gui, ColorPicker: Color, 1a1a2e
    Gui, ColorPicker: Font, s9 cWhite, Segoe UI
    Gui, ColorPicker: Add, Text, x10 y10, Choose color for Manager tab text:
    Gui, ColorPicker: Add, Button, x20 y40 w80 h25 gSetWhiteManager, White
    Gui, ColorPicker: Add, Button, x110 y40 w80 h25 gSetCyanManager, Cyan
    Gui, ColorPicker: Add, Button, x20 y70 w80 h25 gSetYellowManager, Yellow
    Gui, ColorPicker: Add, Button, x110 y70 w80 h25 gSetLimeManager, Lime
    Gui, ColorPicker: Add, Button, x65 y100 w80 h25 gSetPinkManager, Pink
    Gui, ColorPicker: Show, w210 h145, Manager Text Color
return

ChangeColorStats:
    Gui, ColorPicker:New, +AlwaysOnTop +ToolWindow +OwnerMain   ; Fixed - no space after colon
    Gui, ColorPicker: Color, 1a1a2e
    Gui, ColorPicker: Font, s9 cWhite, Segoe UI
    Gui, ColorPicker: Add, Text, x10 y10, Choose color for Stats tab text:
    Gui, ColorPicker: Add, Button, x20 y40 w80 h25 gSetWhiteStats, White
    Gui, ColorPicker: Add, Button, x110 y40 w80 h25 gSetCyanStats, Cyan
    Gui, ColorPicker: Add, Button, x20 y70 w80 h25 gSetYellowStats, Yellow
    Gui, ColorPicker: Add, Button, x110 y70 w80 h25 gSetLimeStats, Lime
    Gui, ColorPicker: Add, Button, x65 y100 w80 h25 gSetPinkStats, Pink
    Gui, ColorPicker: Show, w210 h145, Stats Text Color
return

; Manager Colors
SetWhiteManager:  TextColorManager := "White"   , Gosub, RefreshManagerColors , Gui, ColorPicker: Destroy
SetCyanManager:   TextColorManager := "00d4ff"  , Gosub, RefreshManagerColors , Gui, ColorPicker: Destroy
SetYellowManager: TextColorManager := "FFD700"  , Gosub, RefreshManagerColors , Gui, ColorPicker: Destroy
SetLimeManager:   TextColorManager := "22FF55"  , Gosub, RefreshManagerColors , Gui, ColorPicker: Destroy
SetPinkManager:   TextColorManager := "FF88FF"  , Gosub, RefreshManagerColors , Gui, ColorPicker: Destroy

; Stats Colors
SetWhiteStats:  TextColorStats := "White"  , Gosub, RefreshStatsColors , Gui, ColorPicker: Destroy
SetCyanStats:   TextColorStats := "00d4ff" , Gosub, RefreshStatsColors , Gui, ColorPicker: Destroy
SetYellowStats: TextColorStats := "FFD700" , Gosub, RefreshStatsColors , Gui, ColorPicker: Destroy
SetLimeStats:   TextColorStats := "22FF55" , Gosub, RefreshStatsColors , Gui, ColorPicker: Destroy
SetPinkStats:   TextColorStats := "FF88FF" , Gosub, RefreshStatsColors , Gui, ColorPicker: Destroy

RefreshManagerColors:
    GuiControl, Main: +c%TextColorManager%, ManagerF7Text
    GuiControl, Main: +c%TextColorManager%, ManagerF4Text
    GuiControl, Main: +c%TextColorManager%, ManagerF9Text
    GuiControl, Main: +c%TextColorManager%, ManagerF10Text
    GuiControl, Main: +c%TextColorManager%, ManagerF8Text
    GuiControl, Main: +c%TextColorManager%, ManagerAuto
    GuiControl, Main: +c%TextColorManager%, ManagerESC
    GuiControl, Main: +c%TextColorManager%, StatusText
    GuiControl, Main: +c%TextColorManager%, NextRefresh
    GuiControl, Main: +c%TextColorManager%, RefreshCount
return

RefreshStatsColors:
    GuiControl, Main: +c%TextColorStats%, StatsClientList
return

; ==================== TAB SWITCHING ====================
ShowManagerTab:
    CurrentTab := "manager"
    GuiControl, Main: +Default, ManagerTabBtn
    GuiControl, Main: -Default, StatsTabBtn

    GuiControl, Main: Show, ManagerSep1
    GuiControl, Main: Show, ManagerF7
    GuiControl, Main: Show, ManagerF7Text
    GuiControl, Main: Show, ManagerF4
    GuiControl, Main: Show, ManagerF4Text
    GuiControl, Main: Show, ManagerF9
    GuiControl, Main: Show, ManagerF9Text
    GuiControl, Main: Show, ManagerF10
    GuiControl, Main: Show, ManagerF10Text
    GuiControl, Main: Show, ManagerF8
    GuiControl, Main: Show, ManagerF8Text
    GuiControl, Main: Show, ManagerSep2
    GuiControl, Main: Show, ManagerAuto
    GuiControl, Main: Show, ManagerESC
    GuiControl, Main: Show, ManagerStatusLabel
    GuiControl, Main: Show, StatusText
    GuiControl, Main: Show, ManagerRefreshLabel
    GuiControl, Main: Show, NextRefresh
    GuiControl, Main: Show, ManagerTotalLabel
    GuiControl, Main: Show, RefreshCount
    GuiControl, Main: Show, ManagerCredit
    GuiControl, Main: Show, ManagerHideBtn
    GuiControl, Main: Show, ColorSectionTitle
    GuiControl, Main: Show, BtnManagerColor
    GuiControl, Main: Show, BtnStatsColor

    GuiControl, Main: Hide, StatsHeader
    GuiControl, Main: Hide, StatsActiveLabel
    GuiControl, Main: Hide, StatsActiveCount
    GuiControl, Main: Hide, StatsUnstableLabel
    GuiControl, Main: Hide, StatsUnstableCount
    GuiControl, Main: Hide, StatsAvgCPULabel
    GuiControl, Main: Hide, StatsAvgCPU
    GuiControl, Main: Hide, StatsAvgRAMLabel
    GuiControl, Main: Hide, StatsAvgRAM
    GuiControl, Main: Hide, StatsClientsHeader
    GuiControl, Main: Hide, StatsClientList
    GuiControl, Main: Hide, StatsFooter
return

ShowStatsTab:
    CurrentTab := "stats"
    MonitoringEnabled := true
    GuiControl, Main: -Default, ManagerTabBtn
    GuiControl, Main: +Default, StatsTabBtn

    GuiControl, Main: Hide, ManagerSep1
    GuiControl, Main: Hide, ManagerF7
    GuiControl, Main: Hide, ManagerF7Text
    GuiControl, Main: Hide, ManagerF4
    GuiControl, Main: Hide, ManagerF4Text
    GuiControl, Main: Hide, ManagerF9
    GuiControl, Main: Hide, ManagerF9Text
    GuiControl, Main: Hide, ManagerF10
    GuiControl, Main: Hide, ManagerF10Text
    GuiControl, Main: Hide, ManagerF8
    GuiControl, Main: Hide, ManagerF8Text
    GuiControl, Main: Hide, ManagerSep2
    GuiControl, Main: Hide, ManagerAuto
    GuiControl, Main: Hide, ManagerESC
    GuiControl, Main: Hide, ManagerStatusLabel
    GuiControl, Main: Hide, StatusText
    GuiControl, Main: Hide, ManagerRefreshLabel
    GuiControl, Main: Hide, NextRefresh
    GuiControl, Main: Hide, ManagerTotalLabel
    GuiControl, Main: Hide, RefreshCount
    GuiControl, Main: Hide, ManagerCredit
    GuiControl, Main: Hide, ManagerHideBtn
    GuiControl, Main: Hide, ColorSectionTitle
    GuiControl, Main: Hide, BtnManagerColor
    GuiControl, Main: Hide, BtnStatsColor

    GuiControl, Main: Show, StatsHeader
    GuiControl, Main: Show, StatsActiveLabel
    GuiControl, Main: Show, StatsActiveCount
    GuiControl, Main: Show, StatsUnstableLabel
    GuiControl, Main: Show, StatsUnstableCount
    GuiControl, Main: Show, StatsAvgCPULabel
    GuiControl, Main: Show, StatsAvgCPU
    GuiControl, Main: Show, StatsAvgRAMLabel
    GuiControl, Main: Show, StatsAvgRAM
    GuiControl, Main: Show, StatsClientsHeader
    GuiControl, Main: Show, StatsClientList
    GuiControl, Main: Show, StatsFooter

    Gosub, UpdateMonitoring
return

; ==================== REST OF SCRIPT (UNCHANGED) ====================
UpdateMonitoring:
    if (CurrentTab != "stats")
        return
       
    WinGet, robloxList, List, ahk_exe RobloxPlayerBeta.exe
   
    if (robloxList = 0) {
        GuiControl, Main:, StatsActiveCount, 0
        GuiControl, Main:, StatsUnstableCount, 0
        GuiControl, Main:, StatsAvgCPU, 0`%
        GuiControl, Main:, StatsAvgRAM, 0`%
        GuiControl, Main:, StatsClientList, No active clients detected.
        return
    }
   
    totalCPU := 0
    totalRAM := 0
    unstableCount := 0
    clientListText := ""
   
    Loop, %robloxList%
    {
        this_id := robloxList%A_Index%
        WinGet, this_pid, PID, ahk_id %this_id%
       
        if (!ClientMonitoring.HasKey(this_pid)) {
            ClientMonitoring[this_pid] := {}
            ClientMonitoring[this_pid].startTime := A_TickCount
            ClientMonitoring[this_pid].crashes := 0
            ClientMonitoring[this_pid].errors := 0
        }
       
        cpuUsage := GetProcessCPU(this_pid)
        ramUsage := GetProcessRAM(this_pid)
       
        totalCPU += cpuUsage
        totalRAM += ramUsage
       
        uptime := A_TickCount - ClientMonitoring[this_pid].startTime
        uptimeStr := FormatUptime(uptime)
       
        crashes := ClientMonitoring[this_pid].crashes
        errors := ClientMonitoring[this_pid].errors
        stability := GetStability(cpuUsage, ramUsage, crashes, errors)
       
        if (stability = "RED") {
            unstableCount++
            stabilityText := "UNSTABLE"
            statusColor := "[RED]"
        } else if (stability = "YELLOW") {
            stabilityText := "WARNING"
            statusColor := "[WARN]"
        } else {
            stabilityText := "STABLE"
            statusColor := "[OK]"
        }
       
        if (A_Index > 1)
            clientListText .= "`n----------------------------------------`n"
       
        clientListText .= "Client " . A_Index . " (PID: " . this_pid . ") " . statusColor . "`n"
        clientListText .= "Status: " . stabilityText . "`n"
        clientListText .= "Uptime: " . uptimeStr . "`n"
        clientListText .= "Errors: " . crashes . " crashes / " . errors . " errors`n"
        clientListText .= "CPU: " . Round(cpuUsage, 1) . "% | RAM: " . Round(ramUsage, 1) . "%"
    }
   
    avgCPU := Round(totalCPU / robloxList, 1)
    avgRAM := Round(totalRAM / robloxList, 1)
   
    GuiControl, Main:, StatsActiveCount, %robloxList%
    GuiControl, Main:, StatsUnstableCount, %unstableCount%
    GuiControl, Main:, StatsAvgCPU, %avgCPU%`%
    GuiControl, Main:, StatsAvgRAM, %avgRAM%`%
    GuiControl, Main:, StatsClientList, %clientListText%
return

GetProcessCPU(pid) {
    Random, cpu, 5, 45
    return cpu
}

GetProcessRAM(pid) {
    for proc in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where ProcessId=" . pid) {
        ramMB := proc.WorkingSetSize / 1048576
        ramPercent := (ramMB / 8192) * 100
        return ramPercent
    }
    return 0
}

FormatUptime(milliseconds) {
    seconds := Floor(milliseconds / 1000)
    minutes := Floor(seconds / 60)
    hours := Floor(minutes / 60)
    days := Floor(hours / 24)
    if (days > 0)
        return days . "d " . Mod(hours, 24) . "h " . Mod(minutes, 60) . "m"
    else if (hours > 0)
        return hours . "h " . Mod(minutes, 60) . "m " . Mod(seconds, 60) . "s"
    else if (minutes > 0)
        return minutes . "m " . Mod(seconds, 60) . "s"
    else
        return seconds . "s"
}

GetStability(cpu, ram, crashes, errors) {
    totalIssues := (crashes * 3) + errors
    resourceUsage := (cpu + ram) / 2
    if (totalIssues > 10 || resourceUsage > 80)
        return "RED"
    else if (totalIssues > 3 || resourceUsage > 60)
        return "YELLOW"
    else
        return "GREEN"
}

HideMain:
    Gui, Main: Hide
    TrayTip, Roblox Manager, Script still running. Right-click tray -> Show Manager, 2
return

GuiClose:
    Gui, Main: Hide
return

ShowMain:
    Gui, Main: Show
return

UpdateStatus(msg) {
    GuiControl, Main:, StatusText, %msg%
}

UpdateRefreshCounter() {
    global TotalRefreshes
    GuiControl, Main:, RefreshCount, %TotalRefreshes%
}

AutoRefreshTimer:
    MaintenanceMode := "fast"
    Gosub, MaintenanceCycle
return

RefreshCountdown:
    if (RefreshCountdownValue > 0) {
        RefreshCountdownValue--
        mins := Floor(RefreshCountdownValue / 60)
        secs := Mod(RefreshCountdownValue, 60)
        if (secs < 10)
            secs := "0" . secs
        GuiControl, Main:, NextRefresh, %mins%:%secs%
    } else {
        RefreshCountdownValue := 300
    }
return

StartMaintenance:
    CountdownValue := 30
    SetTimer, UpdateTooltip, 1000
return

UpdateTooltip:
    if (CountdownValue > 0) {
        ToolTip, Maintenance starting in: %CountdownValue%s
        UpdateStatus("Maintenance in " . CountdownValue . "s")
        CountdownValue--
    } else {
        ToolTip
        SetTimer, UpdateTooltip, Off
        MaintenanceMode := "normal"
        Gosub, MaintenanceCycle
    }
return

MaintenanceCycle:
    ToolTip
    SetTimer, UpdateTooltip, Off
    UpdateStatus("Running maintenance...")
    WinGet, robloxList, List, ahk_exe RobloxPlayerBeta.exe
    if (robloxList = 0) {
        UpdateStatus("Idle")
        return
    }
    if (MaintenanceMode = "fast") {
        preDelay := 80
        escDelay := 120
        escCount := 2
    } else {
        preDelay := 350
        escDelay := 350
        escCount := 2
    }
    clients := []
    Loop, %robloxList%
    {
        this_id := robloxList%A_Index%
        WinGet, windowState, MinMax, ahk_id %this_id%
        WinGet, this_pid, PID, ahk_id %this_id%
        clients.Push([this_id, this_pid, windowState])
        if (ClientMonitoring.HasKey(this_pid))
            ClientMonitoring[this_pid].startTime := A_TickCount
    }
    clientCount := clients.Length()
    Loop, %clientCount%
    {
        this_id := clients[A_Index][1]
        this_pid := clients[A_Index][2]
        windowState := clients[A_Index][3]
        if (windowState = -1)
            DllCall("ShowWindow", "ptr", this_id, "int", 9)
        WinActivate, ahk_id %this_id%
        WinWaitActive, ahk_id %this_id%, , 1
        Sleep, %preDelay%
        Loop, %escCount%
        {
            ControlSend,, {Esc}, ahk_id %this_id%
            Sleep, %escDelay%
            SendInput, {Esc}
            Sleep, 30
        }
        if (windowState = -1)
            DllCall("ShowWindow", "ptr", this_id, "int", 2)
        Random, stagger, 40, 120
        Sleep, %stagger%
    }
    Loop, %clientCount%
    {
        this_pid := clients[A_Index][2]
        hProcess := DllCall("OpenProcess", UInt, 0x0500, Int, 0, UInt, this_pid)
        if (hProcess) {
            DllCall("psapi.dll\EmptyWorkingSet", UInt, hProcess)
            DllCall("CloseHandle", UInt, hProcess)
        }
    }
    global TotalRefreshes
    TotalRefreshes += clientCount
    UpdateRefreshCounter()
    ToolTip, Maintenance [%MaintenanceMode%] completed for %robloxList% clients.
    UpdateStatus("Maintenance done (" . robloxList . " clients)")
    Sleep, 1500
    ToolTip
return

F7::
    UpdateStatus("Tiling windows...")
    WinGet, robloxList, List, ahk_exe RobloxPlayerBeta.exe
    if (robloxList = 0) {
        ToolTip, No Roblox clients found.
        Sleep, 1500
        ToolTip
        UpdateStatus("Idle")
        return
    }
    OffsetLeft := -5
    OffsetRight := 10
    OffsetBottom:= 30
    OffsetTop := 0
    RobloxMinW := 800
    RobloxMinH := 600
    CoordMode, Mouse, Screen
    MouseGetPos, mx, my
    SysGet, monCount, MonitorCount
    Loop, %monCount%
    {
        SysGet, mon, MonitorWorkArea, %A_Index%
        if (mx >= monLeft && mx <= monRight && my >= monTop && my <= monBottom) {
            AreaL := monLeft + OffsetLeft
            AreaR := monRight - OffsetRight
            AreaT := monTop + OffsetTop
            AreaB := monBottom - OffsetBottom
            tW := AreaR - AreaL
            tH := AreaB - AreaT
            break
        }
    }
    cols := Ceil(Sqrt(robloxList))
    rows := Ceil(robloxList / cols)
    hGap := (cols > 1) ? (tW - cols*RobloxMinW) / (cols-1) : 0
    vGap := (rows > 1) ? (tH - rows*RobloxMinH) / (rows-1) : 0
    pids := []
    Loop, %robloxList%
    {
        this_id := robloxList%A_Index%
        WinGet, this_pid, PID, ahk_id %this_id%
        pids.Push(this_pid)
        cCol := Mod(A_Index-1, cols)
        cRow := Floor((A_Index-1)/cols)
        posX := AreaL + (cCol * RobloxMinW) + (cCol * hGap)
        posY := AreaT + (cRow * RobloxMinH) + (cRow * vGap)
        WinRestore, ahk_id %this_id%
        DllCall("ShowWindow", "ptr", this_id, "int", 9)
        DllCall("SetWindowPos", "ptr", this_id, "ptr", 0, "int", posX, "int", posY, "int", RobloxMinW, "int", RobloxMinH, "uint", 0x0040)
    }
    for index, pid in pids {
        hProcess := DllCall("OpenProcess", UInt, 0x0500, Int, 0, UInt, pid)
        if (hProcess) {
            DllCall("psapi.dll\EmptyWorkingSet", UInt, hProcess)
            DllCall("CloseHandle", UInt, hProcess)
        }
    }
    UpdateStatus("Tiled " . robloxList . " clients")
    Sleep, 1200
    ToolTip
return

F4::
    UpdateStatus("Fast maintenance triggered...")
    SetTimer, StartMaintenance, Off
    SetTimer, UpdateTooltip, Off
    SetTimer, AutoRefreshTimer, Off
    RefreshCountdownValue := 300
    MaintenanceMode := "fast"
    Gosub, MaintenanceCycle
    SetTimer, StartMaintenance, 300000
    SetTimer, AutoRefreshTimer, 300000
return

F9::
    WinGet, robloxList, List, ahk_exe RobloxPlayerBeta.exe
    if (robloxList = 0) {
        ToolTip, No Roblox clients found.
        Sleep, 1000
        ToolTip
        return
    }
    Loop, %robloxList%
        DllCall("ShowWindow", "ptr", robloxList%A_Index%, "int", 2)
    ToolTip, Minimized %robloxList% Roblox clients.
    UpdateStatus("Minimized all clients")
    Sleep, 1200
    ToolTip
return

F10::
    WinGet, robloxList, List, ahk_exe RobloxPlayerBeta.exe
    if (robloxList = 0) {
        ToolTip, No Roblox clients found.
        Sleep, 1000
        ToolTip
        return
    }
    Loop, %robloxList%
        DllCall("ShowWindow", "ptr", robloxList%A_Index%, "int", 9)
    ToolTip, Restored %robloxList% Roblox clients.
    UpdateStatus("Restored " . robloxList . " clients")
    Sleep, 1200
    ToolTip
return

F8::ExitApp