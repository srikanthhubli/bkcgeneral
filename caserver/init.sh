

docker-compose -f docker-compose-ca.yaml down
sudo rm -rf ./server/*
sudo rm -rf ./client/*
cp fabric-ca-server-config.yaml ./server
docker-compose -f docker-compose-ca.yaml up -d

sleep 3s

# Bootstrap enrollment
export FABRIC_CA_CLIENT_HOME=$PWD/client/caserver/admin
fabric-ca-client enroll -u http://admin:adminpw@localhost:7054


######################
# Admin registration #
######################
echo " "
echo "#######################"
echo "# Admin registration #"
echo "#######################"
echo " "

echo " "
echo "Registering: org1-admin"
ATTRIBUTES='"hf.Registrar.Roles=peer,user,client","hf.AffiliationMgr=true","hf.Revoker=true","hf.Registrar.Attributes=*"'
fabric-ca-client register --id.type client --id.name org1-admin --id.secret adminpw --id.affiliation org1 --id.attrs $ATTRIBUTES
echo " "

echo " "
# 3. Register org2-admin
echo "Registering: org2-admin"
ATTRIBUTES='"hf.Registrar.Roles=peer,user,client","hf.AffiliationMgr=true","hf.Revoker=true","hf.Registrar.Attributes=*"'
fabric-ca-client register --id.type client --id.name org2-admin --id.secret adminpw --id.affiliation org2 --id.attrs $ATTRIBUTES
echo " "

echo " "
# 3. Register org3-admin
echo "Registering: org3-admin"
ATTRIBUTES='"hf.Registrar.Roles=peer,user,client","hf.AffiliationMgr=true","hf.Revoker=true","hf.Registrar.Attributes=*"'
fabric-ca-client register --id.type client --id.name org3-admin --id.secret adminpw --id.affiliation org3 --id.attrs $ATTRIBUTES
echo " "

echo " "
# 4. Register orderer-admin
echo "Registering: orderer-admin"
ATTRIBUTES='"hf.Registrar.Roles=orderer"'
fabric-ca-client register --id.type client --id.name orderer-admin --id.secret adminpw --id.affiliation orderer --id.attrs $ATTRIBUTES
echo " "

####################
# Admin Enrollment #
####################
echo " "
echo "####################"
echo "# Admin Enrollment #"
echo "####################"
echo " "

echo " "
export FABRIC_CA_CLIENT_HOME=$PWD/client/org1/admin
fabric-ca-client enroll -u http://org1-admin:adminpw@localhost:7054
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp $FABRIC_CA_CLIENT_HOME/../../caserver/admin/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo " "

echo " "
export FABRIC_CA_CLIENT_HOME=$PWD/client/org2/admin
fabric-ca-client enroll -u http://org2-admin:adminpw@localhost:7054
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp $FABRIC_CA_CLIENT_HOME/../../caserver/admin/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo " "

echo " "
export FABRIC_CA_CLIENT_HOME=$PWD/client/org3/admin
fabric-ca-client enroll -u http://org3-admin:adminpw@localhost:7054
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp $FABRIC_CA_CLIENT_HOME/../../caserver/admin/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo " "

echo " "
export FABRIC_CA_CLIENT_HOME=$PWD/client/orderer/admin
fabric-ca-client enroll -u http://orderer-admin:adminpw@localhost:7054
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp $FABRIC_CA_CLIENT_HOME/../../caserver/admin/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo " "

#################
# Org MSP Setup #
#################
echo " "
echo "#################"
echo "# Org MSP Setup #"
echo "#################"
echo " "

echo " "
# Path to the CA certificate
ROOT_CA_CERTIFICATE=./server/ca-cert.pem
mkdir -p ./client/orderer/msp/admincerts
mkdir ./client/orderer/msp/cacerts
mkdir ./client/orderer/msp/keystore
cp $ROOT_CA_CERTIFICATE ./client/orderer/msp/cacerts
cp ./client/orderer/admin/msp/signcerts/* ./client/orderer/msp/admincerts   
echo " "

echo " "
mkdir -p ./client/org1/msp/admincerts
mkdir ./client/org1/msp/cacerts
mkdir ./client/org1/msp/keystore
cp $ROOT_CA_CERTIFICATE ./client/org1/msp/cacerts
cp ./client/org1/admin/msp/signcerts/* ./client/org1/msp/admincerts   
echo " "

echo " "
mkdir -p ./client/org2/msp/admincerts
mkdir ./client/org2/msp/cacerts
mkdir ./client/org2/msp/keystore
cp $ROOT_CA_CERTIFICATE ./client/org2/msp/cacerts
cp ./client/org2/admin/msp/signcerts/* ./client/org2/msp/admincerts   
echo " "

echo " "
mkdir -p ./client/org3/msp/admincerts
mkdir ./client/org3/msp/cacerts
mkdir ./client/org3/msp/keystore
cp $ROOT_CA_CERTIFICATE ./client/org3/msp/cacerts
cp ./client/org3/admin/msp/signcerts/* ./client/org3/msp/admincerts 
echo " "

######################
# Orderer Enrollment #
######################
echo " "
echo "#####################"
echo "# Oderer Enrollment #"
echo "#####################"
echo " "

export FABRIC_CA_CLIENT_HOME=$PWD/client/orderer/admin
fabric-ca-client register --id.type orderer --id.name orderer --id.secret adminpw --id.affiliation orderer 
export FABRIC_CA_CLIENT_HOME=$PWD/client/orderer/orderer
fabric-ca-client enroll -u http://orderer:adminpw@localhost:7054
cp -a $PWD/client/orderer/admin/msp/signcerts  $FABRIC_CA_CLIENT_HOME/msp/admincerts

####################
# Peer Enrollments #
####################
echo " "
echo "###################"
echo "# Peer Enrollment #"
echo "###################"
echo " "

echo " Org1 Peer"
export FABRIC_CA_CLIENT_HOME=$PWD/client/org1/admin
fabric-ca-client register --id.type peer --id.name org1-peer1 --id.secret adminpw --id.affiliation org1 
export FABRIC_CA_CLIENT_HOME=$PWD/client/org1/peer1
fabric-ca-client enroll -u http://org1-peer1:adminpw@localhost:7054
cp -a $PWD/client/org1/admin/msp/signcerts  $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo " "

echo " Org2 Peer"
export FABRIC_CA_CLIENT_HOME=$PWD/client/org2/admin
fabric-ca-client register --id.type peer --id.name org2-peer1 --id.secret adminpw --id.affiliation org2
export FABRIC_CA_CLIENT_HOME=$PWD/client/org2/peer1
fabric-ca-client enroll -u http://org2-peer1:adminpw@localhost:7054
cp -a $PWD/client/org2/admin/msp/signcerts  $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo " "

echo "Org3 Peer "
export FABRIC_CA_CLIENT_HOME=$PWD/client/org3/admin
fabric-ca-client register --id.type peer --id.name org3-peer1 --id.secret adminpw --id.affiliation org3
export FABRIC_CA_CLIENT_HOME=$PWD/client/org3/peer1
fabric-ca-client enroll -u http://org3-peer1:adminpw@localhost:7054
cp -a $PWD/client/org3/admin/msp/signcerts  $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo " "

##############################
# User Enrollments Org1 only #
##############################
echo " "
echo "##############################"
echo "# User Enrollments Org1 Only #"
echo "##############################"
echo " "

echo " "
export FABRIC_CA_CLIENT_HOME=$PWD/client/org1/admin
ATTRIBUTES='"hf.AffiliationMgr=false:ecert","hf.Revoker=false:ecert","app.accounting.role=manager:ecert","department=accounting:ecert"'
fabric-ca-client register --id.type user --id.name mary --id.secret pw --id.affiliation org1 --id.attrs $ATTRIBUTES
export FABRIC_CA_CLIENT_HOME=$PWD/client/org1/mary
fabric-ca-client enroll -u http://org1:pw@localhost:7054
cp -a $PWD/client/org1/admin/msp/signcerts  $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo " "

# echo " "
# export FABRIC_CA_CLIENT_HOME=$PWD/client/org1/admin
# ATTRIBUTES='"hf.AffiliationMgr=false:ecert","hf.Revoker=false:ecert","app.accounting.role=accountant:ecert","department=accounting:ecert"'
# fabric-ca-client register --id.type user --id.name john --id.secret pw --id.affiliation org1 --id.attrs $ATTRIBUTES
# export FABRIC_CA_CLIENT_HOME=$PWD/client/org1/john
# fabric-ca-client enroll -u http://john:pw@localhost:7054
# cp -a $PWD/client/org1/admin/msp/signcerts  $FABRIC_CA_CLIENT_HOME/msp/admincerts
# echo " "

# echo " "
# export FABRIC_CA_CLIENT_HOME=$PWD/client/org1/admin
# ATTRIBUTES='"hf.AffiliationMgr=false:ecert","hf.Revoker=false:ecert","department=logistics:ecert","app.logistics.role=specialis:ecert"'
# fabric-ca-client register --id.type user --id.name anil --id.secret pw --id.affiliation org1 --id.attrs $ATTRIBUTES
# export FABRIC_CA_CLIENT_HOME=$PWD/client/org1/anil
# fabric-ca-client enroll -u http://anil:pw@localhost:7054
# cp -a $PWD/client/org1/admin/msp/signcerts  $FABRIC_CA_CLIENT_HOME/msp/admincerts
# echo " "

# Shutdown CA
docker-compose -f docker-compose-ca.yaml down

# Setup network config
export FABRIC_CFG_PATH=$PWD/config
configtxgen -outputBlock  ./config/orderer/textile-genesis.block -channelID ordererchannel  -profile TextileOrdererGenesis
configtxgen -outputCreateChannelTx  ./config/textilechannel.tx -channelID textilechannel  -profile TextileChannel

ANCHOR_UPDATE_TX=./config/textile-anchor-update-org1.tx
configtxgen -profile TextileChannel -outputAnchorPeersUpdate $ANCHOR_UPDATE_TX -channelID textilechannel -asOrg Org1MSP

ANCHOR_UPDATE_TX=./config/textile-anchor-update-org2.tx
configtxgen -profile TextileChannel -outputAnchorPeersUpdate $ANCHOR_UPDATE_TX -channelID textilechannel -asOrg Org2MSP

ANCHOR_UPDATE_TX=./config/textile-anchor-update-org3.tx
configtxgen -profile TextileChannel -outputAnchorPeersUpdate $ANCHOR_UPDATE_TX -channelID textilechannel -asOrg Org3MSP
