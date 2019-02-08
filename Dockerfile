# based on jaysonsantos/docker-minecraft-ftb-skyfactory3

FROM java:8

MAINTAINER minecraft@h-r-l.co.uk

# manual upgrades (for now)
# when you upgrade, you are responsible for removing the duplicate mods from your ./mods folder on your volume.
ENV VERSION=3.0.8

VOLUME /data

RUN apt-get update && \
    apt-get install -y wget unzip && \
    apt-get clean && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*
    
RUN adduser --disabled-password --home=/data --uid 1234 --gecos "minecraft user" minecraft

RUN cd /data/ && wget -c https://media.forgecdn.net/files/2570/735/SevTech_Ages_Server_${VERSION}.zip -O sevtech.zip && \
	unzip sevtech.zip && \
	rm sevtech.zip && \
	chown -R minecraft /data && \
	bash /data/Install.sh

USER minecraft

EXPOSE 25565

ADD start.sh /start

ADD server.properties /data/server.properties
WORKDIR /data

CMD /start

ENV MOTD Sevtech ${VERSION} CAVEMAN on docker
ENV JVM_OPTS -Xms4096m -Xmx4096m
ENV FLIGHT true 
# test