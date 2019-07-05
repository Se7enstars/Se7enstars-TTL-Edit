#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Data\icon.7s
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Description=S TTL Edit
#AutoIt3Wrapper_Res_Fileversion=1.0.1.3
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Copyright 7stars © 2016
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Opt("TrayIconHide", 1)
Opt("TrayMenuMode", 1)

$DataDir = @TempDir
$GuiColor = 0x4C4A48
$Reg = "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Tcpip\Parameters"
$RegKey = "DefaultTTL"

_Init(1)

$gui=GUICreate("S TTL Edit", 600, 400)
GUISetIcon($DataDir & "\icon.7s")
GUISetBkColor($GuiColor, $gui)

GUICtrlCreatePic($DataDir & "\logo.7s", 0, 0, 600, 80, 0x80)
GUICtrlCreatePic($DataDir & "\ct.7s", 445, 85, 95, 95, 0x80)
GUICtrlCreatePic($DataDir & "\nt.7s", 420, 200, 144, 144, 0x80)
GUICtrlCreateLabel("Current TLL", 60, 85, 280, 95, 0x0200)
GUICtrlSetFont(-1, 36, 700, Default, "Microsoft Sans Serif")
GUICtrlSetColor(-1, 0x00a651)
GUICtrlCreateLabel("Set New TLL", 60, 230, 290, 95, 0x0200)
GUICtrlSetFont(-1, 36, 700, Default, "Microsoft Sans Serif")
GUICtrlSetColor(-1, 0x00aeef)

$lct=GUICtrlCreateLabel("0", 472, 111, 40, 42, 0x0200 + 0x01)
GUICtrlSetFont(-1, 24, 700, Default, "Microsoft Sans Serif"); 24=[int 2] 17=[int3]
GUICtrlSetColor(-1, 0x00a651)

$nct=GUICtrlCreateInput("000", 453, 253, 76, 44, 0x0001 + 0x2000, 0x00000100)
GUICtrlSetLimit(-1, 3, 1)
GUICtrlSetFont(-1, 24, 700, Default, "Microsoft Sans Serif")
GUICtrlSetColor(-1, 0x00aeef)
GUICtrlSetBkColor(-1, $GuiColor)

$cons=GUICtrlCreateInput("Console...", 1, 379, 338, 20, 0x0080 + 0x0800, 0x00000100)
GUICtrlSetFont(-1, 12, Default, Default, "Consolas")
GUICtrlSetColor(-1, 0x00ff00)
GUICtrlSetBkColor(-1, $GuiColor)
$babout=GUICtrlCreateButton("&About", 340, 368, 60, 32)
GUICtrlSetFont(-1, 14, Default, Default, "Microsoft Sans Serif")
$bupdate=GUICtrlCreateButton("&Read TTL", 400, 368, 100, 32)
GUICtrlSetFont(-1, 14, Default, Default, "Microsoft Sans Serif")
$bapply=GUICtrlCreateButton("&Set TTL", 500, 368, 100, 32)
GUICtrlSetFont(-1, 14, Default, Default, "Microsoft Sans Serif")

ControlFocus ($gui, "", $cons)
GUISetState(@SW_SHOW, $gui)

_UpdateTTL(_ReadTTL())
_Console("Ready...")

While 1
	$msg=GUIGetMsg()
	Switch $msg
		Case -3
			_Init(0); Delete Recycle after close drom temp
			Exit
		Case $bapply
			$RR = GUICtrlRead($nct)
			If $RR = 0 Then
				_CleanTTL()
				_UpdateTTL(_ReadTTL())
				_Console("TTL disabled")
			ElseIf $RR = 00 Then
				_CleanTTL()
				_UpdateTTL(_ReadTTL())
				_Console("TTL disabled")
			ElseIf $RR = 000 Then
				_CleanTTL()
				_UpdateTTL(_ReadTTL())
				_Console("TTL disabled")
			ElseIf $RR > 255 Then
				GUICtrlSetData($nct, 255)
				_Console("Max TTL Size must be 255")
			Else
				$s = _SetTTL($RR)
				If $s = 1 Then
					_Console("TTL Set Succesful")
					_UpdateTTL(_ReadTTL())
				Else
					_Console($s)
				EndIf
			EndIf
		Case $bupdate
			$rt = _ReadTTL()
			If IsNumber($rt) Then
				_Console("TTL Read Succesful")
			EndIf
			_UpdateTTL($rt)
		Case $babout
			_Console("Donate Please... (for development)")
			_About()
	EndSwitch
