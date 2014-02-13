retroshare
============

This docker file builds [retroshare](http://retroshare.sourceforge.net/) and provides a few scripts to allow it to be configured for headless operation.

# Initial run
The initial configuration will start an SSHD as well as the graphical retroshare. To access retroshare you should map a port to the SSH port 22 with `-p <hostPort>:22` in your docker run command.
A user has been created named "retrouser" with a random password generated the first time the container is run. To get the password run `docker logs <container ID>` after starting the container.  I would suggest chaning the password on your first log in with retrouser.

Example getting started
```
    docker run -d -name retroshare -p 22200:22 csanders/retroshare
    docker logs retroshare
    ssh retrouser@localhost -p 22200
    passwd
```

## Once you are logged in as retrouser 
There are several scripts in the home directory as well as a simlink. The simlink `run_retroshare.sh` is run during startup and should point to one of the other available startup scripts.  This allows you to easily configure how the container is running with out having to relaunch a new container.  The scripts are:
* run_retro_gui.sh - Starts the graphical retroshare
* run_retro_nogui.sh - Starts the no-gui server (requires configuration)
* run_noop.sh - Simply skips any startup 

The graphical version of retroshare is started with `screen` and `xpra` which allow you to detach from the terminal and log out with the program still running. You can see these two instances running with the commands. 

```
    screen -list
    xpra list
```
The screen session will be named RetroShare, the xpra will be running on display :100.  To attach to the graphical display run:
```
    xpra attach :100
```
From here you can configure the RetroShare server in the GUI as normal.
To attach to the Screen session simply run
```
    screen -R
```
For more information on Screen and Xpra see their respective man pages online.
In general it is a good idea to close the xpra session `xpra stop :100` and shut down the screen session (simply attach and disconnect like any terminal) before re-running one of the startup scripts.  Once you are attached to the xpra display you can configure the Retroshare server. For an easy way to access the server from a windows machine see [winswitch](http://winswitch.org/).  The Xpra included is from the winswitch team and allows for remote access to the machine similar to VNC with compression on the graphical interface. In my testing winswitch tends to leave zombie XPRA windows open on the server.  This is of little concern if you are only using the GUI for occasional configuration and running "nogui" the majority of the time.

# Running "nogui"
This container will allow the autostart *and* auto login of retroshare-nogui after you've configured your retroshare instance.  Simply shut down the graphical retroshare and edit the ~/run_retro_nogui.sh script. Additionally, retroshare is started with the SSH server and RPC interface enabled allowing for the use of [see the retroshare wiki](http://retroshare.sourceforge.net/wiki/index.php/Documentation:retroshare-nogui) for more information.

To create a password for the retroshare SSH access (for RPC clients) run the command:
```
    RetroShare-nogui -G
```
Copy the HASH that it provides and place it in the SSH_PASSWDHASH field of the run_retro_nogui.sh file.  The other SSH fields are self explanatory, just be sure you provide a local host port for the RPC access (seperate from port 22 referenced before, and not the port RetroShare is using). Note that the port, username, and password used for SSH have no relation to your RetroShare account.  They are simply the SSH credentials you'll need to configure on a client to access the RPC interface.

The only additional configuration is to allow automatic startup of retroshare-nogui. Since this is not supported by retroshare `expect` is used to imput the password for you.  If you choose to use this you will have to provide *Your GPG Retroshare Password* in the field "GPG_PASS". Be aware of escape sequences if your password uses special characters. If you do not do this, you can still log in and start retroshare manually. During start up RetroShare will pause at the password prompt and you can provide it manually. There are valid security concerns about placing your password in plain text, but until RetroShare-nogui has an autologin feature I am unaware of another solution for autostart.

Finally, after adding the above values move the simlink with 
```
    rm ~/start_retroshare.sh
    ln -s ~/start_retro_nogui.sh ~/start_retroshare.sh
```
Log out of the box and restart the docker instance:
```
    sudo docker restart retroshare
```
The server should come back up with retroshare-nogui running in a screen session.

