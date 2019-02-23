export FABRIC_CFG_PATH=../../config

configtxgen -profile AirlineOrdererGenesis -outputBlock ../../artefacts/airline-genesis.block -channelID ordererchannel

configtxgen -profile AirlineChannel -outputCreateChannelTx ../../artefacts/airline-channel.tx -channelID airlinechannel