WEnd


Func _Init($R)
	If $R = 1 Then
		FileInstall("Data\icon.7s", $DataDir & "\icon.7s", 1)
		FileInstall("Data\logo.7s", $DataDir & "\logo.7s", 1)
		FileInstall("Data\ct.7s", $DataDir & "\ct.7s", 1)
		FileInstall("Data\nt.7s", $DataDir & "\nt.7s", 1)
	ElseIf $R = 0 Then
		FileDelete($DataDir & "\icon.7s")
		FileDelete($DataDir & "\logo.7s")
		FileDelete($DataDir & "\ct.7s")
		FileDelete($DataDir & "\nt.7s")
	EndIf
EndFunc

Func _ReadTTL()
	$R=RegRead($Reg, $RegKey)
	If Not @error Then
		Return $R
	ElseIf @error = -1 Then
		_Console("Error: 0x0000f" & @error & " (No Default TTL)")
		Return "?"
	Else
		_Console("Error: 0x0000f" & @error)
	EndIf
EndFunc

Func _SetTTL($Ri)
	$sr = RegWrite($Reg, $RegKey, "REG_DWORD", $Ri)
	If $sr = 1 Then
		Return $sr
	Else
		Return "Error: 0x00ff0" & @error & "(Can't set TTL)"
	EndIf
EndFunc

Func _CleanTTL()
	$sr = RegDelete($Reg, $RegKey)
	If $sr = 1 Then
		Return 1
	Else
		Return "Error: 0x00ce0" & @error & "(Can't disable TTL)"
	EndIf
EndFunc

Func _UpdateTTL($R)
	If $R <> "" Then
		If StringLen($R) = 2 Then
			GUICtrlSetFont($lct, 24, 700, Default, "Microsoft Sans Serif")
			GUICtrlSetData($lct, $R)
		Else
			GUICtrlSetFont($lct, 17, 700, Default, "Microsoft Sans Serif")
			GUICtrlSetData($lct, $R)
		EndIf
	EndIf
EndFunc

Func _Console($ctext)
	GUICtrlSetData($cons, $ctext)
EndFunc

Func _About()
	GUISetState(@SW_LOCK, $gui)
	$font="Arial"
    $Gui1 = GUICreate("About", 270, 180, -1, -1, -1, 0x00000080, $gui)
	GUISetBkColor ($GuiColor)
	GUICtrlCreateLabel('S TTL Edit', 0, 20, 270, 23, 0x01)
	GUICtrlSetFont (-1,15, 600, -1, $font)
	GUICtrlSetColor(-1,0x00a651)
	GUICtrlCreateLabel('Free Public Programm', 0, 49, 270, 46, 0x01)
	GUICtrlSetFont (-1,13, 600, -1, $font)
	GUISetFont (9, 600, -1, $font)
	GUICtrlSetColor(-1,0x00a651)
	GUICtrlCreateLabel('Версия 1.0 от 07.11.2016', 50, 100, 210, 17)
	GUICtrlSetColor(-1,0x00aeef)
	GUICtrlCreateLabel('Сайт:', 50, 115, 40, 17)
	GUICtrlSetColor(-1,0x00aeef)
	$url=GUICtrlCreateLabel('http://seven.moy.su', 92, 115, 170, 17)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetColor(-1, 0x00a651)
	GUICtrlCreateLabel('Copyright 7stars © 2016', 50, 130, 210, 17)
	GUICtrlSetColor(-1,0x00aeef)
	$YD = GUICtrlCreateLabel("YandexMoney: 410012306912653", 50, 145, 215, 17)
	GUICtrlSetColor(-1,0x00aeef)
	GUICtrlSetTip(-1, "Click for copy")
	GUICtrlSetCursor(-1, 0)
	GUISetState(@SW_SHOW, $Gui1)
	$msg = $Gui1
	While 1
	  $msg = GUIGetMsg()
	  Select
		Case $msg = $url
			ShellExecute ('http://seven.moy.su')
		Case $msg = $YD
			ClipPut('410012306912653')
		Case $msg = -3
			$msg = $Gui
			GUIDelete($Gui1)
			GUISetState(@SW_UNLOCK, $gui)
			ExitLoop
		EndSelect
    WEnd
EndFunc