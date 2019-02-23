function    usage {
    echo  "Usage: ./chain-test.sh    install | instantiate | invoke | query "
    echo  "Utility for testing peeer/channel setup with chaincode"
}

export FABRIC_LOGGING_SPEC=info

OPERATION=$1

export CC_CONSTRUCTOR='{"Args":[]}'
export CC_NAME="marbles"
export CC_PATH="chaincodes/go/marbles"
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
    "query")
            peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME -c '{"Args":["readMarble","marble1"]}'
            peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME -c '{"Args":["getMarblesByRange","marble1","marble3"]}'
            peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME -c '{"Args":["getHistoryForMarble","marble1"]}'
        ;;
    
    "invoke")
            echo "Invoke marbles"
            peer chaincode invoke -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["initMarble","marble1","blue","35","tom"]}'
            peer chaincode invoke -C $CC_CHANNEL_ID -n $CC_NAME  -c  '{"Args":["initMarble","marble2","red","50","tom"]}'
            peer chaincode invoke -C $CC_CHANNEL_ID -n $CC_NAME  -c  '{"Args":["initMarble","marble3","blue","70","tom"]}'
            sleep 2s
            peer chaincode invoke -C $CC_CHANNEL_ID -n $CC_NAME  -c  '{"Args":["transferMarble","marble2","jerry"]}'
            sleep 2s
            peer chaincode invoke -C $CC_CHANNEL_ID -n $CC_NAME  -c  '{"Args":["transferMarblesBasedOnColor","blue","jerry"]}'
            peer chaincode invoke -C $CC_CHANNEL_ID -n $CC_NAME  -c  '{"Args":["delete","marble1"]}'
        ;;
    "clear")
            echo "Cleaning up Chaincode Docker images"
            docker rmi -f $(docker images -q | grep dev-)
        ;;
    *) usage
        ;;
esac



