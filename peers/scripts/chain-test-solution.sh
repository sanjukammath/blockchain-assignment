function    usage {
    echo  "Usage: ./chain-test.sh    install | instantiate | invoke | query "
    echo  "Utility for testing peeer/channel setup with chaincode"
}

export FABRIC_LOGGING_SPEC=info

OPERATION=$1

export CC_CONSTRUCTOR='{"Args":[]}'
export CC_NAME="solution"
export CC_PATH="chaincodes/go/PatientRecords"
export CC_VERSION="1.0"
export CC_CHANNEL_ID="healthcarechannel"

if [ ! -z $ORDERER_ADDRESS ]; then
    echo "Using the Orderer=$ORDERER_ADDRESS"
else
echo "Setting the Orderer to localhost:7050"
    ORDERER_ADDRESS="localhost:7050"
fi

export GOPATH=/vagrant/misc/gopath
export PATH=$PATH:/usr/lib/go-1.10/bin

cp -r /vagrant/chaincodes $GOPATH/src/



echo "CC Operation : $OPERATION    for   Org: $CURRENT_ORG_NAME"

# Invoke the "peer chain code" command using the operation
case $OPERATION in
    "install") 
              peer chaincode install  -n $CC_NAME -p $CC_PATH -v $CC_VERSION

              peer chaincode list --installed -C $CC_CHANNEL_ID
        ;;
    "instantiate")
              peer chaincode instantiate -C $CC_CHANNEL_ID -n $CC_NAME  -v $CC_VERSION -c $CC_CONSTRUCTOR  -o $ORDERER_ADDRESS
        ;;
    "query1")
            peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME -c '{"Args":["readMarble","marble1"]}'
            peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME -c '{"Args":["getMarblesByRange","marble1","marble3"]}'
            peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME -c '{"Args":["getHistoryForMarble","marble1"]}'
        ;;
    
    "create1")
            echo "Create Patient Record 1"
            peer chaincode invoke -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["createRecord","patient01@hospital.com","a,b","c,d","e,f","g,h"]}'
        ;;
    "clear")
            echo "Cleaning up Chaincode Docker images"
            docker rmi -f $(docker images -q | grep dev-)
        ;;
    *) usage
        ;;
esac



