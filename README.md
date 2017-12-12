Sculx
======

stands for **sc**reenshot **u**tility **l**inu**x**

These are just simple screenshot scripts for use in terminal emulators or keybinds.

**NOTICE**: These are just the scripts i've got on my machine atm. I'll improve them in near future, containing screenshot program profiles, configuration and upload service profiles.

## Features
* Taking screenshots
* Uploading screenshots to web services
* Getting notified after screenshot uploads
* Playing a different sound when the upload succeeded or failed

## Installation
Use the remote installtion script in the main directory:
```bash
curl -s https://raw.githubusercontent.com/Noki77/sculx/master/quicksetup.sh | sh
```

## Configuration

## Usage
You can simply create fullscreen screenshots by typing
```bash
screenshot
```

or screenshots of the current active window by typing
```bash
screenshot -w
```

or screenshots where you select the region by yourself
```bash
screenshot -a
# or 'screenshot -r', 'screenshot -region', 'screenshot -area', etc.
```

## Creating profiles
