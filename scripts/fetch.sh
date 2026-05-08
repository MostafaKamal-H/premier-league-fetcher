#!/bin/bash

set -a
source .env
set +a

TODAY=$(date +%F)

mkdir -p data/raw logs

FILE="data/raw/pl_matches_${TODAY}.json"
LOG_FILE="logs/fetch_${TODAY}.log"

echo "$(date) | SCRIPT STARTED" >> "$LOG_FILE"

URL="${BASE_URL}/competitions/PL/matches"

TEMP_FILE=$(mktemp)

STATUS_CODE=$(curl -s -o "$TEMP_FILE" -w "%{http_code}" \
-X GET "$URL" \
-H "X-Auth-Token: $API_KEY")

if [[ "$STATUS_CODE" =~ ^[0-9]+$ ]] && [ "$STATUS_CODE" -eq 200 ]; then

    mv "$TEMP_FILE" "$FILE"

    echo "$(date) | SUCCESS | STATUS: $STATUS_CODE | SAVED: $FILE" >> "$LOG_FILE"

    echo "SUCCESS ✔"
    echo "FILE: $FILE"

else

    ERROR_MESSAGE=$(cat "$TEMP_FILE" 2>/dev/null)

    echo "$(date) | ERROR | STATUS: $STATUS_CODE | MESSAGE: $ERROR_MESSAGE" >> "$LOG_FILE"

    echo "ERROR ✖"
    echo "STATUS: $STATUS_CODE"
    echo "LOG: $LOG_FILE"

    rm -f "$TEMP_FILE"

    exit 1
fi

