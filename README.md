# Docker image for CS 1.6
## Description
This image is based on debian:stable-slim and the game is set up via steamcmd and works with Steam clients. 
Plugins added:
- rehlds is used instead of regular hlds
- metamod 1.3.128
- regamedll 5.18.0.475
- amxmodx 1.10.0-git5406
- podbot 3.2

## Usage 
Create and run docker-compose file:
```yaml
version: '2'
services:
  cs16:
    container_name: cs16
    image: madguru/cs16:latest
    volumes:
      - /path/to/cs/data:/home/cs/Steam/cs16/cstrike/data
    environment:
      - TERM=xterm-256color
      - HOSTNAME=Amazing CS
      - RCON_PASSWORD=bla123
      - BOT_ADMIN_PASSWORD=bla123
      - PORT=27015
      - MAXPLAYERS=16
      - START_MAP=fy_iceworld
      - ADMIN_USER='"STEAM_0:0:1234567" "" "abcdefghijklmnopqrstu" "ce"'
      - MP_BUYTIME=0.3
      - MP_C4TIMER=30
      - MP_FREEZETIME=1
      - MP_ROUNDTIME=2
      - MP_TIMELIMIT=25
    ports:
      - "0.0.0.0:27015:27015"
      - "0.0.0.0:27015:27015/udp"
```
To use bots, add environment variable `BOTS_ENABLED=Yes` to enable plugin and `BOT_ADMIN_PASSWORD` with admin password to manage bots.

Also you can run directly with docker run command:
```bash
docker run --name cs16 -p 27015:27015/udp -p 27015:27015 -e HOSTNAME="Amazing-CS" -e RCON_PASSWORD="bla123" madguru/cs16:latest
```