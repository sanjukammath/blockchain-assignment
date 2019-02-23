#!/bin/bash
function usage {
    echo ". set-env.sh   ORG_NAME  [PORT_NUMBER_BASE default=7050]   [IDENTITY default=admin]"
    echo "               Sets the environment variables for the peer"
    echo "               To set  the context to ORG Admin > . set-env.sh  hospital   > . set-env.sh  lab 8050 "
}

export FABRIC_LOGGING_SPEC=info  #debug  #info #warning

echo "Current Identity Context: $CURRENT_ORG_NAME     $CURRENT_IDENTITY"

if [ -z $3 ];
then
    IDENTITY=admin
else
    IDENTITY=$3
fi

if [ -z $1 ];
then
    usage
    echo "Please provide the ORG Name!!!"
    return
else
    ORG_NAME=$1
    echo -e "Switching IDENTITY Context to Org = $ORG_NAME  $IDENTITY"
fi

PORT_NUMBER_BASE=7050
if [ -z $2 ]
then
    echo "Setting PORT_NUMBER_BASE=7050"   
else
    PORT_NUMBER_BASE=$2
    echo "Setting PORT_NUMBER_BASE=$2"
fi

CRYPTO_CONFIG_ROOT_FOLDER="$PWD/../../fabric-ca/client"

export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/$IDENTITY/msp

MSP_ID="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_NAME:0:1})${ORG_NAME:1}"
export CORE_PEER_LOCALMSPID=$MSP_ID"MSP"

VAR=$((PORT_NUMBER_BASE+1))
export CORE_PEER_LISTENADDRESS=0.0.0.0:$VAR
export CORE_PEER_ADDRESS=0.0.0.0:$VAR
VAR=$((PORT_NUMBER_BASE+2))
export CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:$VAR
VAR=$((PORT_NUMBER_BASE+3))
export CORE_PEER_EVENTS_ADDRESS=0.0.0.0:$VAR

export FABRIC_CFG_PATH="$PWD/.."

export GOPATH="$PWD/../../gopath"
export NODECHAINCODE="$PWD/../../nodechaincode"
export CURRENT_ORG_NAME=$ORG_NAME
export CURRENT_IDENTITY=$IDENTITY

if [[ $0 = *"set-env.sh" ]]
then
    echo "Did you use the . before ./set-env.sh?"
fi
