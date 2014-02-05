FROM csanders/winswitch
MAINTAINER Chris Sanders 

# Install Retroshare
# Skipping universe because winswitch install already added it
# RUN echo "deb http://archive.ubuntu.com/ubuntu precise universe" >> /etc/apt/sources.list.d/precise.list

RUN apt-get install -y python-software-properties
RUN add-apt-repository ppa:csoler-users/retroshare 
RUN apt-get update
RUN apt-get install -y retroshare libicu48 expect

## Create a home directory for retroshare user
RUN mkdir /home/retrouser

# Add startup scripts
ADD start_retro_gui.sh /home/retrouser/start_retro_gui.sh
ADD start_retro_nogui.sh /home/retrouser/start_retro_nogui.sh
ADD start_noop.sh /home/retrouser/start_noop.sh
RUN ln -s /home/retrouser/start_retro_gui.sh /home/retrouser/start_retroshare.sh 
ADD startup.sh ./startup.sh
RUN chmod +x ./startup.sh
ENTRYPOINT ["./startup.sh"]
