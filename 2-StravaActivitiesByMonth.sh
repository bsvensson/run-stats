# 1. Find all activities in specific month, including private activities of user that runs scripts.
# 2. Creates CSV files per user, month, and year

# echo Script name: $0
# This script can either by called for a specific user name or for "ALL"

# Note: the SESSIONFILE is not checked into github

SESSIONFILE=.strava-session
URL1=https://www.strava.com/athletes
DATADIR=data

# Basic checks

if ! command -v curl &> /dev/null
then
    echo "curl could not be found"
    exit 1
fi

[ -f "$SESSIONFILE" ] || { echo "$SESSIONFILE does not exists." ; exit 1; }
_strava4_session=$(cat "$SESSIONFILE")

[ ! -d "$DATADIR" ] && mkdir $DATADIR

gograb() {
  NAME=$1
  YEAR=${2:-$(date '+%Y')}
  MONTH=${3:-$(date '+%m')}
  # uppercase first letter in name
  NAME="$(tr '[:lower:]' '[:upper:]' <<< ${NAME:0:1})${NAME:1}"

  # JoeM/Joe
  NICENAME=$NAME
  case $NAME in
    Bjorn) ID=1167695;;
    Kylie) ID=6260742;;
    Sven)  ID=11545465;;
    Zara)  ID=23099564;;
    Erwin) ID=16638771;;
    Chris) ID=294207;;
    JoeM)  ID=48542642
           NICENAME=Joe;;
    Alan)  ID=37213693;;
    JoeH)  ID=69482669
           NICENAME=Joe;;
    *)
      echo ERROR: Unexpected NAME - $NAME
      exit 1;;
  esac

  echo ==== $NAME/$NICENAME, $YEAR, $MONTH, $ID ====
  JSONFILE=$DATADIR/$NAME-$YEAR-$MONTH.json
  curl "$URL1/$ID/interval?interval=$YEAR$MONTH&interval_type=month&chart_type=miles&year_offset=0" -H "x-requested-with: XMLHttpRequest" -H "sec-fetch-site: same-origin" -H "sec-fetch-mode: cors" -H "sec-fetch-dest: empty" -H "cookie: _strava4_session=$_strava4_session" -S -# --output $JSONFILE
  sed -e "s|u0026url=https%3A%2F%2Fwww.strava.com%2Factivities%2F|\n|g" $JSONFILE | grep utm_content%3D$ID%26 | grep "^[1-9][0-9]" | sed -e "s|^|https://www.strava.com/activities/|" -e "s/%3Futm_content.*//" | sort | uniq > $DATADIR/$NAME-$YEAR-$MONTH.csv
  sort --unique $DATADIR/$NAME-$YEAR-*.csv > $DATADIR/$NAME-$YEAR.csv
  sort --unique $DATADIR/$NAME*.csv > $DATADIR/$NAME.csv
  paste -sd" " $DATADIR/$NAME-$YEAR-$MONTH.csv > $DATADIR/current-month-$NAME.txt
  rm $JSONFILE
}

ALLNAMES=( Bjorn Chris Erwin JoeH JoeM Kylie Sven Zara Alan )
if test "$#" -eq 0; then
  for n in ${ALLNAMES[@]}; do
    gograb $n
  done
elif test "$#" -eq 1; then
  gograb $1
elif test "$#" -eq 2; then
  for n in ${ALLNAMES[@]}; do
    gograb $n $1 $2
  done
elif test "$#" -eq 3; then
  gograb $1 $2 $3
else
  echo This script require 0, 1, 2, or 3 parameters: NAME YEAR MONTH.
  echo "NAME YEAR MONTH -- runs a specific month for a specific person"
  echo "YEAR MONTH      -- runs a specific month for everyone (in our group)"
  echo "NAME            -- runs \"current\" month for a specific person"
  echo "                -- runs \"current\" month for everyone (in our group)"
  exit 1
fi

exit 0
