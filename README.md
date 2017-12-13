Sculx
======

stands for **sc**reenshot **u**tility **l**inu**x**

These are just simple screenshot scripts for use in terminal emulators or keybinds.

## Features
* Taking screenshots
* Uploading screenshots to web services
* Getting notified after screenshot uploads
* Playing a different sound when the upload succeeded or failed

## Installation
Use the quick installtion script inside the main directory:
```bash
curl -s https://raw.githubusercontent.com/Noki77/sculx/master/quicksetup.sh | sh
```

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

## Configuration
File: _&lt;configuration directory&gt;/sculx.conf.sh_

You can configure the following variables:
* __SCREENSHOT_DIR__: directory uesd to store screenshots
* __SCREENSHOT_NAME__: screenshot naming format
* __ACTIVE_UPLOAD_PROFILE__: the upload profile used
* __ACTIVE_PROGRAM_PROFILE__: the program profile used
* __USER_AGENT__: the user agent curl uses when uploading data
* __MPG123_SCALE__: the mpg123 scale parameter, used to control sound volume (the higher value you assign, the louder the sounds will be played; up to 32768)


### Creating profiles
Profiles are stored inside _&lt;configuration directory&gt;/profiles.d_ and written in bash.

You can create profiles for either your screenshot utilities, or your upload service.


#### Upload profiles
Directory: _&lt;configuration directory&gt;/profiles.d/upload_

You can configure the following variables (italic means _optional_)
* __UPLOAD_DEST__: the exact URL for uploading files (images)
* __UPLOAD_PARAMS__ (array): form attribtues sent by curl
* **_UPLOAD_HEADERS_** (array): headers sent by curl (as ex. for authentication)
* **_REQ_METHOD_**: request method, depends on the api used


#### Program profiles
Directory: _&lt;configuration directory&gt;/profiles.d/program_

You can configure the following variables
* __SCR_COMMAND__: command used to take screenshots (use __$1__ for the file path)
* __SCR_FLAG_WINDOW__: the window flag
* __SCR_FLAG_AREA__: the area flag
* __SCR_FLAG_FULL__: flag for fullscreen screenshots
The flags depend on the screenshot tool which you wish to use.
You can leave them empty, if the program has no flag or uses it as default, when no flags are given (as ex. fullscreen screenshots)
