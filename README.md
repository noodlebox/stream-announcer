# KawaiiBot
A simple Discord bot for announcing streams (and probably some other things)

## announce.sh
Simple shell script that posts a stream announcement to a Discord channel.

### Requires
- curl
- jq

### Setup
Configure by setting the variables at the top of the script.

### Usage with nginx-rtmp
Add this to a server, rtmp, or application block:
```
exec_kill_signal term;
exec_push /path/to/announce.sh;
```
Make sure announce.sh is marked executable for nginx's user.

nginx-rtmp also supports passing along parameters with some information
about the stream, so you could easily extend this script to handle those.
