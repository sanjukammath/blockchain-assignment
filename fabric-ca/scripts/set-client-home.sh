function usage {
    echo    "Usage:    .   ./setclient.sh   ORG-Name   Enrollment-ID"

    echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
}

function usage {
    echo ".  ./set-client-home.sh ORG_NAME  ENROLL_ID"
    echo "     Sets up FABRIC_CA_CLIENT_HOME"
}

if [ -z $1 ];
then
    usage
    echo   "Please provide ORG-Name & enrollment ID"
    exit 0
fi

if [ -z $2 ];
then
    usage
    echo   "Please provide enrollment ID"
    exit 0
fi

export FABRIC_CA_CLIENT_HOME=$PWD/../client/$1/$2
echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"

if [ "$0" = "./set-client-home.sh" ]
then
    echo "Did you use the . before ./set-client-home.sh?"
fi

