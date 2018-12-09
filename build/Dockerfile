FROM kylemanna/bitcoind

RUN apt-get update && apt-get install -y netcat curl

ADD src/btc_init /usr/local/bin
ADD src/* /sbin/
