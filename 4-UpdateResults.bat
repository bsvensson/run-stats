@echo ---- This scripts copies the log from last summarize script, 
@echo ---- and if different, updates github repo

  git fetch
  git pull

  xcopy /D /V /Y C:\Users\bjor3345\Documents\PYTHON\log-summarize-REST2020_ESSR_Redlands.html docs\ESSR2020.html 
  xcopy /D /V /Y C:\Users\bjor3345\Documents\PYTHON\log-summarize-REST2020_REST_Redlands.html docs\REST2020.html 
  git status | findstr /c:"modified:   docs/REST2020.txt"
   
  IF %ERRORLEVEL%==0 GOTO UPDATEREPO
  echo Already up-to-date it seems
  goto END

:UPDATEREPO
  echo update repo...
  git add docs/ESSR2020.txt
  git add docs/REST2020.txt
  git commit -m "Update stats"
  git push
  goto END

:END