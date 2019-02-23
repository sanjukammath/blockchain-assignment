CHANNEL_NAME=healthcarechannel
CHANNEL_TX_FILE=../../artefacts/healthcare-channel.tx 

if [ -z $1 ];
then
    ORDERER_ADDRESS="localhost:7050"
else
    ORDERER_ADDRESS=$1
fi

if [ $2 ];
then 
    CHANNEL_NAME=$2
    if [ -z $3 ];
    then 
        echo "Please provide the path to 'create channel tx' !!!"
        exit 0
    else
        CHANNEL_TX_FILE=$3
    fi  
fi

echo "Using ORDERER_ADDRESS=$ORDERER_ADDRESS"

peer channel create -o $ORDERER_ADDRESS -c $CHANNEL_NAME -f $CHANNEL_TX_FILE --outputBlock ../$CHANNEL_NAME-genesis.block
