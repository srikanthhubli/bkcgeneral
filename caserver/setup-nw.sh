#!/bin/bash

docker-compose down

# REMOVE the dev- container images also - TBD
docker rm $(docker ps -a -q)            &> /dev/null
docker rmi $(docker images dev-* -q)    &> /dev/null
sudo rm -rf $HOME/ledgers/ca &> /dev/null

docker-compose -f docker-compose.yaml  -f docker-compose.couchdb.yaml up -d

SLEEP_TIME=10s
sleep $SLEEP_TIME
echo " "
echo    '========= Submitting txn for channel creation as TextileAdmin ============'
export CHANNEL_TX_FILE=./config/textilechannel.tx
export ORDERER_ADDRESS=orderer.org1.com:7050
# export FABRIC_LOGGING_SPEC=DEBUG
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_MSPCONFIGPATH=$PWD/client/org1/admin/msp
export CORE_PEER_ADDRESS=org1-peer1.org1.com:7051
peer channel create -o $ORDERER_ADDRESS -c textilechannel -f ./config/textilechannel.tx


echo " "
echo    '========= Joining the org1-peer1 to Textile channel ============'
TEXTILE_CHANNEL_BLOCK=./textilechannel.block
export CORE_PEER_ADDRESS=org1-peer1.org1.com:7051
peer channel join -o $ORDERER_ADDRESS -b $TEXTILE_CHANNEL_BLOCK
# Update anchor peer on channel for org1
# sleep  3s
sleep $SLEEP_TIME
ANCHOR_UPDATE_TX=./config/textile-anchor-update-org1.tx
peer channel update -o $ORDERER_ADDRESS -c textilechannel -f $ANCHOR_UPDATE_TX

echo " "
echo    '========= Joining the org2-peer1 to Textile channel ============'
# peer channel fetch config $TEXTILE_CHANNEL_BLOCK -o $ORDERER_ADDRESS -c textilechannel
export CORE_PEER_LOCALMSPID=Org2MSP
ORG_NAME=org2.com
export CORE_PEER_ADDRESS=org2-peer1.org2.com:8051
export CORE_PEER_MSPCONFIGPATH=$PWD/client/org2/admin/msp
peer channel join -o $ORDERER_ADDRESS -b $TEXTILE_CHANNEL_BLOCK
# Update anchor peer on channel for org2
sleep  $SLEEP_TIME
ANCHOR_UPDATE_TX=./config/textile-anchor-update-org2.tx
peer channel update -o $ORDERER_ADDRESS -c textilechannel -f $ANCHOR_UPDATE_TX

sleep  $SLEEP_TIME
echo " "
echo    '========= Joining the org3-peer1 to Textile channel ============'
# peer channel fetch config $TEXTILE_CHANNEL_BLOCK -o $ORDERER_ADDRESS -c textilechannel
export CORE_PEER_LOCALMSPID=Org3MSP
ORG_NAME=org3.com
export CORE_PEER_ADDRESS=org3-peer1.org3.com:9051
export CORE_PEER_MSPCONFIGPATH=$PWD/client/org3/admin/msp
peer channel join -o $ORDERER_ADDRESS -b $TEXTILE_CHANNEL_BLOCK
# Update anchor peer on channel for org3
sleep  $SLEEP_TIME
ANCHOR_UPDATE_TX=./config/textile-anchor-update-org3.tx
peer channel update -o $ORDERER_ADDRESS -c textilechannel -f $ANCHOR_UPDATE_TX

# #:'Note : While adding a nerw organization expose the ports to by changing in /etc/hosts
# #Ref: https://www.edureka.co/community/48967/following-command-removing-containers-updated-required-version'