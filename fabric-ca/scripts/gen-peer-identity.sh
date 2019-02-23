function usage {
    echo "./gen-peer-identity.sh ORG_NAME  PEER_NAME"
    echo "     Sets up the Peer identity and MSP"
    echo "     Script will fail if CA Server is not running!!!"
}

# Check if ORG_NAME passed
if [ -z $1 ];
then
    usage
    echo "Please provide the ORG Name!!!"
    exit 0
else
    ORG_NAME=$1
fi

if [ -z $2 ];
then
    usage
    echo  "Please specify PEER_NAME!!!"
    exit 0
else
    PEER_NAME=$2
fi

source set-client-home.sh $ORG_NAME  admin

fabric-ca-client register --id.type peer --id.name $PEER_NAME --id.secret pw --id.affiliation $ORG_NAME 
echo "======Completed: Step 1 : Registered peer===="

ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME

source set-client-home.sh $ORG_NAME  $PEER_NAME


fabric-ca-client enroll -u http://$PEER_NAME:pw@localhost:7054

echo "======Completed: Step 3 : Enrolled $PEER_NAME ========"

mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp $ADMIN_CLIENT_HOME/msp/signcerts/*    $FABRIC_CA_CLIENT_HOME/msp/admincerts

echo "======Completed: Step 4 : MSP setup for the peer========"

echo "======Peer identity setup with Enrollment ID=$PEER_NAME"

