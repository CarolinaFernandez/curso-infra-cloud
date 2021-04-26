@echo off

::::
:: Start the Vagrant environment
::

:: Access specific environment
set TOOL=%1
shift
@IF [%TOOL%] == [] (
    echo Error: se ha de definir el entorno a iniciar
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

:: Install required plugin
@vagrant plugin list | find /i "vagrant-disksize"
:: If not contained
@if errorlevel 1 (
    echo Instalando plug-in de Vagrant
    vagrant plugin install vagrant-disksize
)

:: Set environment as VAGRANT_EXPERIMENTAL
:::: See: https://www.vagrantup.com/docs/provisioning/basic_usage
::set VAGRANT_EXPERIMENTAL="dependency_provisioners"

:: Do reload only when it was not already created or currently running
@vagrant status | find /i "running"
:: If contained
@if not errorlevel 1 (
    set must_start=0
    set must_reload=0
)
@vagrant status | find /i "poweroff"
:: If contained
@if not errorlevel 1 (
    set must_start=1
    set must_reload=0
) else (
    set must_start=0
    set must_reload=1
)

:: Create the VM
@if %must_start% equ 1 (
    echo Creando la VM (%TOOL%)
    vagrant up
) else (
    echo Iniciando la VM (%TOOL%)
)

:: Reload the VM
@if %must_reload% equ 1 (
    echo Reiniciando tras crear la VM (%TOOL%)
    vagrant reload
)

:: SSH into the VM
echo Accediendo a la VM (%TOOL%)
vagrant ssh

cd %current%
