#!/bin/bash

UPLOAD_DEST="https://api.imgur.com/3/image"
REQ_METHOD="POST"
IMGUR_CLIENT_ID=""

declare -A UPLOAD_PARAMS
UPLOAD_PARAMS["image"]="@\"$1\""
UPLOAD_PARAMS["title"]="$(basename $1)"

# -----------------------------------------------------------------------

if [[ $IMGUR_CLIENT_ID != "" ]]; then
    declare -A UPLOAD_HEADERS
    UPLOAD_HEADERS["Authorization"]="Client-ID $IMGUR_CLIENT_ID"
else
    echo "Upload failed: You need to enter a client id, redeem your imgur api data @ https://api.imgur.com/oauth2/addclient"
fi

function processServerResponse {
    success=$(echo "$1" | jq -r .success)
    if [[ $success == true ]]; then
        echo "$1" | jq -r .data.link
        return 0
    else
        echo "Upload failed: $(echo $1 | jq -r .data.error)"
        return 1
    fi
}
