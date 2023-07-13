Set objShell = CreateObject("WScript.Shell")
intResult = objShell.Popup("Do you want to update?", 0, "New version!", 4 + 64)

If intResult = 6 Then ' Yes button clicked
    objShell.Popup "Aseprite will be closed and rebuilt." & vbCrLf & "(Save your progress before that)", 0, "Warning!", 48
	WScript.Quit(0)
End If

WScript.Quit(1)
