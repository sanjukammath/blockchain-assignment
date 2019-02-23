export FABRIC_CFG_PATH=../../config

configtxgen -profile HealthcareOrdererGenesis -outputBlock ../../artefacts/healthcare-genesis.block -channelID ordererchannel

configtxgen -profile HealthcareChannel -outputCreateChannelTx ../../artefacts/healthcare-channel.tx -channelID healthcarechannel
