ECHO Get the latest strava activities for ech person and save it to single line file like data\current-month-Bjorn.txt
call 1-setup.bat
bash 2-StravaActivitiesByMonth.sh
ECHO Next ... update the database from PYTHON folder on laptop

if %computername%==BSVENSSON (
  echo laptop with ESSR2020...
  PUSHD C:\Users\bjor3345\Documents\python
  python --version
  call runall.bat
  python --version
  POPD
  REM -- started from runall -- call 4-UpdateResults.bat
)