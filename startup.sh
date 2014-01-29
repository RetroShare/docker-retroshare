#!/bin/bash

# Start sshd
`which sshd` -D &
sleep 3
# start xpra
#xpra start :100

# start RetroShare
ssh retrouser@localhost -i /home/retrouser/.ssh/id_rsa -o StrictHostKeyChecking=no './start_retroshare.sh'

$1
