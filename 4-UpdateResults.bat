@ECHO OFF
@echo ---- This scripts copies the log from last summarize script, 
@echo ---- and if different, updates github repo

  git fetch
  git pull | grep -v "Already up to date"

  xcopy /D /V /Y C:\Users\bjor3345\Documents\PYTHON\log-summarize-REST2020_ESSR_Redlands.html docs\ESSR2020.html 
  xcopy /D /V /Y C:\Users\bjor3345\Documents\PYTHON\log-summarize-REST2020_REST_Redlands.html docs\REST2020.html 
  xcopy /D /V /Y C:\Users\bjor3345\Documents\PYTHON\log-summarize-REST2020_REST_Hulda.html docs\REST2020-Hulda.html 

  set COMMIT=0

  SET FILE=ESSR2020.html
  git status | find "%FILE%"
  IF %ERRORLEVEL%==0 (
    echo updating docs/%FILE%
    git add docs/%FILE%
    set COMMIT=1
  )

  SET FILE=REST2020.html
  git status | find "%FILE%"
  IF %ERRORLEVEL%==0 (
    echo updating docs/%FILE%
    git add docs/%FILE%
    set COMMIT=1
  )

  SET FILE=REST2020-Hulda.html
  git status | find "%FILE%"
  IF %ERRORLEVEL%==0 (
    echo updating docs/%FILE%
    git add docs/%FILE%
    set COMMIT=1
  )

  IF %COMMIT%==1 (
    echo commit and push
    git commit -m "Update stats"
    git push
  )

:END
@ECHO ON