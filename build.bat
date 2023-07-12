@echo off

:: Update and init github submodules
echo Updating repository...
git pull

echo Updating dependencies...
git submodule update --init --recursive
git pull --recurse-submodules

:: Environment detection
:: Thanks to (https://renenyffenegger.ch/notes/Windows/development/Visual-Studio/environment-variables/index)
set "vs_installer=%programfiles(x86)%\Microsoft Visual Studio\Installer"

if not exist "%vs_installer%\vswhere.exe" (
    echo Cannot detect MS Visual Studio environment.
	echo "%vs_installer%\vswhere.exe"
	pause
	exit /b 2
) else (
	for /f "usebackq delims=" %%i in (`"%vs_installer%\vswhere" -latest -property installationPath`) do (
		set "vsvars_location=%%i\VC\Auxiliary\Build"
		goto :vsvars_found
	)
)

:vsvars_found
:: Initialize MSVC environment (x64)
call "%vsvars_location%\vcvars64.bat"

:: Remove previous build is exists
if exist ".\build\" (
  echo Removed previous build!
  rmdir ".\build\" /s /q > nul 2>&1
)

:: Download Ninja
echo Installing Ninja...
if exist ".\third_party\ninja" (
  rmdir .\third_party\ninja /s /q
)
mkdir .\third_party\ninja
powershell -Command "& Invoke-WebRequest https://github.com/ninja-build/ninja/releases/latest/download/ninja-win.zip -OutFile .\third_party\ninja\ninja.zip"
powershell -Command "& Expand-Archive .\third_party\ninja\ninja.zip -DestinationPath .\third_party\ninja"
del .\third_party\ninja\ninja.zip

:: Download SKIA library
echo Installing SKIA...
if exist ".\third_party\skia" (
  rmdir .\third_party\skia /s /q
)
mkdir .\third_party\skia
powershell -Command "& Invoke-WebRequest https://github.com/aseprite/skia/releases/latest/download/Skia-Windows-Release-x64.zip -OutFile .\third_party\skia\skia.zip"
powershell -Command "& Expand-Archive .\third_party\skia\skia.zip -DestinationPath .\third_party\skia"
del .\third_party\skia\skia.zip

:: Build
echo Building Aseprite...
set "ninja_path=%cd%\third_party\ninja\ninja.exe"
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DLAF_BACKEND=skia -DSKIA_DIR=.\third_party\skia -DSKIA_LIBRARY_DIR=.\third_party\skia\out\Release-x64 -DSKIA_LIBRARY=.\third_party\skia\out\Release-x64\skia.lib -S . -B build
cmake --build build --config Release

:: Create shortcut to binary
setlocal
set "shortcutName=Aseprite"
set "targetPath=%cd%\build\bin\aseprite.exe"
set "shortcutPath=%USERPROFILE%\Desktop\%shortcutName%.lnk"
echo Set oWS = WScript.CreateObject("WScript.Shell") > "%temp%\CreateShortcut.vbs"
echo sLinkFile = "%shortcutPath%" >> "%temp%\CreateShortcut.vbs"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%temp%\CreateShortcut.vbs"
echo oLink.TargetPath = "%targetPath%" >> "%temp%\CreateShortcut.vbs"
echo oLink.Save >> "%temp%\CreateShortcut.vbs"
cscript //nologo "%temp%\CreateShortcut.vbs"
del "%temp%\CreateShortcut.vbs"
endlocal