#!/bin/bash

# start retroshare
su - retrouser -c "~/start_retroshare.sh"

# Provided by winswitch image
./start_sshd.sh $1

