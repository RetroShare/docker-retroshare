#!/bin/bash

# Set these values
# Generate the password hash with "RetroShare-nogui -G"
PORT=1000
USERNAME=MYUSER
PASSWDHASH=MYHASH

# For instructions see the retroshare wiki
# http://retroshare.sourceforge.net/wiki/index.php/Documentation:retroshare-nogui

# start RetroShare-nogui in a screen session
screen -dmS RetroScreen
screen -S "RetroScreen" -p 0 -X stuff "RetroShare-nogui -C -X -S $PORT -L $USERNAME -P $PASSWDHASH& $(printf \\r)"

