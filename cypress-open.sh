MIX_ENV=systemtest mix ecto.reset # Need a blank database
echo "===STARTING PHX SERVER==="
MIX_ENV=systemtest mix phx.server &
pid=$! # Store server pid
./assets/node_modules/.bin/cypress open
result=$?
kill -9 $pid # Kill server
echo "===KILLING PHX SERVER==="
exit $result # Return test result