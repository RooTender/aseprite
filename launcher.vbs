Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
strScriptPath = objFSO.GetParentFolderName(objFSO.GetAbsolutePathName(WScript.ScriptFullName))

' Aseprite.exe
strAsepritePath = objFSO.BuildPath(strScriptPath, "build\bin\Aseprite.exe")
objShell.Run chr(34) & strAsepritePath & chr(34), 1, False

' updater.bat
strUpdaterPath = objFSO.BuildPath(strScriptPath, "updater.bat")
objShell.Run chr(34) & "cmd.exe" & chr(34) & " /c " & chr(34) & strUpdaterPath & chr(34), 0, False
