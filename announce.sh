#!/bin/bash
# announce.sh: Announce stream to a Discord channel.
#
# https://github.com/noodlebox/KawaiiBot
#
# Requires 'curl' and 'jq'
#
# Add the following to your nginx-rtmp config:
#     exec_kill_signal term;
#     exec_push /path/to/announce.sh;
#
# Make sure announce.sh is marked executable for nginx's user.
#
# nginx-rtmp also supports passing along parameters with some information
# about the stream, so you could easily extend this script to handle those.

set -e

message_start="@here ~(' - ' ~) **STREAM IS LIVE** (~ ' - ')~"
message_stop="( ' - ') Stream's over, go home ( . - .)"
username='Stream Announcement'

stream_title='Stream Title'
stream_desc='A short message about the stream'
stream_url='https://example.com/stream_page'
# color = (r << 16) + (g << 8) + b
color='16764108'

id='WEBHOOK_ID'
token='WEBHOOK_TOKEN'
url="https://discordapp.com/api/webhooks/$id/$token"

webhook_post() {
	curl --header 'Content-Type: application/json' --data-raw "$(</dev/fd/0)" "$1"
}

webhook_encode() {
	jq -c -n --arg content "$1" --arg username "$2" --argjson embeds "$(</dev/fd/0)" \
		'{$content, $username, $embeds}'
}

webhook_embed_encode() {
	jq -c -n --arg title "$1" --arg description "$2" --arg url "$3" --argjson color "$4" \
		'[{$title, $description, $url, $color}]'
}

announce_start() {
	webhook_embed_encode "$stream_title" "$stream_desc" "$stream_url" "$color" \
		| webhook_encode "$message_start" "$username" \
		| webhook_post "$url"
}

announce_stop() {
	webhook_encode "$message_stop" "$username" <<<'[]' \
		| webhook_post "$url"
}

sleep 2 || exit

trap 'announce_stop; exit' INT TERM

announce_start

while sleep 10; do :; done

announce_stop
