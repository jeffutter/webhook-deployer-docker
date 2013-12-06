FROM      ubuntu
MAINTAINER Jeffery Utter "jeff@jeffutter.com"

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 136221EE520DDFAF0A905689B9316A7BC7917B12
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN echo "deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu precise main" >> /etc/apt/sources.list
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get update; apt-get upgrade
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev curl git nodejs

RUN echo "install: --no-rdoc --no-ri" > /etc/gemrc;\
  echo "update: --no-rdoc --no-ri " >> /etc/gemrc

# Install Ruby
RUN mkdir /tmp/ruby;\
  cd /tmp/ruby;\
  curl ftp://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p353.tar.gz | tar xz;\
  cd ruby-2.0.0-p353;\
  chmod +x configure;\
  ./configure;\
  make;\
  make install;\
  gem install bundler

RUN npm -g install forever

ADD ./server /server

RUN cd /server; npm install

CMD ['cd /server; forever -d server.js']
