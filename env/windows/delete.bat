@echo off

::::
:: Terminate and delete the Vagrant environment
::

:: Access specific environment
set TOOL=%1
shift
@IF [%TOOL%] == [] (
    echo Error: se ha de definir el entorno a eliminar
    exit /b 1
)
set current=%cd%

set tool_path="tools/%TOOL%"
@if exist %tool_path% (
    cd %tool_path%
) else (
  echo Error: entorno inexistente
  exit /b 1
)

:: Remove the VM
echo Eliminando la VM (%TOOL%)
vagrant destroy --force

cd %current%
