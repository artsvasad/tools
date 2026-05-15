@echo off
setlocal enabledelayedexpansion
title Suyena Infrastructure - Continuous Network Diagnostic

echo [SUYENA DIAGNOSTICS] Initiating Continuous Network Throughput Stress Test...
echo Target: \\suyena-sca\C\Users\shahi\Downloads\20.0GB_dump.bin
echo Sink: NUL (Storage Bypass)
echo [WARNING] This will run indefinitely. Press CTRL+C to terminate.
echo.

set iteration=0

:CYCLE_START
set /a iteration+=1
echo [!TIME!] Initiating Stream Cycle #!iteration!...

:: The > NUL suppresses the default Windows "1 file(s) copied." output for a cleaner log.
copy "\\suyena-sca\C\Users\shahi\Downloads\20.0GB_dump.bin" NUL > NUL

echo [!TIME!] Stream Cycle #!iteration! complete.
echo.

:: Immediately loops back to the start
goto CYCLE_START