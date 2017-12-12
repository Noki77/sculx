#!/bin/bash

UPLOAD_DEST="https://my.awesome.yanius/api/upload"

declare -A UPLOAD_PARAMS
UPLOAD_PARAMS["apikey"]="yanius apikey"
UPLOAD_PARAMS["file"]="@\"$1\""

function processServerResponse {
    MESSAGE=$(echo "$1" | jq -r .message)
    if [[ $MESSAGE == "File uploaded" ]]; then
        echo $(echo "$1" | jq -r .url)
        return 0
    else
        echo "Upload failed: $MESSAGE"
        return 1
    fi
}
