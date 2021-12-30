FROM ubuntu:21.04
MAINTAINER jl.arteaga.almaraz@gmail.com

ENV FREELINGSHARE /usr/local/share/freeling
RUN apt-get update -q && apt-get install -y aria2
WORKDIR /tmp
RUN aria2c -j 5 -o freeling.tar.gz https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.tar.gz \
    && tar xvzf freeling.tar.gz \
    && rm freeling.tar.gz \
    && aria2c -j 5 -o freeling-langs.tar.gz https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-langs-src-4.2.tar.gz  \
    && tar xvzf freeling-langs.tar.gz \
    && rm freeling-langs.tar.gz

RUN apt-get install -y build-essential cmake \
    libboost-dev libicu-dev zlib1g-dev \
    libboost-regex-dev libboost-system-dev \
    libboost-thread-dev libboost-program-options-dev \
    libboost-filesystem-dev locales
RUN locale-gen en_US.UTF-8

WORKDIR /tmp/FreeLing-4.2
RUN mkdir build && cd build && cmake ..
RUN cd build && make -j 8 install
RUN rm -rf /tmp/FreeLing-4.2
RUN cp $FREELINGSHARE/config/es.cfg $FREELINGSHARE/config/main.cfg

EXPOSE 50005
CMD analyze -f $FREELINGSHARE/config/main.cfg --port 50005