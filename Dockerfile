FROM debian:stable-slim



# Add i386 libraries
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt-get -y install lib32gcc1 curl wget unzip libsdl2-2.0-0:i386 lib32stdc++6

# Add unprivileged used for runing server
RUN groupadd --gid 1000 cs && \
    adduser --gid 1000 --uid 1000 --disabled-password --system --home /home/cs cs

# Install Counter-Strike 1.6
RUN mkdir -p /home/cs/Steam /home/cs/.steam && \
    ls -lah /home/cs && \
    cd /home/cs/Steam && \
    curl -sqL "http://media.steampowered.com/client/steamcmd_linux.tar.gz" | tar zxvf - && \
    bash /home/cs/Steam/steamcmd.sh +login anonymous +force_install_dir /home/cs/Steam/cs16 +app_update 90 validate +quit || true && \
    bash /home/cs/Steam/steamcmd.sh +login anonymous +force_install_dir /home/cs/Steam/cs16 +app_update 90 validate +quit && \
    ln -s /home/cs/Steam/linux32 /home/cs/.steam/sdk32

WORKDIR /home/cs/Steam/cs16

# Install addons
RUN mkdir -p cstrike/addons/metamod/dlls cstrike/addons/regamedll && \
    wget https://github.com/dreamstalker/rehlds/releases/download/3.7.0.698/rehlds-dist-3.7.0.698-dev.zip -O /tmp/rehlds.zip && \
    unzip /tmp/rehlds.zip -d /tmp/ && cp -r /tmp/bin/linux32/* /home/cs/Steam/cs16 && rm -rf /tmp/* && \
    wget https://github.com/theAsmodai/metamod-r/releases/download/1.3.128/metamod_1.3.0.128.zip -O /tmp/metamod.zip && \
    unzip /tmp/metamod.zip -d /tmp/ && \
    cp /tmp/addons/metamod/metamod_i386.so cstrike/addons/metamod/ && rm -rf /tmp/* && \
    wget https://github.com/s1lentq/ReGameDLL_CS/releases/download/5.18.0.475/regamedll-dist-5.18.0.475-dev.zip -O /tmp/regamedll.zip && \
    unzip /tmp/regamedll.zip -d /tmp/ && cp /tmp/bin/linux32/cstrike/dlls/cs.so cstrike/addons/regamedll/cs.so && \
    cp /tmp/bin/linux32/cstrike/*.cfg cstrike/ && rm -rf /tmp/* && \
    curl -sqL "https://www.amxmodx.org/amxxdrop/1.10/amxmodx-1.10.0-git5406-base-linux.tar.gz" | tar -C cstrike/ -zxvf - && \
    curl -sqL "https://www.amxmodx.org/amxxdrop/1.10/amxmodx-1.10.0-git5406-cstrike-linux.tar.gz" | tar -C cstrike/ -zxvf -


COPY resources/* cstrike/
ADD podbot cstrike/addons/podbot
ADD server.cfg cstrike/server.cfg
ADD mapcycle.txt cstrike/mapcycle.txt
ADD liblist.gam cstrike/liblist.gam
ADD game.cfg cstrike/game.cfg
ADD plugins.ini cstrike/addons/metamod/plugins.ini
ADD metamod_config.ini cstrike/addons/metamod/config.ini
ADD maps.ini cstrike/addons/amxmodx/configs/maps.ini
ADD users.ini cstrike/addons/amxmodx/configs/users.ini
ADD core.ini cstrike/addons/amxmodx/configs/core.ini
ADD entrypoint.sh /home/cs/entrypoint.sh
RUN chown -R cs:cs /home/cs && \
    chmod +x /home/cs/entrypoint.sh

USER cs
ENTRYPOINT /home/cs/entrypoint.sh
