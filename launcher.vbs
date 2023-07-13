Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
strScriptPath = objFSO.GetParentFolderName(objFSO.GetAbsolutePathName(WScript.ScriptFullName))

' Aseprite.exe
strAsepritePath = objFSO.BuildPath(strScriptPath, "build\bin\Aseprite.exe")
If objFSO.FileExists(strAsepritePath) Then
    objShell.Run chr(34) & strAsepritePath & chr(34), 1, False
Else
    objShell.Popup "Please build the project first using build.bat", 0, "Missing build", 16
    WScript.Quit(1)
End If

' updater.bat
strUpdaterPath = objFSO.BuildPath(strScriptPath, "updater.bat")
objShell.Run chr(34) & "cmd.exe" & chr(34) & " /c " & chr(34) & strUpdaterPath & chr(34), 0, False
