@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem ---- Resolve plugin root ----
rem Prefer CLAUDE_PLUGIN_ROOT; otherwise infer from this script location: <root>\bin\run.cmd
set "ROOT=%CLAUDE_PLUGIN_ROOT%"
if not defined ROOT (
  set "ROOT=%~dp0.."
)
rem Normalize: remove trailing backslash if present
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"

set "ENTRY=%ROOT%\dist\index.js"

rem ---- Use explicit bun override if provided ----
if defined BUN_BIN (
  if exist "%BUN_BIN%" (
    "%BUN_BIN%" "%ENTRY%" %*
    exit /b %ERRORLEVEL%
  )
)

rem ---- If bun in PATH, use it ----
where bun >nul 2>nul
if %ERRORLEVEL%==0 (
  bun "%ENTRY%" %*
  exit /b %ERRORLEVEL%
)

rem ---- Fallback to node if available ----
if defined NODE_BIN (
  if exist "%NODE_BIN%" (
    "%NODE_BIN%" "%ENTRY%" %*
    exit /b %ERRORLEVEL%
  )
)

where node >nul 2>nul
if %ERRORLEVEL%==0 (
  node "%ENTRY%" %*
  exit /b %ERRORLEVEL%
)

echo Error: Bun or Node.js not found. Is bun or node in your PATH?
echo The WakaTime Claude Code plugin requires Bun or Node to run.
echo.
echo Fix options:
echo   1) Install Bun and ensure bun.exe is available, OR
echo   2) Set BUN_BIN to the full path of bun.exe, e.g.:
echo        setx BUN_BIN "C:\Program Files\Bun\bun.exe"
echo   3) Install Node.js and ensure node.exe is available, OR
echo   4) Set NODE_BIN to the full path of node.exe, e.g.:
echo        setx NODE_BIN "C:\Program Files\nodejs\node.exe"
echo      Then restart Claude Code.
exit /b 127
