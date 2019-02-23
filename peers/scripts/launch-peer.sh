if [ -z $1 ];
then
    echo "Please provide the ORG Name!!!"
    exit 0
else
    ORG_NAME=$1
fi

if [ -z $2 ]
then
    PORT_NUMBER_BASE=7050  
else
    PORT_NUMBER_BASE=$2
fi

if [ -z $3 ];
then
    PEER_NAME=hospital-peer1
    echo "Using the default PEER_NAME=$PEER_NAME"
else 
    PEER_NAME=$3
fi


source set-env.sh   $ORG_NAME  $PORT_NUMBER_BASE   $PEER_NAME

export CORE_PEER_FILESYSTEMPATH="$HOME/peers/$PEER_NAME/ledger" 

mkdir -p $CORE_PEER_FILESYSTEMPATH

export CORE_PEER_ID=$PEER_NAME

PEER_LOGS="../$PEER_NAME.log"
peer node start 2> $PEER_LOGS &

echo "====>PLEASE Check Peer Log under  $PEER_LOGS"
echo "====>Make sure there are no errors!!!"