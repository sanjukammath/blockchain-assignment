export FABRIC_LOGGING_SPEC=INFO

export FABRIC_CFG_PATH=$PWD/..

export ORDERER_FILELEDGER_LOCATION=$HOME/orderer/ledger

orderer  2> ../orderer.log

