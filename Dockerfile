FROM      ubuntu
MAINTAINER Jeffery Utter "jeff@jeffutter.com"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 136221EE520DDFAF0A905689B9316A7BC7917B12
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN echo "deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu precise main" >> /etc/apt/sources.list
RUN locale-gen en_US.UTF-8
RUN echo 'LANG="en_US.UTF-8"' > /etc/default/locale
RUN dpkg-reconfigure locales
RUN LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get update; apt-get upgrade
RUN LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev curl git nodejs imagemagick libjpeg-turbo-progs jpegoptim pngcrush optipng trimage 

RUN echo "install: --no-rdoc --no-ri" > /etc/gemrc;\
  echo "update: --no-rdoc --no-ri " >> /etc/gemrc

# Install Ruby
RUN mkdir /tmp/ruby;\
  cd /tmp/ruby;\
  curl ftp://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.0.tar.gz | tar xz;\
  cd ruby-2.1.0;\
  chmod +x configure;\
  ./configure --disable-install-doc;\
  make;\
  make install;\
  gem install bundler

RUN npm -g install forever

ADD ./server /server

RUN cd /server; npm install --quiet

WORKDIR /server
CMD ["forever", "-d", "server.js"]
