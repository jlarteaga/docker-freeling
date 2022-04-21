FROM debian:10
MAINTAINER jl.arteaga.almaraz@gmail.com

RUN apt-get update -q && apt-get install -y aria2
WORKDIR /tmp
RUN aria2c -j 5 -o freeling.deb https://github.com/TALP-UPC/FreeLing/releases/download/4.2/freeling-4.2-buster-amd64.deb
RUN apt-get install -y build-essential cmake \
    libboost-dev libicu-dev zlib1g-dev \
    libboost-regex-dev libboost-system-dev \
    libboost-thread-dev libboost-program-options-dev \
    libboost-filesystem-dev locales libboost-iostreams-dev && \
    # https://serverfault.com/a/801162/963498
    sed -i -e "s/# en_US.UTF-8.*/en_US.UTF-8 UTF-8/" /etc/locale.gen && \
        dpkg-reconfigure --frontend=noninteractive locales && \
        update-locale LANG=en_US.UTF-8
RUN dpkg -i freeling.deb

ENV FREELING_PORT=50005
ENV FREELING_WORKERS=1
ENV FREELING_QUEUE=32
ENV FREELING_OUTPUT_FORMAT=xml
ENV FREELING_OUTPUT_LEVEL=semgraph
EXPOSE $FREELING_PORT
CMD analyze -f es.cfg  -w $FREELING_WORKERS -q $FREELING_QUEUE --output $FREELING_OUTPUT_FORMAT  --outlv $FREELING_OUTPUT_LEVEL --server --port $FREELING_PORT
