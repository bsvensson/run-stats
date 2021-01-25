@ECHO OFF

:BASH

  @ECHO Is there a bash.exe in the path already?
  set BASH=bash.exe
  %BASH% --version >nul 2>nul

  if %ERRORLEVEL%==0 (
    echo Yes.
    %BASH% --version | grep bash
    goto CONTINUE
  )

  echo Nope.  Let's look for it elsewhere...

  IF EXIST "%LOCALAPPDATA%\Programs\Git\bin\bash.exe" (
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
  where bash
  bash --version | head -1

:PYTHON

  @ECHO If needed, change PRO variable according to where you arcpy is...

  @REM TODO - check if right python already available...

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