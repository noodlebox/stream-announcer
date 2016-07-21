# KawaiiBot
A simple Discord bot for announcing streams (and probably some other things)

## announce.sh
Simple shell script that posts and pins an announcement to a Discord channel, 
or unpins a previous announcement.

### Requires
- curl
- jq

### Setup
Configure by setting the variables at the top of the script.

### Usage with nginx-rtmp
Add this to a server, rtmp, or application block:
```
exec_publish /path/to/announce.sh start;
exec_publish_done /path/to/announce.sh stop;
```
nginx-rtmp also supports passing along parameters with some information
about the stream, so you could easily extend this script to handle those.
