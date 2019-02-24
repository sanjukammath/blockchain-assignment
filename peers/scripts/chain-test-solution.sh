function    usage {
    echo  "Usage: ./chain-test.sh    install | instantiate | create1 | query1 | vitals1 "
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

echo "CC Operation : $OPERATION    for   Org: $CURRENT_ORG_NAME"

# Invoke the "peer chain code" command using the operation
case $OPERATION in
    "install") 

              cp -r /vagrant/chaincodes $GOPATH/src/
              peer chaincode install  -n $CC_NAME -p $CC_PATH -v $CC_VERSION

              peer chaincode list --installed -C $CC_CHANNEL_ID
        ;;
    "instantiate")
              peer chaincode instantiate -C $CC_CHANNEL_ID -n $CC_NAME  -v $CC_VERSION -c $CC_CONSTRUCTOR  -o $ORDERER_ADDRESS
        ;;
    "query1")
            peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME -c '{"Args":["queryRecord","patient01@hospital.com"]}'
        ;;
    "query2")
            peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME -c '{"Args":["queryRecord","patient02@hospital.com"]}'
        ;;
    
    "create1")
            echo "Create Patient Record 1"
            peer chaincode invoke -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["createRecord","patient01@hospital.com","a,b","c,d","e,f","g,h","i,j"]}'
        ;;
    
    "create2")
            echo "Create Patient Record 1"
            peer chaincode invoke -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["createRecord","patient02@hospital.com","a,b","c,d","e,f","g,h","i,j"]}'
        ;;

    "vitals1")
            peer chaincode invoke -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["updateRecordforLab","patient01@hospital.com","normal","normal"]}'
        ;;
    "vitals2")
            peer chaincode invoke -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["updateRecordforLab","patient02@hospital.com","normal","abnormal"]}'
        ;;
    *) usage
        ;;
esac
