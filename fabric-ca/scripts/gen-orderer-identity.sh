
source set-client-home.sh orderer admin

fabric-ca-client register --id.type orderer --id.name orderer --id.secret pw --id.affiliation orderer 
echo "====Completed: Registered orderer===="

ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME

source set-client-home.sh orderer orderer

fabric-ca-client enroll -u http://orderer:pw@localhost:7054
echo "======Completed: Enrolled orderer ========"

mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp $ADMIN_CLIENT_HOME/msp/signcerts/*    $FABRIC_CA_CLIENT_HOME/msp/admincerts

echo "======Completed: MSP setup for the orderer========"





