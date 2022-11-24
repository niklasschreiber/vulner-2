@echo off
REM ###########################################################################
REM Script generated by Fortify SCA Scan Wizard (c) 2011-2022 Micro Focus or one of its affiliates
REM Created on 2022/01/25 18:42:51
REM ###########################################################################
REM Generated for the following languages:
REM 	Java
REM 	Java Bytecode
REM 	JSP J2EE
REM ###########################################################################
REM DEBUG - if set to true, runs SCA in debug mode
REM SOURCEANALYZER - the name of the SCA executable
REM FPR - the name of analysis result file
REM BUILDID - the SCA build id
REM ARGFILE - the name of the argument file that's extracted and passed to SCA
REM BYTECODE_ARGFILE - the name of the argument file for Java Bytecode translation that's extracted and passed to SCA
REM MEMORY - the memory settings for SCA
REM SCANSWITCHES - parameters to be passed to the analysis phase of SCA
REM LAUNCHERSWITCHES - the launcher settings that are used to invoke SCA
REM OLDFILENUMBER - this defines the file which contains the number of files within the project, it is automatically generated
REM FILENOMAXDIFF - this is the percentage of difference between the number of files which will trigger a warning by the script
REM ###########################################################################

set DEBUG=false
set SOURCEANALYZER=sourceanalyzer
set FPR="FortifyJavaTcaseforSR.fpr"
set BUILDID="JavaTcaseforSR"
set ARGFILE="FortifyJavaTcaseforSR.bat.args"
set BYTECODE_ARGFILE="FortifyJavaTcaseforSR.bat.bytecode.args"
set MEMORY=-Xmx29356M -Xms400M -Xss24M 
set LAUNCHERSWITCHES=""
set SCANSWITCHES=""
set OLDFILENUMBER="FortifyJavaTcaseforSR.bat.fileno"
set FILENOMAXDIFF=10
set ENABLE_BYTECODE=false

set PROJECTROOT0="D:\_SRC\@DUMATestCases\JavaTcaseforSR"
IF NOT EXIST %PROJECTROOT0% (
   ECHO  ERROR: This script is being run on a different machine than it was
   ECHO         generated on or the targeted project has been moved. This script is 
   ECHO         configured to locate files at
   ECHO            %PROJECTROOT0%
   ECHO         Please modify the %%PROJECTROOT0%% variable found
   ECHO         at the top of this script to point to the corresponding directory
   ECHO         located on this machine.
   GOTO :FINISHED
)

IF %DEBUG%==true set LAUNCHERSWITCHES=-debug %LAUNCHERSWITCHES%
echo Extracting Arguments File


echo. >%ARGFILE%
echo. >%BYTECODE_ARGFILE%
SETLOCAL ENABLEDELAYEDEXPANSION
IF EXIST %0 (
   set SCAScriptFile=%0
) ELSE (
  set SCAScriptFile=%0.bat
)

set PROJECTROOT0=%PROJECTROOT0:)=^)%
FOR /f "delims=" %%a IN ('findstr /B /C:"REM ARGS" %SCAScriptFile%' ) DO (
   set argVal=%%a
   set argVal=!argVal:PROJECTROOT0_MARKER=%PROJECTROOT0:~1,-1%!
   echo !argVal:~9! >> %ARGFILE%
)
set PROJECTROOT0=%PROJECTROOT0:)=^)%
FOR /f "delims=" %%a IN ('findstr /B /C:"REM BYTECODE_ARGS" %SCAScriptFile%' ) DO (
   set ENABLE_BYTECODE=true
   set argVal=%%a
   set argVal=!argVal:PROJECTROOT0_MARKER=%PROJECTROOT0:~1,-1%!
   echo !argVal:~18! >> %BYTECODE_ARGFILE%
)
ENDLOCAL && set ENABLE_BYTECODE=%ENABLE_BYTECODE%

REM ###########################################################################
echo Cleaning previous scan artifacts
%SOURCEANALYZER% %MEMORY% %LAUNCHERSWITCHES% -b %BUILDID% -clean 
IF %ERRORLEVEL% NEQ 0  (
echo sourceanalyzer failed, exiting
GOTO :FINISHED
)
REM ###########################################################################
echo Translating files
%SOURCEANALYZER% %MEMORY% %LAUNCHERSWITCHES% -b %BUILDID% @%ARGFILE%
IF %ERRORLEVEL% NEQ 0  (
echo sourceanalyzer failed, exiting
GOTO :FINISHED
)
REM ###########################################################################
IF %ENABLE_BYTECODE%==true (
echo Translating Java bytecode files
%SOURCEANALYZER% %MEMORY% %LAUNCHERSWITCHES% -b %BUILDID% @%BYTECODE_ARGFILE%
IF %ERRORLEVEL% NEQ 0  (
echo sourceanalyzer failed, exiting
GOTO :FINISHED
)
)
REM ###########################################################################
echo Testing Difference between Translations
SETLOCAL
FOR /F "delims=" %%A in ('%SOURCEANALYZER% -b %BUILDID% -show-files ^| findstr /R /N "^" ^| find /C ":" ') DO SET FILENUMBER=%%A
IF NOT EXIST %OLDFILENUMBER% (
	ECHO It appears to be the first time running this script, setting %OLDFILENUMBER% to %FILENUMBER%
	ECHO %FILENUMBER% > %OLDFILENUMBER%
	GOTO TESTENDED
)

