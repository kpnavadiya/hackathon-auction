
#export PATH=${PWD}/../bin:${PWD}:$PATH
#export FABRIC_CFG_PATH=${PWD}
export PATH=${PWD}/bin:${PWD}:$PATH
export FABRIC_CFG_PATH=$PWD/fabric-config

export VERBOSE=false


which cryptogen
if [ "$?" -ne 0 ]; then
  echo "cryptogen tool not found. exiting"
  exit 1
fi
echo
echo "##########################################################"
echo "##### Generate certificates using cryptogen tool #########"
echo "##########################################################"

if [ -d "crypto-config" ]; then
  rm -Rf crypto-config
fi
set -x
./bin/cryptogen generate --config=./fabric-config/crypto-config.yaml
res=$?
set +x
if [ $res -ne 0 ]; then
  echo "Failed to generate certificates..."
  exit 1
fi
echo

#############################################################################################

export FABRIC_CFG_PATH=$PWD/fabric-config

#############################################################################################

which configtxgen
if [ "$?" -ne 0 ]; then
  echo "configtxgen tool not found. exiting"
  exit 1
fi

echo "##########################################################"
echo "#########  Generating Orderer Genesis block ##############"
echo "##########################################################"
# Note: For some unknown reason (at least for now) the block file can't be
# named orderer.genesis.block or the orderer will fail to launch!
set -x
./bin/configtxgen -profile auctiongenesis -outputBlock ./network-config/genesis.block
res=$?
set +x
if [ $res -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi
echo
export CHANNEL_NAME=auctionchannel
echo "#################################################################"
echo "### Generating channel configuration transaction 'channel.tx' ###"
echo "#################################################################"
set -x
./bin/configtxgen -profile auctionchannel -outputCreateChannelTx ./network-config/channel.tx -channelID $CHANNEL_NAME
res=$?
set +x
if [ $res -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi

echo
echo "#################################################################"
echo "#######    Generating anchor peer update for governmentMSP   ##########"
echo "#################################################################"
set -x
./bin/configtxgen -profile auctionchannel -outputAnchorPeersUpdate ./network-config/governmentMSPanchors.tx -channelID $CHANNEL_NAME -asOrg governmentMSP
res=$?
set +x
if [ $res -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi

echo
echo "#################################################################"
echo "#######    Generating anchor peer update for veterinariansMSP   ##########"
echo "#################################################################"
set -x
./bin/configtxgen -profile auctionchannel -outputAnchorPeersUpdate \
  ./network-config/veterinariansMSPanchors.tx -channelID $CHANNEL_NAME -asOrg veterinariansMSP
res=$?
set +x
if [ $res -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org2MSP..."
  exit 1
fi
echo

echo
echo "#################################################################"
echo "#######    Generating anchor peer update for dairyMSP   ##########"
echo "#################################################################"

./bin/configtxgen -profile auctionchannel -outputAnchorPeersUpdate ./network-config/dairyMSPanchors.tx -channelID $CHANNEL_NAME -asOrg dairyMSP


echo "#################################################################"
echo "#######    DONE   ##########"
echo "#################################################################"