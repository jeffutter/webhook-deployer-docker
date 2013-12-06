FROM      ubuntu
MAINTAINER Jeffery Utter "jeff@jeffutter.com"

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 136221EE520DDFAF0A905689B9316A7BC7917B12
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN echo "deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu precise main" >> /etc/apt/sources.list
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get update; apt-get upgrade
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -y install nodejs

RUN npm -g install forever

ADD ./server /server

RUN cd /server; npm install

CMD ['cd /server; forever -d server.js']
