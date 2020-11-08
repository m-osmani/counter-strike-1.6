#!/usr/bin/env bash

HOSTNAME=${HOSTNAME:-"MYCS"}
RCON_PASSWORD=${RCON_PASSWORD:-"blablabla"}
PORT=${PORT:-"27015"}
MAXPLAYERS=${MAXPLAYERS:-"8"}
START_MAP=${START_MAP:-"fy_snow"}
ADMIN_USER=${ADMIN_USER:-'"STEAM_0:0:123456" "" "abcdefghijklmnopqrstu" "ce"'}
MP_BUYTIME=${MP_BUYTIME:-"0.25"}
MP_C4TIMER=${MP_C4TIMER:-"35"}
MP_FREEZETIME=${MP_FREEZETIME:-"3"}
MP_ROUNDTIME=${MP_ROUNDTIME:-"1.75"}
MP_TIMELIMIT=${MP_TIMELIMIT:-"20"}
BOT_ADMIN_PASSWORD=${BOT_ADMIN_PASSWORD:-"blablabla"}

echo "hostname \"${HOSTNAME}\"" >> cstrike/server.cfg
echo "rcon_password \"${RCON_PASSWORD}\"" >> cstrike/server.cfg
echo "mp_buytime \"${MP_BUYTIME}\"" >> cstrike/server.cfg
echo "mp_c4timer \"${MP_C4TIMER}\"" >> cstrike/server.cfg
echo "mp_freezetime \"${MP_FREEZETIME}\"" >> cstrike/server.cfg
echo "mp_roundtime \"${MP_ROUNDTIME}\"" >> cstrike/server.cfg
echo "mp_timelimit \"${MP_TIMELIMIT}\"" >> cstrike/server.cfg
echo $ADMIN_USER >> cstrike/addons/amxmodx/configs/users.ini

sed -i "s/pb_password \"your_password\"/pb_password \"${BOT_ADMIN_PASSWORD}\"/g" cstrike/addons/podbot/podbot.cfg

if [ ! -d "cstrike/data" ] 
then
    echo "Creating data folder cstrike/data .."
    mkdir -p cstrike/data
    cp -r cstrike/addons/amxmodx/data/* cstrike/data/
    echo "Creating data folder has done."
else
    if [ ! -f "cstrike/data/csstats.amxx" ]; then
        cp -r cstrike/addons/amxmodx/data/* cstrike/data/
    fi
fi


cat <<EOT > cstrike/addons/amxmodx/configs/stats.ini

KillerChat
ShowAttackers
ShowVictims
ShowKiller
ShowTeamScore
ShowTotalStats
ShowBestScore
ShowMostDisruptive
ShowStats
ShowDistHS
EndPlayer
EndTop15
SayHP
SayStatsMe
SayRankStats
SayMe
SayRank
SayReport
SayScore
SayTop15
SayStatsAll
SpecRankInfo
EOT

if [[ $BOTS_ENABLED == "Yes" ]]
then
    echo "linux addons/podbot/podbot_mm_i386.so" >> cstrike/addons/metamod/plugins.ini
else
    echo "Bots are disabled"
fi

./hlds_run -game cstrike -strictportbind -ip 0.0.0.0 -port $PORT +sv_lan 0 +map $START_MAP -maxplayers $MAXPLAYERS