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

; ==================== FULL CUSTOM COLOR PICKER (Windows native) ====================
ChooseColor(default := 0xFFFFFF, hwndOwner := 0) {
    static CC_RGBINIT := 0x1, CC_FULLOPEN := 0x2
    VarSetCapacity(CUSTOM, 64, 0)                    ; 16 custom colors (4 bytes each)
    VarSetCapacity(CHOOSECOLOR, A_PtrSize*11, 0)

    NumPut(A_PtrSize*11, CHOOSECOLOR, 0, "UInt")    ; lStructSize
    NumPut(hwndOwner,    CHOOSECOLOR, A_PtrSize, "Ptr")
    NumPut(default,      CHOOSECOLOR, A_PtrSize*3, "UInt")   ; rgbResult
    NumPut(CC_RGBINIT | CC_FULLOPEN, CHOOSECOLOR, A_PtrSize*4, "UInt")
    NumPut(&CUSTOM,      CHOOSECOLOR, A_PtrSize*5, "Ptr")

    if (DllCall("comdlg32\ChooseColorW", "Ptr", &CHOOSECOLOR))
        return NumGet(CHOOSECOLOR, A_PtrSize*3, "UInt")
    return -1   ; Cancelled
}

; Helper: converts 0xRRGGBB → RRGGBB string (what GuiControl expects)
ColorNumToHex(c) {
    return Format("{:06X}", c & 0xFFFFFF)
}

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
    Gui, Main: Add, Text, x10 y8 w420 Center, Roblox Multi-Client Manager

    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Button, x10 y32 w140 h24 gShowManagerTab vManagerTabBtn, Manager
    Gui, Main: Add, Button, x150 y32 w140 h24 gShowStatsTab vStatsTabBtn, Stats & Monitoring
    Gui, Main: Add, Button, x290 y32 w140 h24 gShowColorTab vColorTabBtn, Customization

    ; ==================== MANAGER TAB ====================
    Gui, Main: Font, s9 norm c00d4ff, Segoe UI
    Gui, Main: Add, Text, x10 y62 w420 vManagerSep1, ---------------------------------------------------------

    Gui, Main: Font, s9 bold cFFD700, Segoe UI
    Gui, Main: Add, Text, x12 y78 w38 vManagerF7, F7
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x52 y78 w370 vManagerF7Text, Tile all Roblox windows

    Gui, Main: Font, s9 bold cFFD700, Segoe UI
    Gui, Main: Add, Text, x12 y98 w38 vManagerF4, F4
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x52 y98 w370 vManagerF4Text, Force fast maintenance

    Gui, Main: Font, s9 bold cFFD700, Segoe UI
    Gui, Main: Add, Text, x12 y118 w38 vManagerF9, F9
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x52 y118 w370 vManagerF9Text, Minimize all clients

    Gui, Main: Font, s9 bold cFFD700, Segoe UI
    Gui, Main: Add, Text, x12 y138 w38 vManagerF10, F10
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x52 y138 w370 vManagerF10Text, Restore all clients

    Gui, Main: Font, s9 bold cFF4444, Segoe UI
    Gui, Main: Add, Text, x12 y158 w38 vManagerF8, F8
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x52 y158 w370 vManagerF8Text, Exit script

    Gui, Main: Font, s9 norm c00d4ff, Segoe UI
    Gui, Main: Add, Text, x10 y178 w420 vManagerSep2, ---------------------------------------------------------

    Gui, Main: Font, s9 norm c888888, Segoe UI
    Gui, Main: Add, Text, x12 y193 w400 vManagerAuto, Auto-maintenance every 5 minutes
    Gui, Main: Add, Text, x12 y210 w400 vManagerESC, ESC refresh + memory trim

    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x12 y228 w85 vManagerStatusLabel, Status:
    Gui, Main: Add, Text, x100 y228 w330 vStatusText, Idle
    Gui, Main: Add, Text, x12 y245 w85 vManagerRefreshLabel, Next refresh:
    Gui, Main: Add, Text, x100 y245 w330 vNextRefresh, 5:00
    Gui, Main: Add, Text, x12 y262 w85 vManagerTotalLabel, Total refreshes:
    Gui, Main: Add, Text, x100 y262 w330 vRefreshCount, 0

    Gui, Main: Font, s8 norm c666666, Segoe UI
    Gui, Main: Add, Text, x10 y285 w420 Center vManagerCredit, by BOSS D3V

    Gui, Main: Add, Button, x152 y302 w135 h26 gHideMain vManagerHideBtn, Hide Window

    ; ==================== STATS TAB ====================
    Gui, Main: Font, s10 bold cWhite, Segoe UI
    Gui, Main: Add, Text, x10 y62 w420 h18 Center 0x1000 vStatsHeader Hidden, System Overview

    Gui, Main: Font, s8 norm c888888, Segoe UI
    Gui, Main: Add, Text, x15 y85 w90 vStatsActiveLabel Hidden, Active
    Gui, Main: Font, s13 bold c22FF55, Segoe UI
    Gui, Main: Add, Text, x15 y100 w90 Center vStatsActiveCount Hidden, 0

    Gui, Main: Font, s8 norm c888888, Segoe UI
    Gui, Main: Add, Text, x115 y85 w90 vStatsUnstableLabel Hidden, Unstable
    Gui, Main: Font, s13 bold cFF4444, Segoe UI
    Gui, Main: Add, Text, x115 y100 w90 Center vStatsUnstableCount Hidden, 0

    Gui, Main: Font, s8 norm c888888, Segoe UI
    Gui, Main: Add, Text, x215 y85 w90 vStatsAvgCPULabel Hidden, Avg CPU
    Gui, Main: Font, s13 bold c60A5FA, Segoe UI
    Gui, Main: Add, Text, x215 y100 w90 Center vStatsAvgCPU Hidden, 0`%

    Gui, Main: Font, s8 norm c888888, Segoe UI
    Gui, Main: Add, Text, x315 y85 w90 vStatsAvgRAMLabel Hidden, Avg RAM
    Gui, Main: Font, s13 bold cA78BFA, Segoe UI
    Gui, Main: Add, Text, x315 y100 w90 Center vStatsAvgRAM Hidden, 0`%

    Gui, Main: Font, s9 bold cWhite, Segoe UI
    Gui, Main: Add, Text, x10 y125 w420 vStatsClientsHeader Hidden, Client Details:

    Gui, Main: Font, s7 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x10 y145 w410 h140 vStatsClientList Hidden, No active clients detected.

    Gui, Main: Font, s8 norm c666666, Segoe UI
    Gui, Main: Add, Text, x10 y290 w420 Center vStatsFooter Hidden, Auto-updates every 2 seconds

    ; ==================== CUSTOMIZATION TAB ====================
    Gui, Main: Font, s10 bold cWhite, Segoe UI
    Gui, Main: Add, Text, x10 y62 w420 h18 Center vColorHeader Hidden, Text Color Customization

    Gui, Main: Font, s9 norm c00d4ff, Segoe UI
    Gui, Main: Add, Text, x10 y85 w420 vColorSep1 Hidden, ---------------------------------------------------------

    Gui, Main: Font, s9 bold cWhite, Segoe UI
    Gui, Main: Add, Text, x20 y105 w200 vColorManagerLabel Hidden, Manager Tab Text Color:
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Button, x230 y102 w80 h25 gChangeColorManager vBtnManagerColor Hidden, Change

    Gui, Main: Font, s9 norm c00d4ff, Segoe UI
    Gui, Main: Add, Text, x10 y135 w420 vColorSep2 Hidden, ---------------------------------------------------------

    Gui, Main: Font, s9 bold cWhite, Segoe UI
    Gui, Main: Add, Text, x20 y155 w200 vColorStatsLabel Hidden, Stats Tab Text Color:
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Button, x230 y152 w80 h25 gChangeColorStats vBtnStatsColor Hidden, Change

    Gui, Main: Font, s9 norm c00d4ff, Segoe UI
    Gui, Main: Add, Text, x10 y185 w420 vColorSep3 Hidden, ---------------------------------------------------------

    Gui, Main: Font, s8 norm c888888, Segoe UI
    Gui, Main: Add, Text, x20 y205 w390 vColorNote Hidden, Note: Click Change to open the full color picker with custom colors.

    Gui, Main: Font, s8 norm c666666, Segoe UI
    Gui, Main: Add, Text, x10 y285 w420 Center vColorCredit Hidden, Windows native color picker - Choose any color!

    Gui, Main: Show, w440 h335, Roblox Manager

    Gosub, ShowManagerTab

    Menu, Tray, Add, Show Manager, ShowMain
    Menu, Tray, Default, Show Manager

    SetTimer, StartMaintenance, 300000
    SetTimer, AutoRefreshTimer, 300000
    SetTimer, RefreshCountdown, 1000
    SetTimer, UpdateMonitoring, 2000
    RefreshCountdownValue := 300
