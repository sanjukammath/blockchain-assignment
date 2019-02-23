if [ -z $1 ];
then
    ORDERER_ADDRESS="localhost:7050"
else
    ORDERER_ADDRESS=$1
fi

if [ -z $1 ];
then
    CHANNEL_NAME=healthcarechannel
else
    CHANNEL_NAME=$2
fi


GENESIS_BLOCK=healthcare-channel.block

echo "Using ORDERER_ADDRESS=$ORDERER_ADDRESS"

peer channel fetch config $GENESIS_BLOCK -o $ORDERER_ADDRESS -c $CHANNEL_NAME

peer channel join -o $ORDERER_ADDRESS -b $GENESIS_BLOCK

rm $GENESIS_BLOCK 2> /dev/null