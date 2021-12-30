FROM ubuntu:21.04
MAINTAINER jl.arteaga.almaraz@gmail.com

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
RUN mkdir build && cd build && cmake .. && make -j 8 install && rm -rf /tmp/FreeLing-4.2 \
    cp /usr/local/share/freeling/config/es.cfg /usr/local/share/freeling/config/main.cfg

EXPOSE 50005
CMD analyze -f /usr/local/share/freeling/config/main.cfg --server --port 50005