source set-client-home.sh caserver admin

fabric-ca-client register --id.type user --id.name doctor01 --id.secret pw --id.affiliation hospital --id.attrs 'email=doctor01@hospital.com,doctor=true,lab=false,patient=false'

fabric-ca-client register --id.type user --id.name doctor02 --id.secret pw --id.affiliation hospital --id.attrs 'email=doctor02@hospital.com,doctor=true,lab=false,patient=false'

fabric-ca-client register --id.type user --id.name patient01 --id.secret pw --id.affiliation hospital --id.attrs 'email=patient01@hospital.com,doctor=false,lab=false,patient=true'

fabric-ca-client register --id.type user --id.name patient02 --id.secret pw --id.affiliation hospital --id.attrs 'email=patient02@hospital.com,doctor=false,lab=false,patient=true'

fabric-ca-client register --id.type user --id.name lab_tech01 --id.secret pw --id.affiliation lab --id.attrs 'email=lab_tech01@lab.com,doctor=false,lab=true,patient=false'

source set-client-home.sh hospital doctor01

fabric-ca-client enroll -u http://doctor01:pw@localhost:7054 --enrollment.attrs "email,doctor,lab,patient"

mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp /vagrant/fabric-ca/client/hospital/admin/msp/signcerts/*    $FABRIC_CA_CLIENT_HOME/msp/admincerts

source set-client-home.sh hospital doctor02

fabric-ca-client enroll -u http://doctor02:pw@localhost:7054 --enrollment.attrs "email,doctor,lab,patient"

mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp /vagrant/fabric-ca/client/hospital/admin/msp/signcerts/*    $FABRIC_CA_CLIENT_HOME/msp/admincerts

source set-client-home.sh hospital patient01

fabric-ca-client enroll -u http://patient01:pw@localhost:7054 --enrollment.attrs "email,doctor,lab,patient"

mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp /vagrant/fabric-ca/client/hospital/admin/msp/signcerts/*    $FABRIC_CA_CLIENT_HOME/msp/admincerts

source set-client-home.sh hospital patient02

fabric-ca-client enroll -u http://patient02:pw@localhost:7054 --enrollment.attrs "email,doctor,lab,patient"

mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp /vagrant/fabric-ca/client/hospital/admin/msp/signcerts/*    $FABRIC_CA_CLIENT_HOME/msp/admincerts

source set-client-home.sh lab lab_tech01

fabric-ca-client enroll -u http://lab_tech01:pw@localhost:7054 --enrollment.attrs "email,doctor,lab,patient"

mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp /vagrant/fabric-ca/client/lab/admin/msp/signcerts/*    $FABRIC_CA_CLIENT_HOME/msp/admincerts



