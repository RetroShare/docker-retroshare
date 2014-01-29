FROM csanders/base
MAINTAINER Chris Sanders 

# Retroshare
RUN echo "deb http://archive.ubuntu.com/ubuntu precise universe" >> /etc/apt/sources.list.d/precise.list
RUN apt-get install -y python-software-properties
RUN add-apt-repository ppa:csoler-users/retroshare 
RUN apt-get update
RUN apt-get install -y retroshare libicu48

# xpra for screen stle X access
#RUN apt-get install -y xpra screen
RUN apt-get install -y curl screen
RUN curl http://winswitch.org/gpg.asc | apt-key add -
RUN echo "deb http://winswitch.org/ precise main" > /etc/apt/sources.list.d/winswitch.list
RUN apt-get update
RUN apt-get install -y winswitch

# Install and start sshd
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
#RUN /usr/sbin/sshd -D &
#RUN /bin/bash -c '/usr/sbin/sshd -D &'

# Create a user for retroshare
RUN useradd -s /bin/bash -p "tmp" retrouser
RUN echo retrouser:retropass | chpasswd
RUN mkdir /home/retrouser
RUN mkdir /home/retrouser/.ssh
# Generate ssh key
RUN ssh-keygen -t rsa -f /home/retrouser/.ssh/id_rsa -P ""
RUN cat /home/retrouser/.ssh/id_rsa.pub > /home/retrouser/.ssh/authorized_keys
# Correct permissions
RUN chown -R retrouser:retrouser /home/retrouser
RUN chmod -R ug+rwX /home/retrouser
RUN chmod -R o-rwx /home/retrouser
RUN chmod g-rwx /home/retrouser/.ssh/authorized_keys
RUN chmod g-rwx /home/retrouser/.ssh/id_rsa

# Start Retroshare via screen and xpra
#RUN ssh retrouser@localhost -i /home/retrouser/.ssh/id_rsa -o StrictHostKeyChecking=no

ADD start_retroshare.sh /home/retrouser/start_retroshare.sh
RUN chown retrouser:retrouser /home/retrouser/start_retroshare.sh
RUN chmod +x /home/retrouser/start_retroshare.sh

ADD startup.sh ./startup.sh
RUN chmod +x ./startup.sh
ENTRYPOINT ["./startup.sh"]
