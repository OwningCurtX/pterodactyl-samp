#!/bin/bash

CHK_FILE="/home/container/samp03svr"
if [ -f $CHK_FILE ]; then
    echo "Executable of SAMP exists, not downloading. To update, delezte samp03svr."
else
    mkdir -p /home/container/.tmp-build
    cd /home/container/.tmp-build

    echo "> curl -sSLO http://files.sa-mp.com/samp037svr_R2-1.tar.gz"
    curl -sSLO http://files.sa-mp.com/samp037svr_R2-1.tar.gz

    echo "> tar -xjvf samp037svr_R2-1.tar.gz"
    tar -zxf samp037svr_R2-1.tar.gz

    cp -r samp03/* /home/container/
    rm -r /home/container/.tmp-build
    cd /home/container
    chmod 700 *
fi

if [ -f "/home/container/server.cfg" ]; then
    echo "server.cfg exists, not generating file."
    echo "GameNode.Pro: Checking max player slot."
    if [[ $(grep "maxplayers ${STARTUP}" /home/container/server.cfg) ]]; then 
        echo "GameNode.Pro: Nothing wrong on max player slot. Continuing the process..."
    else
echo "GameNode.Pro: There's wrong on max player slot. Generating another configuration file."
rm /home/container/server.cfg
echo "lanmode 0
rcon_password change-this-rcon-password-gamenodepro
maxplayers ${STARTUP}
port ${SERVER_PORT}
hostname SA-MP 0.3 Server
gamemode0 grandlarc 1
filterscripts base gl_actions gl_property gl_realtime
announce 0
query 1
weburl www.sa-mp.com
maxnpc 0
onfoot_rate 40
incar_rate 40
weapon_rate 40
stream_distance 300.0
stream_rate 1000" > /home/container/server.cfg
    fi
else
echo "lanmode 0
rcon_password change-this-rcon-password-gamenodepro
maxplayers ${STARTUP}
port ${SERVER_PORT}
hostname SA-MP 0.3 Server
gamemode0 grandlarc 1
filterscripts base gl_actions gl_property gl_realtime
announce 0
query 1
weburl www.sa-mp.com
maxnpc 0
onfoot_rate 40
incar_rate 40
weapon_rate 40
stream_distance 300.0
stream_rate 1000" > server.cfg
fi

set -e
cd /home/container
echo ":/home/container$ ./samp03svr"

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)
exec ./samp03svr -n -t -u
