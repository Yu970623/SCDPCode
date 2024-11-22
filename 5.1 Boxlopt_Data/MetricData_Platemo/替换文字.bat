@echo off

SETLOCAL ENABLEDELAYEDEXPANSION

for /f "delims=" %%a in ('dir /b^|findstr "_D19_"') do (

set name=%%a

set name=!name:_DC1_DTLZ3_M10_D19_=_!

ren "%%a" "!name!"

)

exit