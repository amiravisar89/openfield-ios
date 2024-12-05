export ACCESS_TOKEN=${ACCESS_TOKEN}

TMPFILE=tmp.json
while [ "$Flag" != '"COMPLETED"' ]
do
  echo $Flag
  curl -X GET \
     -H "Authorization: ${ACCESS_TOKEN}" \
     "https://api.bitbucket.org/2.0/repositories/prosperaag/openfieldsautomationtests/pipelines/" | jq '.values[0].state' > $TMPFILE
  Flag=$( jq '.name' $TMPFILE)
  [ "$Flag" == '"COMPLETED"' ] || sleep 1
done

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

Flag=$(jq -r '.result.name' $TMPFILE)
if [ "$Flag" = "ERROR" ]; then
  echo -e "QA status pipeline: ${RED}$Flag${NC}"
else
  echo -e "QA status pipeline: ${GREEN}$Flag${NC}"
fi
