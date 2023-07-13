@echo off
setlocal enabledelayedexpansion

:: Remove previous build if exists
if not exist ".\build\" (
  echo Cannot find Aseprite! Please build it first using build.bat
  pause
  exit /b 2
)

:: Check for updates
git remote update >nul 2>&1
git status -uno | findstr /C:"is up to date" >nul
set "update_result=%errorlevel%"

if not !update_result! equ 0 (
	wscript.exe "%~dp0update_prompt.vbs"
	set "prompt_result=!errorlevel!"
	
	:: If user wants to update
	if !prompt_result! equ 0 (
		tasklist | find /i "aseprite.exe" | findstr /C:"aseprite.exe" >nul
		set "process_result=!errorlevel!"

		if !process_result! equ 0 (
			echo Aseprite.exe process found. Killing the process...
			taskkill /f /im "aseprite.exe" >nul
		)

		call build.bat
	)
)
