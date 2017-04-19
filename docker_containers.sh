#!/usr/bin/env bash
PATH="$PATH:/usr/local/bin"
MACHINE="$1"
MACHINES=$(docker-machine ls -q | grep "$MACHINE")
MACHINE_STATUS=$(docker-machine status "$MACHINE" 2> /dev/null)
VALID_MACHINE=$?
echo "<?xml version='1.0'?><items>"
CONTAINERS="$(docker ps --format "{{.Names}} ({{.Image}})|Running for: {{.RunningFor}}|{{.ID}}")"
if [ "$CONTAINERS" != "" ]
then
  while read -r CONTAINER
  do
    CONTAINER_ID=$(echo "$CONTAINER" | sed 's/.*|//')
    CONTAINER_NAME=$(echo "$CONTAINER" | sed 's/|.*//')
    CONTAINER_SUBTITLE=$(echo "$CONTAINER" | sed 's/.*|\(.*\)|.*/\1/')
    echo "<item arg=\"container stop '$MACHINE' '$CONTAINER_ID'\">"
    echo "  <title>Shut down $CONTAINER_NAME</title>"
    echo "  <subtitle>$CONTAINER_SUBTITLE</subtitle>"
    echo "</item>"
  done <<< "$CONTAINERS"
fi
echo "</items>"