FOR /F "delims=" %%i IN (%OLDFILENUMBER%) DO SET OLDFILENO=%%i
set /a DIFF=%OLDFILENO% * %FILENOMAXDIFF%
set /a DIFF /=  100
set /a MAX=%OLDFILENO% + %DIFF%
set /a MIN=%OLDFILENO% - %DIFF%

IF %FILENUMBER% LSS %MIN% set SHOWWARNING=true
IF %FILENUMBER% GTR %MAX% set SHOWWARNING=true

IF DEFINED SHOWWARNING (
	ECHO WARNING: The number of files has changed by over %FILENOMAXDIFF%%%, it is recommended 
	ECHO          that this script is regenerated with the ScanWizard
)
:TESTENDED
ENDLOCAL

REM ###########################################################################
echo Starting scan
%SOURCEANALYZER% %MEMORY% %LAUNCHERSWITCHES% -b %BUILDID% %SCANSWITCHES% -scan -f %FPR%
IF %ERRORLEVEL% NEQ 0  (
echo sourceanalyzer failed, exiting
GOTO :FINISHED
)
REM ###########################################################################
echo Finished
:FINISHED
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\websocket-common-9.2.12.v20150709.jar;PROJECTROOT0_MARKER\lib\nekohtml-1.9.22.jar;PROJECTROOT0_MARKER\lib\jtds-1.3.1.jar;PROJECTROOT0_MARKER\lib\guava-18.0.jar;PROJECTROOT0_MARKER\lib\spring-webmvc-3.2.4.RELEASE.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\tomcat-util-7.0.65.jar;PROJECTROOT0_MARKER\lib\jcl-over-slf4j-1.7.12.jar;PROJECTROOT0_MARKER\lib\selenium-safari-driver-2.48.2.jar;PROJECTROOT0_MARKER\lib\h2-1.4.190.jar;PROJECTROOT0_MARKER\lib\jackson-annotations-2.6.0.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\tomcat-servlet-api-7.0.65.jar;PROJECTROOT0_MARKER\lib\jstl-1.2.jar;PROJECTROOT0_MARKER\lib\standard-1.1.2.jar;PROJECTROOT0_MARKER\lib\tiles-api-3.0.5.jar;PROJECTROOT0_MARKER\lib\serializer-2.7.2.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\j2h-1.3.1.jar;PROJECTROOT0_MARKER\lib\commons-lang-2.5.jar;PROJECTROOT0_MARKER\lib\jetty-io-9.2.12.v20150709.jar;PROJECTROOT0_MARKER\lib\activation-1.1.1.jar;PROJECTROOT0_MARKER\lib\tomcat-annotations-api-7.0.65.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\htmlunit-2.18.jar;PROJECTROOT0_MARKER\lib\httpmime-4.5.jar;PROJECTROOT0_MARKER\lib\junit-4.12.jar;PROJECTROOT0_MARKER\lib\spring-security-core-3.2.4.RELEASE.jar;PROJECTROOT0_MARKER\lib\cglib-nodep-2.1_3.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\websocket-api-9.2.12.v20150709.jar;PROJECTROOT0_MARKER\lib\hamcrest-core-1.3.jar;PROJECTROOT0_MARKER\lib\selenium-leg-rc-2.48.2.jar;PROJECTROOT0_MARKER\lib\json-20090211.jar;PROJECTROOT0_MARKER\lib\cssparser-0.9.16.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\selenium-firefox-driver-2.48.2.jar;PROJECTROOT0_MARKER\lib\selenium-chrome-driver-2.48.2.jar;PROJECTROOT0_MARKER\lib\selenium-edge-driver-2.48.2.jar;PROJECTROOT0_MARKER\lib\tomcat-juli-7.0.65.jar;PROJECTROOT0_MARKER\lib\slf4j-log4j12-1.7.12.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\selenium-remote-driver-2.48.2.jar;PROJECTROOT0_MARKER\lib\spring-security-web-3.2.4.RELEASE.jar;PROJECTROOT0_MARKER\lib\selenium-support-2.48.2.jar;PROJECTROOT0_MARKER\lib\slf4j-api-1.7.12.jar;PROJECTROOT0_MARKER\lib\websocket-client-9.2.12.v20150709.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\commons-logging-1.2.jar;PROJECTROOT0_MARKER\lib\spring-security-config-3.2.4.RELEASE.jar;PROJECTROOT0_MARKER\lib\jackson-core-2.6.3.jar;PROJECTROOT0_MARKER\lib\xml-apis-1.4.01.jar;PROJECTROOT0_MARKER\lib\jetty-util-9.2.12.v20150709.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\commons-codec-1.10.jar;PROJECTROOT0_MARKER\lib\jna-platform-4.1.0.jar;PROJECTROOT0_MARKER\lib\commons-collections-3.2.1.jar;PROJECTROOT0_MARKER\lib\axis-saaj-1.4.jar;PROJECTROOT0_MARKER\lib\javax.transaction-api-1.2.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\spring-aop-3.2.4.RELEASE.jar;PROJECTROOT0_MARKER\lib\commons-discovery-0.5.jar;PROJECTROOT0_MARKER\lib\sauce_junit-2.1.20.jar;PROJECTROOT0_MARKER\lib\commons-lang3-3.4.jar;PROJECTROOT0_MARKER\lib\commons-io-2.4.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\gson-2.3.1.jar;PROJECTROOT0_MARKER\lib\tomcat-catalina-7.0.65.jar;PROJECTROOT0_MARKER\lib\axis-ant-1.4.jar;PROJECTROOT0_MARKER\lib\ecs-1.4.2.jar;PROJECTROOT0_MARKER\lib\aopalliance-1.0.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\selenium-htmlunit-driver-2.48.2.jar;PROJECTROOT0_MARKER\lib\xalan-2.7.2.jar;PROJECTROOT0_MARKER\lib\xercesImpl-2.11.0.jar;PROJECTROOT0_MARKER\lib\commons-beanutils-1.8.3.jar;PROJECTROOT0_MARKER\lib\axis-jaxrpc-1.4.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\selenium-api-2.48.2.jar;PROJECTROOT0_MARKER\lib\spring-expression-3.2.4.RELEASE.jar;PROJECTROOT0_MARKER\lib\spring-web-3.2.4.RELEASE.jar;PROJECTROOT0_MARKER\lib\tomcat-api-7.0.65.jar;PROJECTROOT0_MARKER\lib\httpclient-4.5.1.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\httpcore-4.4.3.jar;PROJECTROOT0_MARKER\lib\selenium-ie-driver-2.48.2.jar;PROJECTROOT0_MARKER\lib\spring-core-3.2.4.RELEASE.jar;PROJECTROOT0_MARKER\lib\commons-digester-2.1.jar;PROJECTROOT0_MARKER\lib\jackson-databind-2.6.3.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\tiles-core-3.0.5.jar;PROJECTROOT0_MARKER\lib\commons-exec-1.3.jar;PROJECTROOT0_MARKER\lib\saucerest-1.0.22.jar;PROJECTROOT0_MARKER\lib\axis-wsdl4j-1.5.1.jar;PROJECTROOT0_MARKER\lib\servlet-api.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\wsdl4j-1.6.3.jar;PROJECTROOT0_MARKER\lib\htmlunit-core-js-2.17.jar;PROJECTROOT0_MARKER\lib\javaee-api-6.0.jar;PROJECTROOT0_MARKER\lib\jna-4.1.0.jar;PROJECTROOT0_MARKER\lib\tiles-request-api-1.0.6.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\sauce_java_common-2.1.20.jar;PROJECTROOT0_MARKER\lib\axis-1.4.jar;PROJECTROOT0_MARKER\lib\netty-3.5.2.Final.jar;PROJECTROOT0_MARKER\lib\webbit-0.4.14.jar;PROJECTROOT0_MARKER\lib\log4j-1.2.17.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\selenium-java-2.48.2.jar;PROJECTROOT0_MARKER\lib\json-simple-1.1.jar;PROJECTROOT0_MARKER\lib\spring-context-3.2.4.RELEASE.jar;PROJECTROOT0_MARKER\lib\hsqldb-1.8.0.10.jar;PROJECTROOT0_MARKER\lib\spring-beans-3.2.4.RELEASE.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\lib\commons-fileupload-1.3.1.jar;PROJECTROOT0_MARKER\lib\javax.mail-api-1.5.4.jar;PROJECTROOT0_MARKER\lib\sac-1.3.jar"
REM ARGS "-source"
REM ARGS "1.8"
REM ARGS "-exclude" "PROJECTROOT0_MARKER\**\*.jar"
REM ARGS "-exclude" "PROJECTROOT0_MARKER\**\*.class"
REM ARGS "PROJECTROOT0_MARKER"