#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
SCREENSHOT_NAME="Screenshot-$(date +%Y-%m-%d_%H-%M-%S).png"

ACTIVE_UPLOAD_PROFILE="yanius"
ACTIVE_PROGRAM_PROFILE="deepin-screenshot"

USER_AGENT="sculx ($(uname -o) $(uname -m); $(uname -r))"

MPG123_SCALE=3500 # up to 32768, used for volume control
