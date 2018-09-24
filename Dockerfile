FROM debian:jessie

ENV	ZCASH_URL=https://github.com/zcash/zcash.git \
	ZCASH_CONF=/home/zcash/.zcash/zcash.conf

RUN apt-get update

RUN apt-get -qqy install --no-install-recommends build-essential \
    automake ncurses-dev libcurl4-openssl-dev libssl-dev libgtest-dev \
    make autoconf automake libtool git apt-utils pkg-config libc6-dev \
    libcurl3-dev libudev-dev m4 g++-multilib unzip git python zlib1g-dev \
    wget ca-certificates pwgen bsdmainutils curl

WORKDIR /src
RUN git clone ${ZCASH_URL}

WORKDIR /src/zcash
RUN ./zcutil/build.sh -j$(nproc)

WORKDIR /src/zcash/src
RUN /usr/bin/install -c zcash-tx zcashd zcash-cli zcash-gtest zcash-fetch-params -t /usr/local/bin/ && \
    rm -rf /src/zcash/ && \
		rm -rf /root/.ccache && \
		apt-get clean all -y && \
    adduser --uid 1000 --system zcash && \
    mkdir -p /home/zcash/.zcash/ && \
    mkdir -p /home/zcash/.zcash-params/ && \
    chown -R zcash /home/zcash && \
    echo "Success"

USER zcash
RUN echo "rpcuser=zcash" > ${ZCASH_CONF} && \
	echo "rpcpassword=`pwgen 20 1`" >> ${ZCASH_CONF} && \
	echo "addnode=mainnet.z.cash" >> ${ZCASH_CONF} && \
	echo "Success"

VOLUME ["/home/zcash/.zcash"]
