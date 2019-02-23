This is a solution for the following problem statement:

In healthcare, a patient has their health record fragmented across multiple locations e.g. labs, hospital etc. In a decentralized world, how can you make sure that these records can be stored on blockchain and can help patients to access them anywhere they want. & obviously, as medical records are a very personal entity, we want you to write the smart contract that is going to secure a single piece of data so that only patient can access it.

Hyperledger Fabric Based Solution:

Identity affiliations available:
affiliations:
   orderer:
      - support
   hospital:
      - doctors
      - accounting
      - patients
   lab:
      - technician

The patientrecords chaincode is used to control the patient records ledger. This is deployed in the patients channel. The patient is identified by his email id. Both hospital and lab orgs will be joining this channel. The queryRecord and queryHistory methods in the chaincode are access controlled.

HOW TO TEST (using scripts)
