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
  YEAR=${2:-2021}
  MONTH=${3:-01}
  # uppercase first letter in name
  NAME="$(tr '[:lower:]' '[:upper:]' <<< ${NAME:0:1})${NAME:1}"

  case $NAME in
    Bjorn) ID=1167695;;
    Kylie) ID=6260742;;
    Sven)  ID=11545465;;
    Zara)  ID=23099564;;
    Erwin) ID=16638771;;
    Chris) ID=294207;;
    Joe)   ID=48542642;;
    Alan)  ID=37213693;;
    *)
      echo ERROR: Unexpected NAME - $NAME
      exit 1;;
  esac
  echo ==== $NAME, $YEAR, $MONTH, $ID ====
  JSONFILE=$DATADIR/$NAME-$YEAR-$MONTH.json
  curl "$URL1/$ID/interval?interval=$YEAR$MONTH&interval_type=month&chart_type=miles&year_offset=0" -H "x-requested-with: XMLHttpRequest" -H "sec-fetch-site: same-origin" -H "sec-fetch-mode: cors" -H "sec-fetch-dest: empty" -H "cookie: _strava4_session=$_strava4_session" -S -# --output $JSONFILE
  sed -e 's/\\n/\n/g' $JSONFILE | grep a.href=../activities/ | sed -e 's|^.a href=../activities/||' -e 's|\\.*||' | sort > $DATADIR/$NAME-$YEAR-$MONTH.csv
  sort --unique $DATADIR/$NAME-$YEAR-*.csv > $DATADIR/$NAME-$YEAR.csv
  sort --unique $DATADIR/$NAME*.csv > $DATADIR/$NAME.csv
  paste -sd" " $DATADIR/$NAME-$YEAR-$MONTH.csv > $DATADIR/current-month-$NAME.txt
  rm $JSONFILE
}

if test "$#" -eq 0; then
  ALLNAMES=(Bjorn Chris Erwin Joe Kylie Sven Zara Alan)
  for n in ${ALLNAMES[@]}; do
    gograb $n
  done
elif test "$#" -eq 1; then
  gograb $1
elif test "$#" -eq 3; then
  gograb $1 $2 $3
else
  echo This script require 0, 1, or 3 parameters: NAME YEAR MONTH.
  echo "NAME YEAR MONTH -- runs a specific month for a specific person"
  echo "NAME            -- runs \"current\" month for a specific person"
  echo "                -- runs \"current\" month for everyone (in our group)"
  exit 1
fi

exit 0
