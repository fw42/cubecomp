#!/bin/sh

if [ "$#" -ne 4 ]; then
  echo "Usage: ${0} <db> <user> <pass> <dir>"
  exit
fi

DB=$1
USER=$2
PASS=$3
DIR=$4

set -e

URL="https://www.worldcubeassociation.org/results/misc/export.html"
ZIPPED_FILENAME=$(curl -s $URL | grep -E "WCA_export[0-9_]+\.sql.zip" -o | head -n1)
FILENAME="WCA_export.sql"

cd $DIR
wget -q -c https://www.worldcubeassociation.org/results/misc/$ZIPPED_FILENAME
unzip -q -o $ZIPPED_FILENAME
if [[ "$(uname -s)" == "Darwin" ]]; then
  sed -i -e "s/CHARSET=latin1/CHARSET=utf8/g" $FILENAME
else
  sed -i $FILENAME -e "s/CHARSET=latin1/CHARSET=utf8/g"
fi

MYSQL="mysql --default-character-set=utf8 $DB -u $USER --password=$PASS"

$MYSQL < $FILENAME
echo "CREATE INDEX persons_person_id ON Persons (id);" | $MYSQL
echo "CREATE INDEX results_person_id ON Results (personId);" | $MYSQL
echo "CREATE INDEX results_person_country_id ON Results (personCountryId);" | $MYSQL
echo "CREATE INDEX results_event_id ON Results (eventId);" | $MYSQL
echo "CREATE INDEX ranks_single_event_id_person_id ON RanksSingle (eventId, personId);" | $MYSQL
echo "CREATE INDEX ranks_average_event_id_person_id ON RanksAverage (eventId, personId);" | $MYSQL
