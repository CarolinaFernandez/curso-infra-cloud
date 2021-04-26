@echo off

::::
:: Enter to the Vagrant environment
::

:: Access specific environment
set TOOL=%1
shift
@IF [%TOOL%] == [] (
    echo Error: se ha de definir el entorno a acceder
    exit /b 1
)
set NODE=%1
shift
set current=%cd%

set tool_path="tools/%TOOL%"
@if exist %tool_path% (
    cd %tool_path%
) else (
  echo Error: entorno inexistente
  exit /b 1
)

:: SSH the VM
echo Accediendo a la VM (%TOOL%)
vagrant ssh %NODE%

cd %current%
