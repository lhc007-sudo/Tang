@echo off
setlocal
cd /d "%~dp0"

set "PYTHON_EXE=%~dp0sphinx_env\Scripts\python.exe"
if not exist "%PYTHON_EXE%" set "PYTHON_EXE=%~dp0.venv\Scripts\python.exe"

if not exist "%PYTHON_EXE%" (
    echo ERROR: Website Python environment was not found.
    echo Expected: %~dp0sphinx_env\Scripts\python.exe
    goto :error
)

"%PYTHON_EXE%" -c "import sphinx, myst_parser, sphinx_rtd_theme" >nul 2>nul
if errorlevel 1 (
    echo Installing website dependencies...
    "%PYTHON_EXE%" -m pip install -r requirements.txt
    if errorlevel 1 goto :error
)

echo Building the Tang documentation website...
set "SPHINXOPTS=-W --keep-going"
call "%~dp0make.bat" html
if errorlevel 1 goto :error

start "" "build\html\index.html"
exit /b 0

:error
echo.
echo Website build failed. Please check the messages above.
pause
exit /b 1
