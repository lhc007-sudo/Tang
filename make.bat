@ECHO OFF
PUSHD %~dp0

IF NOT DEFINED SPHINXBUILD (
    IF EXIST "%~dp0sphinx_env\Scripts\sphinx-build.exe" (
        SET "SPHINXBUILD=%~dp0sphinx_env\Scripts\sphinx-build.exe"
    ) ELSE IF EXIST "%~dp0.venv\Scripts\sphinx-build.exe" (
        SET "SPHINXBUILD=%~dp0.venv\Scripts\sphinx-build.exe"
    ) ELSE (
        SET "SPHINXBUILD=sphinx-build"
    )
)

SET "SOURCEDIR=source"
SET "BUILDDIR=build"

"%SPHINXBUILD%" --version >NUL 2>NUL
IF ERRORLEVEL 1 (
    ECHO ERROR: sphinx-build was not found.
    ECHO Install the dependencies with:
    ECHO   sphinx_env\Scripts\python.exe -m pip install -r requirements.txt
    POPD
    EXIT /B 1
)

IF "%~1"=="" GOTO help
"%SPHINXBUILD%" -M %1 "%SOURCEDIR%" "%BUILDDIR%" %SPHINXOPTS% %O%
GOTO end

:help
"%SPHINXBUILD%" -M help "%SOURCEDIR%" "%BUILDDIR%" %SPHINXOPTS% %O%

:end
SET "EXIT_CODE=%ERRORLEVEL%"
POPD
EXIT /B %EXIT_CODE%
