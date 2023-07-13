Set objShell = CreateObject("WScript.Shell")
objShell.Run ".\build\bin\Aseprite.exe", 1, False
objShell.Run "cmd.exe /c updater.bat", 0, False
