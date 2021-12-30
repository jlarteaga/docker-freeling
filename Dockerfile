FROM ubuntu:21.04
MAINTAINER jl.arteaga.almaraz@gmail.com

RUN apt-get update -q && apt-get install -y aria2
WORKDIR /tmp
RUN aria2c -j 5 -o freeling.tar.gz https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.tar.gz
RUN tar xvzf freeling.tar.gz
RUN aria2c -j 5 -o freeling-langs.tar.gz https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-langs-src-4.2.tar.gz
RUN tar xvzf freeling-langs.tar.gz

RUN apt-get install -y build-essential cmake \
    libboost-dev libicu-dev zlib1g-dev \
    libboost-regex-dev libboost-system-dev \
    libboost-thread-dev libboost-program-options-dev \
    libboost-filesystem-dev locales

RUN locale-gen en_US.UTF-8

WORKDIR /tmp/FreeLing-4.2
RUN mkdir build
WORKDIR /tmp/FreeLing-4.2/build
RUN cmake ..
RUN make -j 8 install
RUN rm -rf /tmp/FreeLing-4.2

EXPOSE 50005
ENV FREELINGSHARE /usr/local/share/freeling
RUN cp $FREELINGSHARE/config/es.cfg $FREELINGSHARE/config/main.cfg
CMD analyze -f $FREELINGSHARE/config/main.cfg --port 50005