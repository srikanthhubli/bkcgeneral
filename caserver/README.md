

./init.sh




export FABRIC_CFG_PATH=$PWD/config
configtxgen -outputBlock  ./config/textilegenesis.block -channelID ordererchannel  -profile TextileOrdererGenesis
configtxgen -outputCreateChannelTx  ./config/textilechannel.tx -channelID textilechannel  -profile TextileChannel