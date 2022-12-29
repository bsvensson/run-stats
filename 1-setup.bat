@ECHO OFF

:BASH

  @ECHO Is there a bash.exe in the path already?
  set BASH=bash.exe
  %BASH% --version >nul 2>nul

  if %ERRORLEVEL%==0 (
    echo Yes.
    where bash
    %BASH% --version | grep bash
    goto PYTHON
    goto CONTINUE
  )

  echo Nope.  Let's look for it elsewhere...

  IF EXIST "C:\Program Files\Git\usr\bin\%BASH%" (
       echo Found git. Fixed.
       rem exit
       SET "PATH=C:\Program Files\Git\usr\bin;%PATH%"
  ) ELSE IF EXIST "%LOCALAPPDATA%\Programs\Git\bin\bash.exe" (
       echo Found it. Fixed.
       SET "PATH=%LOCALAPPDATA%\Programs\Git\bin\;%PATH%"
  ) ELSE IF EXIST "%LOCALAPPDATA%\Atlassian\SourceTree\git_local\bin\bash.exe" (
       echo Found it. Fixed.
       SET "PATH=%LOCALAPPDATA%\Atlassian\SourceTree\git_local\bin;%PATH%"
  ) ELSE (
      echo Sorry, can't find a bash...
      echo Try other places:
      where %BASH% > tempfile 2>nul
      where /R %LOCALAPPDATA% %BASH%
      exit 1
  )
  %BASH% --version | grep bash
  where bash

:PYTHON

  @ECHO If needed, change PRO variable according to where your arcpy is...

  @REM TODO - check if right python already available...
  @REM The default installation location for a per-machine installation is
  @REM <System Drive>\Program Files\ArcGIS\Pro.
  @REM The default installation location for a per-user installation is
  @REM <System Drive>\Users\<username>\AppData\Local\Programs\ArcGIS\Pro.

  IF EXIST "%LOCALAPPDATA%\Programs\Pro\bin\Python" (
       SET PRO=%LOCALAPPDATA%\Programs\Pro\bin\Python
  ) ELSE IF EXIST "%ProgramFiles%\ArcGIS\Pro\bin\Python" (
       SET PRO=%ProgramFiles%\ArcGIS\Pro\bin\Python
  ) ELSE (
       echo Sorry, not sure where your arcpy is...
  )

  SET "PATH=%PRO%\Scripts;%PRO%\envs\arcgispro-py3;%PATH%"
  python --version

:CONTINUE

@ECHO ON