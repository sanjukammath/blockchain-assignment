This is a solution for the following problem statement:

In healthcare, a patient has their health record fragmented across multiple locations e.g. labs, hospital etc. In a decentralized world, how can you make sure that these records can be stored on blockchain and can help patients to access them anywhere they want. & obviously, as medical records are a very personal entity, we want you to write the smart contract that is going to secure a single piece of data so that only patient can access it.

Hyperledger Fabric Based Solution:

Identity affiliations available (replaced in the fabric-ca-server-config.yaml via script):
affiliations:
   orderer:
      - support
   hospital:
      - doctors
      - accounting
      - patients
   lab:
      - technician

The patientrecords chaincode is used to control the patient records ledger. This is deployed in the patients channel. The patient is identified by his email id. Both hospital and lab orgs will be joining this channel. The queryRecord and queryHistory methods in the chaincode are access controlled.

HOW TO TEST (using scripts)

vagrant up (may take around 7 minutes)

vagrant ssh

cd fabric-ca/scripts

./run-all-caserver.sh
this command creates the various basic identities(admin, orgs, orderer, peers). Once it is done, ca server will be down.

./launch-caserver.sh
the ca-server will now be 'Listening on http://0.0.0.0:7054'

open a new terminal

vagrant up (only if you get error if you try directly vagrnt ssh)

vagrant ssh

cd orderer/scripts

./run-all-orderer.sh
this will create the genesis block, channel transaction file and then brings up the orderer
please check orderer logs (orderer/orderer.log), everything should be fine

cd ../../peers/scripts

./run-all-peers.sh
this will bring up the peers.

we will now install the chaincode one by one on each of the peers.

. set-env.sh hospital admin

./chain-test-solution.sh install

./chain-test-solution.sh instantiate

./chain-test-solution.sh create1

this should give error because admin is not doctor.

. set-env.sh hospital doctor01

./chain-test-solution.sh query1




