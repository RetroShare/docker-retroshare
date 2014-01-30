#!/bin/bash

# start retroshare
su - retrouser -c "~/start_retroshare.sh"

# Start SSHD and bg it if another command was given
if [ $1 != "/bin/sh"  ]; then
    echo "Running sshd in background and executing given CMD: $1"
    `which sshd` -D &
    $1
else
    echo "Running SSHD in foreground"
    `which sshd` -D
fi

