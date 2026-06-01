@echo off
setlocal
set MAVEN_VERSION=3.9.9
set MAVEN_DIR=%~dp0.mvn\apache-maven-%MAVEN_VERSION%
set MAVEN_ZIP=%~dp0.mvn\apache-maven-%MAVEN_VERSION%-bin.zip

if not exist "%MAVEN_DIR%\bin\mvn.cmd" (
  if not exist "%~dp0.mvn" mkdir "%~dp0.mvn"
  curl.exe -L "https://archive.apache.org/dist/maven/maven-3/%MAVEN_VERSION%/binaries/apache-maven-%MAVEN_VERSION%-bin.zip" -o "%MAVEN_ZIP%"
  tar.exe -xf "%MAVEN_ZIP%" -C "%~dp0.mvn"
)

call "%MAVEN_DIR%\bin\mvn.cmd" %*
