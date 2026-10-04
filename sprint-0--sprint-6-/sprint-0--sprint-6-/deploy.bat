@echo off
setlocal

:: ==============================
:: Configuration
:: ==============================
set PROJECT=sprint-0-
set TOMCAT=C:\apache-tomcat-9.0.122
set PORT=8080
set CATALINA_HOME=%TOMCAT%
set CATALINA_BASE=%TOMCAT%

echo ==========================
echo Compilation...
echo ==========================

if exist build rmdir /S /Q build
mkdir build

:: -encoding UTF-8 : indispensable, sinon les accents des .java sont corrompus
javac -encoding UTF-8 ^
-cp "%TOMCAT%\lib\*" ^
-d build ^
src\framework\*.java ^
src\framework\annotation\*.java ^
src\controller\*.java

if errorlevel 1 (
    echo ERREUR DE COMPILATION
    pause
    exit /b 1
)

echo ==========================
echo Deploiement...
echo ==========================

if exist "%TOMCAT%\webapps\%PROJECT%" (
    rmdir /S /Q "%TOMCAT%\webapps\%PROJECT%"
)

mkdir "%TOMCAT%\webapps\%PROJECT%\WEB-INF\classes"
if errorlevel 1 (
    echo ERREUR : impossible d'ecrire dans Tomcat. Lance ce script en tant qu'administrateur.
    pause
    exit /b 1
)

xcopy build "%TOMCAT%\webapps\%PROJECT%\WEB-INF\classes" /E /I /Y
copy WEB-INF\web.xml "%TOMCAT%\webapps\%PROJECT%\WEB-INF"

echo.
echo ==========================
echo DEPLOIEMENT TERMINE
echo ==========================
echo.
echo Redemarrage de Tomcat...
call "%CATALINA_HOME%\bin\shutdown.bat"
timeout /t 3 /nobreak >nul
call "%CATALINA_HOME%\bin\startup.bat"
echo.
echo Tomcat a ete redemarre, puis teste :
echo   http://localhost:%PORT%/%PROJECT%/api/users
echo   http://localhost:%PORT%/%PROJECT%/api/users/count
echo.

pause