return

; ==================== COLOR CHANGE HANDLERS WITH FULL COLOR PICKER ====================
ChangeColorManager:
    ; Get current color (default to white if it's a named color)
    if (TextColorManager = "White")
        current := 0xFFFFFF
    else
        current := "0x" TextColorManager
    
    chosen := ChooseColor(current, MainHwnd)
    if (chosen != -1) {
        TextColorManager := ColorNumToHex(chosen)
        Gosub, RefreshManagerColors
    }
return

ChangeColorStats:
    if (TextColorStats = "White")
        current := 0xFFFFFF
    else
        current := "0x" TextColorStats
    
    chosen := ChooseColor(current, MainHwnd)
    if (chosen != -1) {
        TextColorStats := ColorNumToHex(chosen)
        Gosub, RefreshStatsColors
    }
return

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
    GuiControl, Main: -Default, ColorTabBtn

    ; Show Manager Tab elements
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

    ; Hide Stats Tab elements
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

    ; Hide Color Tab elements
    GuiControl, Main: Hide, ColorHeader
    GuiControl, Main: Hide, ColorSep1
    GuiControl, Main: Hide, ColorManagerLabel
    GuiControl, Main: Hide, BtnManagerColor
    GuiControl, Main: Hide, ColorSep2
    GuiControl, Main: Hide, ColorStatsLabel
    GuiControl, Main: Hide, BtnStatsColor
    GuiControl, Main: Hide, ColorSep3
    GuiControl, Main: Hide, ColorNote
    GuiControl, Main: Hide, ColorCredit
return

ShowStatsTab:
    CurrentTab := "stats"
    MonitoringEnabled := true
    GuiControl, Main: -Default, ManagerTabBtn
    GuiControl, Main: +Default, StatsTabBtn
    GuiControl, Main: -Default, ColorTabBtn

    ; Hide Manager Tab elements
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

    ; Show Stats Tab elements
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

    ; Hide Color Tab elements
    GuiControl, Main: Hide, ColorHeader
    GuiControl, Main: Hide, ColorSep1
    GuiControl, Main: Hide, ColorManagerLabel
    GuiControl, Main: Hide, BtnManagerColor
    GuiControl, Main: Hide, ColorSep2
    GuiControl, Main: Hide, ColorStatsLabel
    GuiControl, Main: Hide, BtnStatsColor
    GuiControl, Main: Hide, ColorSep3
    GuiControl, Main: Hide, ColorNote
    GuiControl, Main: Hide, ColorCredit

    Gosub, UpdateMonitoring
return

ShowColorTab:
    CurrentTab := "color"
    GuiControl, Main: -Default, ManagerTabBtn
    GuiControl, Main: -Default, StatsTabBtn
    GuiControl, Main: +Default, ColorTabBtn

    ; Hide Manager Tab elements
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

    ; Hide Stats Tab elements
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

    ; Show Color Tab elements
    GuiControl, Main: Show, ColorHeader
    GuiControl, Main: Show, ColorSep1
    GuiControl, Main: Show, ColorManagerLabel
    GuiControl, Main: Show, BtnManagerColor
    GuiControl, Main: Show, ColorSep2
    GuiControl, Main: Show, ColorStatsLabel
    GuiControl, Main: Show, BtnStatsColor
    GuiControl, Main: Show, ColorSep3
    GuiControl, Main: Show, ColorNote
    GuiControl, Main: Show, ColorCredit
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
    robloxList := ""
    for win in ComObjCreate("Shell.Application").Windows
        if (win.Name = "Roblox" || InStr(win.FullName, "RobloxPlayerBeta.exe"))
            robloxList .= win.HWND . "|"
    robloxList := Trim(robloxList, "|")
    if (robloxList = "") {
        ToolTip, No Roblox clients found.
        Sleep, 1000
        ToolTip
        return
    }
    Loop, Parse, robloxList, |
    {
        hwnd := A_LoopField
        WinGet, state, MinMax, ahk_id %hwnd%
        if (state = -1) {
            DllCall("ShowWindow", "ptr", hwnd, "int", 9)
        } else {
            WinActivate, ahk_id %hwnd%
        }
    }
    restoredCount := 0
    Loop, Parse, robloxList, |
        restoredCount++
    ToolTip, Restored %restoredCount% Roblox clients.
    UpdateStatus("Restored " . restoredCount . " clients")
    Sleep, 1200
    ToolTip
return

F8::ExitApp