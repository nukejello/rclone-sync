@ECHO off
chcp 65001
MODE 115,25
TITLE Script - Rsync for cloud storage:
SET SCRIPT_VERSION=1.0

:: Basic settings;
CD /d "%~dp0"
SET ch="app\cecho.exe"
SET RCLONE_APP="app\rclone.exe"
SET CONF="conf\rclone.conf"
SET CONF_EF="conf\exclude-from.txt"
SET LOG_FILE="log\log.txt"

:: Set environment variable to override config location;
SETX RCLONE_CONFIG %CONF%

:: Config file;
<conf\rclone-sync.conf (for /f "delims=" %%a in ('more') do @set "%%a") 2>nul

:: Configure Storage;
SET CONFIGURE_STORAGE=%RCLONE_APP% config

:: 1. Source sync --> to 2. Dest | Откуда --> Куда;
SET SYNC_1=%RCLONE_APP% %MODE% -q -P %FOLDER% %STORAGE_PATH%:%CLOUD% --config=%CONF% --transfers=%RATE% --bwlimit=%LIMIT% --exclude-from=%CONF_EF% --log-file=%LOG_FILE% %MORE%
SET SYNC_2=%RCLONE_APP% %MODE% -q -P %STORAGE_PATH%:%CLOUD% %FOLDER% --config=%CONF% --transfers=%RATE% --bwlimit=%LIMIT% --exclude-from=%CONF_EF% --log-file=%LOG_FILE% %MORE%

:: Storage info;
SET STORAGE_ABOUT=%RCLONE_APP% about %STORAGE_PATH%:

:Menu
cls
echo.
%ch% {08}  ╔══════════════════════════════════════════════════════════════════════╗ {\n #}
%ch% {08}  ║     {07}Script - Rsync for cloud storage:				 {08}║ {\n #}
%ch% {08}  ╚══════════════════════════════════════════════════════════════════════╝ {\n #}
echo.
%ch%		Current storage: {0a}%STORAGE_PATH%{#} ^| Mode: {0a}%MODE%{#}{\n #}
echo.
echo.	Options:
echo.
%ch% {0b}  [1]{#} = {0e}Sync{#} {0f}[Folder: {08}%FOLDER%{#}{0f}] {0e}--^>{#} {0f}[Cloud: {08}%CLOUD%{#}{0f}];{\n #}
echo.
%ch% {0b}  [2]{#} = {0e}Sync{#} {0f}[Cloud: {08}%CLOUD%{#}{0f}] {0e}--^>{#} {0f}[Folder: {08}%FOLDER%{#}{0f}];{\n #}
echo.
%ch% {0b}  [3]{#} = {0e}Run setup {0a}RCLONE{#};{\n #}
echo.
%ch% {0b}  [4]{#} = {0e}Storage info:{#};{\n #}
echo.
%ch% {0b}  [0]{#} = {0c}Exit{\n #}
%ch%												{08}^| Version: %SCRIPT_VERSION%{\n #}
echo.
set /p choice=--- Choice:
if '%choice%'=='1' goto GO_SYNC_1
if '%choice%'=='2' goto GO_SYNC_2
if '%choice%'=='3' goto GO_CONFIGURE_STORAGE
if '%choice%'=='4' goto GO_STORAGE_ABOUT
if '%choice%'=='0' goto END
if "%choice%"=="" ( endlocal & goto :RETURN
 ) else ( %ch% - {0c}Enter a valid option!{\n #}
		TIMEOUT /T 2 >nul & endlocal & goto :RETURN )

:GO_SYNC_1
%SYNC_1% & PAUSE & goto RETURN

:GO_SYNC_2
%SYNC_2% & PAUSE & goto RETURN

:GO_CONFIGURE_STORAGE
%CONFIGURE_STORAGE% & goto RETURN

:GO_STORAGE_ABOUT
%STORAGE_ABOUT% & PAUSE & goto RETURN

:RETURN
goto MENU

:END
goto exit 2>nul
