@echo off
setlocal enabledelayedexpansion

:: Define paths
set ASSEMBLY_INFO=%~dp0FindAndReplace.App\Properties\AssemblyInfo.cs
set RELEASE_DIR=%~dp0FindAndReplace.App\bin\Debug\
set ILMERGE_PATH="C:\Program Files (x86)\Microsoft\ILMerge\ilmerge.exe"

:: Extract version
for /f "tokens=2 delims=()" %%a in ('findstr /c:"[assembly: AssemblyFileVersion" %ASSEMBLY_INFO%') do (
    set VERSION_RAW=%%~a
)

:: Remove dots to get fnrXXX.exe format
set VERSION_CLEAN=%VERSION_RAW:.=%

:: Set output name
set OUTPUT_NAME=fnr%VERSION_CLEAN%.exe

echo Current Directory: %CD%
echo VERSION_RAW: [%VERSION_RAW%]
echo VERSION_CLEAN: [%VERSION_CLEAN%]
echo OUTPUT_NAME: [%OUTPUT_NAME%]
echo RELEASE_DIR: [%RELEASE_DIR%]

echo ILMERGE_PATH: [%ILMERGE_PATH%]
if not exist %ILMERGE_PATH% (
    echo ERROR: ILMerge not found at %ILMERGE_PATH%
    pause
    exit /b 1
)

echo Building %OUTPUT_NAME%...

pushd %RELEASE_DIR%
echo Working Directory (in pushd): %CD%
echo Files present:
dir /b fnr.exe FindAndReplace.dll CommandLine.dll EncodingTools.dll
%ILMERGE_PATH% /log:log.txt /targetplatform:4 /out:%OUTPUT_NAME% fnr.exe FindAndReplace.dll CommandLine.dll EncodingTools.dll
popd

echo Checking if %OUTPUT_NAME% exists in %RELEASE_DIR%...
if exist "%RELEASE_DIR%%OUTPUT_NAME%" (
    echo Success: %OUTPUT_NAME% created.
) else (
    echo ERROR: %OUTPUT_NAME% not found.
    echo Check %RELEASE_DIR%log.txt for details.
)
