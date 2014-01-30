FROM csanders/winswitch
MAINTAINER Chris Sanders 

# Install Retroshare
# Skipping universe because winswitch install already added it
# RUN echo "deb http://archive.ubuntu.com/ubuntu precise universe" >> /etc/apt/sources.list.d/precise.list
RUN apt-get install -y python-software-properties
RUN add-apt-repository ppa:csoler-users/retroshare 
RUN apt-get update
RUN apt-get install -y retroshare libicu48

# Create a user for retroshare
RUN useradd -s /bin/bash -p "tmp" retrouser
RUN echo retrouser:retropass | chpasswd
RUN mkdir /home/retrouser
RUN chown -R retrouser:retrouser /home/retrouser
RUN chmod -R ug+rwX /home/retrouser
RUN chmod -R o-rwx /home/retrouser

# Add bootstrap scripts
ADD start_retroshare.sh /home/retrouser/start_retroshare.sh
RUN chown retrouser:retrouser /home/retrouser/start_retroshare.sh
RUN chmod +x /home/retrouser/start_retroshare.sh
ADD startup.sh ./startup.sh
RUN chmod +x ./startup.sh
ENTRYPOINT ["./startup.sh"]
