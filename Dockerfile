FROM centos:latest

RUN yum update -y

RUN yum group install -y "Development Tools"

RUN yum install -y epel-release \
openssl-devel \
gtest-devel \
unzip git python \
wget curl \
glibc-static \
libstdc++-static pwgen


ENV ZCASH_URL=https://github.com/zcash/zcash.git

WORKDIR /src

RUN git clone ${ZCASH_URL}

WORKDIR /src/zcash

ENV ZCASH_VERSION=v1.1.0 \
    ZCASH_CONF=/home/zcash/.zcash/zcash.conf

RUN git checkout ${ZCASH_VERSION}

RUN ./zcutil/build.sh -j$(nproc)

WORKDIR /src/zcash/src

RUN /usr/bin/install -c zcash-tx zcashd zcash-cli zcash-gtest -t /usr/local/bin/ && \
    adduser --uid 1000 --system zcash && \
    mkdir -p /home/zcash/.zcash/ && \
    chown -R zcash /home/zcash && \
    echo "Success"

USER zcash
RUN echo "rpcuser=zcash" > ${ZCASH_CONF} && \
        echo "rpcpassword=`pwgen 20 1`" >> ${ZCASH_CONF} && \
        echo "addnode=mainnet.z.cash" >> ${ZCASH_CONF} && \
        echo "Success"

VOLUME ["/home/zcash/.zcash"]
