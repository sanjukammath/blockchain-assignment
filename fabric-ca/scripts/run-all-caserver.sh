export FABRIC_CA_SERVER_HOME=$PWD/../server 
export FABRIC_CA_CLIENT_HOME=$PWD/../client

echo  "Initializing the fabric CA Server"
./init-fabric-ca.sh

echo  "Launching the CA Server and sleep for 3 seconds"
./launch-caserver.sh  &

sleep  3s

echo  "Generating Admin Identities for orderer, hospital and lab"
./gen-admin-identities.sh

echo  "+++Setting up the organization MSP(s)"
./create-org-msp.sh

echo  "++Creating the Orderer Identity"
./gen-orderer-identity.sh

echo  "+Creating the 2 Peer Identities"
./gen-peer-identity.sh hospital hospital-peer1
./gen-peer-identity.sh lab lab-peer1

./gen-users-identity.sh

killall fabric-ca-server  &> /dev/null

echo  "DONE. Launch CA Server using ./launch-caserver.sh"
echo  "PS: Ignore the termination message. The server has completed it's work"

