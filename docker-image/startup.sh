#!/bin/sh
set -e

function shutdown {
  echo "Trigger shutdown"
  bin/asadmin stop-domain domain1
}
trap shutdown SIGTERM SIGINT

bin/asadmin start-domain --verbose=true --debug=true domain1 &
wait