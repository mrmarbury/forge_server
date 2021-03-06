#!/usr/local/bin/bash
# This file was taken from the Feed the Beast guys and adapted
# to my needs (https://feed-the-beast.com)
###################
# Managed by Chef #
###################

# Fix work directory
# Some GUIs set wrong working directory which breaks relative paths
cd -- "$(dirname "$0")"

# makes things easier if script needs debugging
if [ x${FORGE_VERBOSE} = xyes ]; then
    set -x
fi


. ./settings-local.sh


# cleaner code
eula_false() {
    grep -q 'eula=false' eula.txt
    return $?
}

# cleaner code 2
start_server() {
    "$JAVACMD" -server -Xms${MIN_RAM} -Xmx${MAX_RAM} ${JAVA_PARAMETERS} -jar ${FORGE_UNIVERSAL_JAR} nogui
}

# check eula.txt
if [ -f eula.txt ] && eula_false ; then
    echo "Make sure to read eula.txt before playing!"
    echo "To exit press <enter>"
    read ignored
    exit
fi

# if eula.txt is missing inform user and start MC to create eula.txt
if [ ! -f eula.txt ]; then
    echo "Missing eula.txt. Startup will fail and eula.txt will be created"
    echo "Make sure to read eula.txt before playing!"
    echo "To continue press <enter>"
    read ignored
fi

echo "Starting server"
rm -f autostart.stamp
start_server

while [ -e autostart.stamp ] ; do
    rm -f autostart.stamp
    echo "If you want to completely stop the server process now, press Ctrl+C before the time is up!"
    for i in 5 4 3 2 1; do
        echo "Restarting server in $i"
        sleep 1
    done
    echo "Rebooting now!"
    start_server
    echo "Server process finished"
done

