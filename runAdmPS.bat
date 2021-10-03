@ECHO OFF
:: Elevate cmd to admin and then run PS
:: Minor mod of https://newbedev.com/how-can-i-auto-elevate-my-batch-file-so-that-it-requests-from-uac-administrator-rights-if-required

NET SESSION
IF %ERRORLEVEL% NEQ 0 GOTO ELEVATE
GOTO RUNADM

:ELEVATE
pushd %~dp0
MSHTA "javascript: var shell = new ActiveXObject('shell.application'); shell.ShellExecute('%~nx0', '', '', 'runas', 1);close();"
EXIT

:RUNADM
PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0adm.ps1""' -Verb RunAs}"
EXIT
