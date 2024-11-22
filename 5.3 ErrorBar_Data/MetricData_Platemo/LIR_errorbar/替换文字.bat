@echo off

SETLOCAL ENABLEDELAYEDEXPANSION

for /f "delims=" %%a in ('dir /b^|findstr "EPDCMO4"') do (

set name=%%a

set name=!name:EPDCMO4=SCDP4!

ren "%%a" "!name!"

)

exit