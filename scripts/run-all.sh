#This script will bring up a hyperledger fabric network.
cd /vagrant/fabric-ca/scripts

./run-all-caserver.sh

cd /vagrant/orderer/scripts

./run-all-orderer.sh

cd /vagrant/peers/scripts

./run-all-peers.sh

source set-env.sh hospital 7050 admin

./chain-test-solution.sh install

source set-env.sh lab 9050 admin

./chain-test-solution.sh install