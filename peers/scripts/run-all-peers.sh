echo "++++++ Cleaning the previous run"
./clean.sh

echo "+++++ Creating the application channel = healthcarechannel"
. set-env.sh  hospital  7050   admin
./create-channel.sh

echo "++++ Sleeping for 3 seconds"
sleep 3s

echo "+++ hospital-peer1 Launching & Joining airlinechannel - will sleep for 3 seconds"
. set-env.sh  hospital  7050   admin
./launch-peer.sh hospital  7050   hospital-peer1
sleep 3s
./join-channel.sh

echo "+ lab-peer1 Launching & Joining airlinechannel - will sleep for 3 seconds"
. set-env.sh  lab  9050   admin
./launch-peer.sh lab  9050   lab-peer1
sleep 3s
./join-channel.sh

echo "Done. All peers launched in background. Please check peer logs at /peers"
