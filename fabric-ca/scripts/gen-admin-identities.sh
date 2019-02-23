function registerAdmins {

    source set-client-home.sh   caserver   admin

    echo "Registering: orderer-admin"
    ATTRIBUTES='"hf.Registrar.Roles=orderer,user,client"'
    fabric-ca-client register --id.type client --id.name orderer-admin --id.secret pw --id.affiliation orderer --id.attrs $ATTRIBUTES
    

    echo "Registering: hospital-admin"
    ATTRIBUTES='"hf.Registrar.Roles=peer,user,client","hf.AffiliationMgr=true","hf.Revoker=true"'
    fabric-ca-client register --id.type client --id.name hospital-admin --id.secret pw --id.affiliation hospital --id.attrs $ATTRIBUTES


    echo "Registering: lab-admin"
    ATTRIBUTES='"hf.Registrar.Roles=peer,user,client","hf.AffiliationMgr=true","hf.Revoker=true"'
    fabric-ca-client register --id.type client --id.name lab-admin --id.secret pw --id.affiliation lab --id.attrs $ATTRIBUTES
    
}

function setupMSP {
    mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts

    echo "====> $FABRIC_CA_CLIENT_HOME/msp/admincerts"
    cp $FABRIC_CA_CLIENT_HOME/../../caserver/admin/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts
}


function enrollAdmins {

    echo "Enrolling: orderer-admin"

    export ORG_NAME="orderer"
    source set-client-home.sh   $ORG_NAME   admin
    fabric-ca-client enroll -u http://orderer-admin:pw@localhost:7054
    setupMSP


    echo "Enrolling: hospital-admin"

    export ORG_NAME="hospital"
    source set-client-home.sh   $ORG_NAME   admin
    fabric-ca-client enroll -u http://hospital-admin:pw@localhost:7054
    setupMSP

    echo "Enrolling: lab-admin"

    export ORG_NAME="lab"
    source set-client-home.sh   $ORG_NAME   admin
    fabric-ca-client enroll -u http://lab-admin:pw@localhost:7054
    setupMSP

}

echo "========= Registering ==============="
registerAdmins

echo "========= Enrolling ==============="
enrollAdmins

echo "====Admin Identities Generated===="