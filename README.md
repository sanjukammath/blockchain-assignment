This is a solution for the following problem statement:

In healthcare, a patient has their health record fragmented across multiple locations e.g. labs, hospital etc. In a decentralized world, how can you make sure that these records can be stored on blockchain and can help patients to access them anywhere they want. & obviously, as medical records are a very personal entity, we want you to write the smart contract that is going to secure a single piece of data so that only patient can access it.

Hyperledger Fabric Based Solution:

The patient records chaincode is used to control the patient records ledger. This is deployed as solution:1.0 in the healthcarechannel. Both hospital and lab orgs will be joining this channel. The users are identified by their email id which will be passed as attribute during registration and will be added to Ecert during enrolment. The methods in the chaincode are access controlled. This is done by using the emailid and three additional boolean attributes: doctor, patient, lab.

HOW TO TEST (using scripts)

>vagrant up (may take around 7 minutes)

>vagrant ssh

>cd scripts

>./run-all.sh

This command will bring up all the necessary fabric componenets and also create 4 user identities as defined in the file /fabric-ca/scripts/gen-users-identity.sh script.

We will now test the use cases. Set identity context to Hospital Admin and instantiate the chaindode to continue...

>cd ../peers/scripts

>. set-env.sh hospital 7050 admin

>./chain-test-solution.sh instantiate

if this times out, run again. It should work.

***************************************************************************************************************
Apart from install and instantiate, the chain-test-solution.sh can be run with the following arguments.

create1/create2: Create patient record for patient with email id patien01@hospital.com/patien02@hospital.com

query1/query2: Query the world state for patient with email id patien01@hospital.com/patien02@hospital.com

vitals1/vitals2: update the vitals of patient1
****************************************************************************************************************

>./chain-test-solution.sh create1
This is trying to create a patient record. But since the identity is admin and not of a doctor, it will fail.

>. set-env.sh hospital 7050 patient01

>./chain-test-solution.sh create1
This will also fail because, a patient cannot create a record.

>. set-env.sh lab 9050 lab_tech01

>./chain-test-solution.sh create1
This will also fail because, a lab technician cannot create a record.

>. set-env.sh hospital 7050 doctor01

>./chain-test-solution.sh create1
This should work. The record will be created and can be viewed in the response.

>./chain-test-solution.sh create2
This should work. The record will be created and can be viewed in the response.

>. set-env.sh hospital 7050 patient01

>./chain-test-solution.sh query1
This should work.

>./chain-test-solution.sh query2
This should not work.

>. set-env.sh hospital 7050 patient02

>./chain-test-solution.sh query1
This should not work.

>./chain-test-solution.sh query2
This should work




