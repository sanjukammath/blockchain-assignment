export FABRIC_CA_CLIENT_HOME=$PWD/../client
export FABRIC_CA_SERVER_HOME=$PWD/../server

function    setup_msp() {

    source set-client-home.sh $ORG_NAME  admin

    ROOT_CA_CERTIFICATE=$FABRIC_CA_SERVER_HOME/ca-cert.pem

    DESTINATION_CLIENT_HOME="$FABRIC_CA_CLIENT_HOME/.."

    mkdir -p $DESTINATION_CLIENT_HOME/msp/admincerts 
    mkdir -p $DESTINATION_CLIENT_HOME/msp/cacerts 
    mkdir -p $DESTINATION_CLIENT_HOME/msp/keystore

    cp $ROOT_CA_CERTIFICATE $DESTINATION_CLIENT_HOME/msp/cacerts

    cp $FABRIC_CA_CLIENT_HOME/msp/signcerts/* $DESTINATION_CLIENT_HOME/msp/admincerts         
}

export ORG_NAME=orderer
setup_msp

export ORG_NAME=hospital
setup_msp

export ORG_NAME=lab
setup_msp

echo "Created MSP for all Organizations!!!"



