@echo off

echo This is an installation/update script generated by nebulder (https://github.com/erykjj/nebulder)
echo for automating the deployment of a Nebula network
echo.

set scriptpath=%~dp0
echo Script directory: %scriptpath%
set /p d= Target directory: 
echo.

echo Stopping nebula service
%scriptpath%/nebula.exe -service stop
timeout /t 3 /nobreak > NUL
%scriptpath%/nebula.exe -service uninstall
timeout /t 2 /nobreak > NUL
echo.

echo Updating config with correct paths
setlocal enableextensions disabledelayedexpansion
set "find=/etc/nebula/nebula10/"
REM set "sub=%d%\"
set "file=%scriptpath%/config.yaml"
for /f "delims=" %%i in ('type "%file%" ^& break ^> "%file%" ') do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    >>"%file%" echo(!line:%find%=%d%\!
    endlocal
)
echo.

echo Copying new files to %d%
xcopy %scriptpath%\* %d% /E /V /I /Y
echo.

echo Starting nebula service
%d%\nebula.exe -service install -config %d%\config.yaml
timeout /t 3 /nobreak > NUL
%d%\nebula.exe -service start
echo.

echo Completed
set /p k= Press ENTER to close
