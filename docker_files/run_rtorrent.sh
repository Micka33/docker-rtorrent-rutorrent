#!/bin/sh
export HOME="/root"
rm -f /root/mounted/session/rtorrent.lock
exec rtorrent > /dev/null 2>&1
