#!/bin/bash

# For a command line such as:
# "/home/jovyan/entrypoint.sh jupyter notebook --ip 0.0.0.0 --port 59537 --NotebookApp.custom_display_url=http://127.0.0.1:59537"
# strip out most args, just pass on the port
set -x 

collect_port=0
port="5901"
delim='='

for var in "$@"
do
    echo "$var"

    if [ "$collect_port" == "1" ]; then
       echo "Collecting external port $var"
       port=$var
       collect_port=0
    fi

    splitarg=${var%%$delim*}

    if [ "$splitarg" == "--port" ]; then
       if [ ${#splitarg} == ${#var} ]; then
         collect_port=1
       else
         port=${var#*$delim}
         echo "Setting external port $port"
       fi
    fi
done

destport=$((port + 1))

echo "Using internal port $destport"

#jhsingle-native-proxy --port $port --destport $destport code-server {--}auth none {--}bind-addr 0.0.0.0:$destport {--}user-data-dir /workspace /workspace
jhsingle-native-proxy --port $port --destport $destport websockify {-}v {--}web /opt/install/jupyter_desktop/share/web/noVNC-1.1.0 {--}heartbeat 30 $destport  {--} /bin/sh {-}c 'cd /opt/install && /usr/local/bin/vncserver -verbose -xstartup /opt/install/jupyter_desktop/share/xstartup -geometry 1680x1050 -SecurityTypes None -fg :1'



