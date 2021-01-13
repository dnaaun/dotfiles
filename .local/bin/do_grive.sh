#!/bin/bash

cd ~/GoogleDrive
/usr/bin/grive 2>&1
~/PersonalScripts/bin/log "do_grive.sh|Backed up google drive with rc=$?"
