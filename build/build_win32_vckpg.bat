@echo off

REM
REM Script to export cocos2d-x dependencies for KR4 PC build into the
REM Uses vcpkg 
REM Works with VS 2015 on Windows 10
REM

SET START_DIR="%cd%"
SET INSTALL_DIR=%START_DIR%\..\contrib\install-win32

REM ------------------------------------------------------------

if "%1" == ""  goto usage
if "%1"=="clean" (
    REM removes vcpkg
     if exist %INSTALL_DIR% (
        echo Removing vcpkg 
        rmdir /s %INSTALL_DIR%
        goto:eof
    )
    goto:eof
)

if not exist %INSTALL_DIR% (
    mkdir %INSTALL_DIR%
    if %ERRORLEVEL% NEQ 0 goto:error_exit
)

SET EXPORT_DIR=%1
SET EXPORT_NAME=win32-vcpkg

echo Install dir: %INSTALL_DIR%
echo Export dir:  %EXPORT_DIR%\%EXPORT_NAME%

pushd %INSTALL_DIR%

if not exist vcpkg (
   git clone -n https://github.com/microsoft/vcpkg
   pushd vcpkg
   git checkout 28509b2940d8cce35398f4a18209bb8f2fea11a3
   echo A | powershell -exec bypass scripts\bootstrap.ps1   
   popd
)

pushd vcpkg

FOR %%A IN (x86 x64) DO (
    vcpkg install box2d:%%A-windows-static bullet3:%%A-windows-static chipmunk:%%A-windows-static curl:%%A-windows freetype:%%A-windows-static glew:%%A-windows glfw3:%%A-windows-static libiconv:%%A-windows libogg:%%A-windows libpng:%%A-windows-static libuv:%%A-windows libvorbis:%%A-windows libwebp:%%A-windows-static libwebsockets:%%A-windows mpg123:%%A-windows openal-soft:%%A-windows sqlite3:%%A-windows tiff:%%A-windows-static zlib:%%A-windows

    vcpkg export --raw --output-dir=%EXPORT_DIR% --output=%EXPORT_NAME%.%%A box2d:%%A-windows-static bullet3:%%A-windows-static chipmunk:%%A-windows-static curl:%%A-windows freetype:%%A-windows-static glew:%%A-windows glfw3:%%A-windows-static libiconv:%%A-windows libogg:%%A-windows libpng:%%A-windows-static libuv:%%A-windows libvorbis:%%A-windows libwebp:%%A-windows-static libwebsockets:%%A-windows mpg123:%%A-windows openal-soft:%%A-windows sqlite3:%%A-windows tiff:%%A-windows-static zlib:%%A-windows

    echo cocos2d-x win32.%%A deps are in %EXPORT_DIR%\%EXPORT_NAME%.%%A    
)
popd
popd
goto:eof

:error_exit
echo win32 build error: %ERRORLEVEL%
cd %START_DIR%
goto:eof

REM usage
:usage
echo Usage: build_win32_vckpkg.bat export_dir
echo Example: build_win32_vckpkg.bat C:\KR4\git\cocos2d-x-3rd-party-libs-bin
