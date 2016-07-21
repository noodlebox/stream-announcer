#!/bin/sh
# announce.sh: Announce something to a Discord channel and pin the message.
#
# https://github.com/noodlebox/KawaiiBot
#
# Requires 'curl' and 'jq'
#
# NOTE: You will need to have successfully established a Gateway connection
#       with your bot's token once before your bot can post messages.
#
# Add the following to your nginx-rtmp config:
#     exec_publish /path/to/announce.sh start;
#     exec_publish_done /path/to/announce.sh stop;
#
# nginx-rtmp also supports passing along parameters with some information
# about the stream, so you could easily extend this script to handle those.

MESSAGE_ID_FILE='/var/tmp/message.id'
LOG_FILE='/dev/null'

CHANNEL='YOUR_CHANNEL'
MESSAGE_START='@everyone Stream is starting! \u003chttp://example.com/\u003e'
MESSAGE_STOP='Stream has ended!'

BOT_TOKEN='YOUR_BOT_TOKEN'
BOT_URL='https://github.com/noodlebox/KawaiiBot'
BOT_VERSION='0.1'

ENDPOINT_API='https://discordapp.com/api'

case "$1" in
	start)
	curl "$ENDPOINT_API"'/channels/'"$CHANNEL"'/messages' \
		--header 'User-Agent: DiscordBot ('"$BOT_URL"', '"$BOT_VERSION"')' \
		--header 'Authorization: Bot '"$BOT_TOKEN" \
		--header 'Content-Type: application/json' \
		--data '{"content":"'"$MESSAGE_START"'","tts":false}' \
		--silent \
		| tee -a "$LOG_FILE" | jq -r '.id' >"$MESSAGE_ID_FILE"

	curl "$ENDPOINT_API"'/channels/'"$CHANNEL"'/pins/'"$(cat <"$MESSAGE_ID_FILE")" \
		-X 'PUT' \
		--header 'User-Agent: DiscordBot ('"$BOT_URL"', '"$BOT_VERSION"')' \
		--header 'Authorization: Bot '"$BOT_TOKEN" \
		--data '{}' \
		--silent \
		>>"$LOG_FILE"
	;;
	stop)
	[ ! -f "$MESSAGE_ID_FILE" ] && exit

	curl "$ENDPOINT_API"'/channels/'"$CHANNEL"'/messages' \
		--header 'User-Agent: DiscordBot ('"$BOT_URL"', '"$BOT_VERSION"')' \
		--header 'Authorization: Bot '"$BOT_TOKEN" \
		--header 'Content-Type: application/json' \
		--data '{"content":"'"$MESSAGE_STOP"'","tts":false}' \
		--silent \
		>>"$LOG_FILE"

	curl "$ENDPOINT_API"'/channels/'"$CHANNEL"'/pins/'"$(cat <"$MESSAGE_ID_FILE")" \
		-X 'DELETE' \
		--header 'User-Agent: DiscordBot ('"$BOT_URL"', '"$BOT_VERSION"')' \
		--header 'Authorization: Bot '"$BOT_TOKEN" \
		--silent \
		>>"$LOG_FILE"

	rm "$MESSAGE_ID_FILE"
	;;
	*)
	echo "Usage: $0 {start|stop}"
	exit 1
	;;
esac

exit 0
