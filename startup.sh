#!/bin/bash

# Check for retroshare user
getent passwd retrouser > /dev/null
if [ $? -ne 0 ]; then
    # User does not exist
    # Create a user for retroshare
    useradd -s /bin/bash -p "tmp" retrouser
    PASSWD=`gpg --gen-random --armor 0 8`
    echo "retrouser password: $PASSWD"
    echo "retrouser:$PASSWD" | chpasswd
    chown -R retrouser:retrouser /home/retrouser
    chmod -R ug+rwX /home/retrouser
    chmod -R o-rwx /home/retrouser
    chmod ug+x /home/retrouser/*.sh
fi


# start retroshare
su - retrouser -c "~/start_retroshare.sh"

# Provided by winswitch image
./start_sshd.sh $1

