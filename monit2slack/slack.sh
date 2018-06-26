#!/bin/bash

URL="{{ slack_webhook_url }}"
logfile="/var/log/monit-to-slack.log"

if [[ $MONIT_EVENT == *"succeeded"* ]] || [[ $MONIT_EVENT == *"OK"* ]] || [[ $MONIT_EVENT == "Exists" ]]  || [[ $MONIT_DESCRIPTION == *"process is running with pid"* ]]; then
        COLOR="good";
        SPEAK=":heavy_check_mark: Check succeeded!";
else
        COLOR="danger";
        SPEAK=":x: Check failed. ";
fi

PAYLOAD="{
        \"username\":\"monit on $MONIT_HOST \",
        \"channel\": \"aem_monit\",
        \"text\": \"$SPEAK\",
        \"attachments\": [
         {
            \"color\": \"$COLOR\",
            \"text\": \"*Host*: $MONIT_HOST\n*Service*: \`$MONIT_SERVICE\`\n*Status*: $MONIT_DESCRIPTION\n*Date*: $MONIT_DATE\"
         }
        ]
}"
echo -e "`date` : MONIT_EVENT=\"$MONIT_EVENT\" | MONIT_DESCRIPTION=\"$MONIT_DESCRIPTION\" | MONIT_HOST=\"$MONIT_HOST\" | MONIT_SERVICE=\"$MONIT_SERVICE\" | MONIT_DATE=\"$MONIT_DATE\" | COLOR=\"$COLOR | SPEAK=\"$SPEAK\" | MONIT_PROGRAM_STATUS=\"$MONIT_PROGRAM_STATUS\"\n RESPONSE: " >> $logfile

curl -s -X POST --data-urlencode "payload=$PAYLOAD" $URL >> $logfile 2>&1

echo -e "\n----------" >> $logfile
