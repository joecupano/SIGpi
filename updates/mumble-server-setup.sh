#!/bin/bash

###
### Mumble-Server-Setup
### 

##
## Setting /etc/mumble-server.ini
##
cat <<EOF
autobanAttempts=3
autobanTimeframe=30
autobanTime=60
users=3
channelcountlimit=3
textmessagelength=140

EOF




