@ECHO OFF
ECHO Get "current month" strava activity IDs for each person and save it to single line file like data\current-month-Bjorn.txt
call 1-setup.bat
bash 2-StravaActivitiesByMonth.sh
ECHO Next ... update the database from PYTHON folder on laptop

if %computername%==BSVENSSON (
  echo laptop with ESSR2020...
  PUSHD C:\Users\bjor3345\Documents\python
  call runall.bat
  POPD
  REM -- started from runall -- call 4-UpdateResults.bat
)
@ECHO ON