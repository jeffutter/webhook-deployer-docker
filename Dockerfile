FROM      ubuntu
MAINTAINER Jeffery Utter "jeff@jeffutter.com"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get -y install software-properties-common;\
    apt-add-repository ppa:brightbox/ruby-ng;\
    apt-add-repository ppa:chris-lea/node.js;\
    echo "deb http://archive.ubuntu.com/ubuntu/ trusty main universe" > /etc/apt/sources.list;\
    echo "deb http://archive.ubuntu.com/ubuntu/ trusty-security main universe " >> /etc/apt/sources.list;\
    echo "deb http://archive.ubuntu.com/ubuntu/ trusty-updates main universe" >> /etc/apt/sources.list
RUN apt-get update

RUN locale-gen en_US.UTF-8
RUN echo 'LANG="en_US.UTF-8"' > /etc/default/locale
RUN dpkg-reconfigure locales
RUN LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev curl git nodejs imagemagick libjpeg-turbo-progs trimage advancecomp gifsicle jhead jpegoptim optipng pngcrush ruby2.1 ruby2.1-dev 

RUN echo "install: --no-rdoc --no-ri" > /etc/gemrc;\
  echo "update: --no-rdoc --no-ri " >> /etc/gemrc

RUN gem install bundler

ADD ./server /server

WORKDIR /server
CMD ["./webhook-deployer"]
