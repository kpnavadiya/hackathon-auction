#################################### PEER0 CAMA ###################################################################################
export CORE_PEER_ADDRESS=peer0.cama.example.com:7051
export CORE_PEER_LOCALMSPID=camaMSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cama.example.com/peers/peer0.cama.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cama.example.com/users/Admin@cama.example.com/msp


peer channel join -b ./firstchannel.block
peer chaincode install -n PrivateCama -v 1.0 -p github.com/chaincode/commission
#################################### PEER1 CAMA ###################################################################################
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cama.example.com/users/Admin@cama.example.com/msp
export CORE_PEER_ADDRESS=peer1.cama.example.com:7051
export CORE_PEER_LOCALMSPID=camaMSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cama.example.com/peers/peer1.cama.example.com/tls/ca.crt

peer channel join -b ./firstchannel.block
peer chaincode install -n PrivateCama -v 1.0 -p github.com/chaincode/commission
#################################### PEER0 SUBADMIN ###################################################################################
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/subadmin.example.com/users/Admin@subadmin.example.com/msp
export CORE_PEER_ADDRESS=peer0.subadmin.example.com:7051
export CORE_PEER_LOCALMSPID=subadminMSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/subadmin.example.com/peers/peer0.subadmin.example.com/tls/ca.crt

peer channel join -b ./firstchannel.block
peer chaincode install -n PrivateCama -v 1.0 -p github.com/chaincode/commission
#################################### PEER1 SUBADMIN ###################################################################################
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/subadmin.example.com/users/Admin@subadmin.example.com/msp
export CORE_PEER_ADDRESS=peer1.subadmin.example.com:7051
export CORE_PEER_LOCALMSPID=subadminMSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/subadmin.example.com/peers/peer1.subadmin.example.com/tls/ca.crt

peer channel join -b ./firstchannel.block
peer chaincode install -n PrivateCama -v 1.0 -p github.com/chaincode/commission
#################################### PEER0 STAKEHOLDERS ###################################################################################
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/stakeholders.example.com/users/Admin@stakeholders.example.com/msp
export CORE_PEER_ADDRESS=peer0.stakeholders.example.com:7051
export CORE_PEER_LOCALMSPID=stakeholdersMSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/stakeholders.example.com/peers/peer0.stakeholders.example.com/tls/ca.crt

peer channel join -b ./firstchannel.block
peer chaincode install -n PrivateCama -v 1.0 -p github.com/chaincode/commission
#################################### PEER1 STAKEHOLDERS ###################################################################################
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/stakeholders.example.com/users/Admin@stakeholders.example.com/msp
export CORE_PEER_ADDRESS=peer1.stakeholders.example.com:7051
export CORE_PEER_LOCALMSPID=stakeholdersMSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/stakeholders.example.com/peers/peer1.stakeholders.example.com/tls/ca.crt

peer channel join -b ./firstchannel.block
peer chaincode install -n PrivateCama -v 1.0 -p github.com/chaincode/commission

export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

peer chaincode instantiate -o orderer1.example.com:7050 --tls true --cafile $ORDERER_CA -C firstchannel -n PrivateCama -v 1.0 -c '{"Args":[""]}' -P "OR('camaMSP.peer','subadminMSP.peer', 'stakeholdersMSP.peer')" 
peer chaincode instantiate -o orderer1.example.com:7050  -C firstchannel -n PrivateCama -v 1.0 -c '{"Args":[""]}' -P "OR('camaMSP.peer','subadminMSP.peer', 'stakeholdersMSP.peer')" 

# cama Commission chaincode test
peer chaincode install -n commission -v 1.0 -p github.com/chaincode/commission
peer chaincode invoke -n commission -c '{"Args":["addNewCommission","1","201","101","XYZ Films","0","500000","10","Foreign Sales","uk"]}' -C firstchannel
peer chaincode invoke -n commission -c '{"Args":["addNewCommission","2","201","101","XYZ Films","500000","100000000000","5","Foreign Sales","uk"]}' -C firstchannel
peer chaincode invoke -n commission -c '{"Args":["addNewCommission","3","202","101","The Exchange","0","500000","10","Foreign Sales","uk"]}' -C firstchannel
peer chaincode invoke -n commission -c '{"Args":["addNewCommission","4","202","101","The Exchange","500000","100000000000","5","Foreign Sales","uk"]}' -C firstchannel
peer chaincode invoke -n commission -c '{"Args":["addNewCommission","5","203","101","CAA","0","360000","5","Domestic Sales","usa"]}' -C firstchannel
peer chaincode invoke -n commission -c '{"Args":["addNewCommission","6","203","101","CAA","360000","410000","2.5","Domestic Sales","usa"]}' -C firstchannel



peer chaincode invoke -n commission -c '{"Args":["showAgentCommission","1"]}' -C firstchannel --tls true --cafile $ORDERER_CA
peer chaincode query -n commission -c '{"Args":["showAgentCommission","1"]}' -C firstchannel --tls true --cafile $ORDERER_CA
peer chaincode invoke -n commission -c '{"Args":["editAgentCommission","1"]}' -C firstchannel --tls true --cafile $ORDERER_CA
peer chaincode query -o orderer2.example.com -C firstchannel -n commission -c '{"Args":["showProjectCommission","{\"selector\":{\"projectId\":\"101\"}}"]}'
peer chaincode instantiate -o orderer0.example.com:7050 -C firstchannel -n commission -v 1.0 -c '{"Args":[""]}'
 --collections-config $GOPATH/src/github.com/chaincode/data_config.json

# stakeholder account chaincode test
peer chaincode install -n bankaccount -v 1.0 -p github.com/chaincode/stakeholderaccount
peer chaincode instantiate -o orderer0.example.com:7050 -C firstchannel -n bankaccount -v 1.0 -c '{"Args":[""]}'
peer chaincode invoke -n bankaccount -c '{"Args":["addNewAccount","203","101","123456","CAA","fa@gnai","1001","1001023","10-25","031","abana"]}' -C firstchannel 
peer chaincode invoke -n bankaccount -c '{"Args":["addNewAccount","202","101","234567","The Exchange","exchange@gnai","1001","1001023","10-25","031","abana"]}' -C firstchannel
peer chaincode invoke -n bankaccount -c '{"Args":["addNewAccount","201","101","345678","XYZ Films","xyz@gnai","1001","1001023","10-25","031","abana"]}' -C firstchannel 
peer chaincode invoke -n bankaccount -c '{"Args":["addNewAccount","204","101","456789","Fork Investors","Fork@gnai","1001","1001023","10-25","031","abana"]}' -C firstchannel 
peer chaincode invoke -n bankaccount -c '{"Args":["addNewAccount","205","101","567890","Union Edge","Union@gnai","1001","1001023","10-25","031","abana"]}' -C firstchannel 
peer chaincode invoke -n bankaccount -c '{"Args":["addNewAccount","206","101","678901","Guy Pearce","Union@gnai","1001","1001023","10-25","031","abana"]}' -C firstchannel 
peer chaincode invoke -n bankaccount -c '{"Args":["addNewAccount","207","101","789012","WB","wb@gnai","1001","1001023","10-25","031","abana"]}' -C firstchannel 



peer chaincode query -n bankaccount -c '{"Args":["showAccount","1"]}' -C firstchannel --tls true --cafile $ORDERER_CA
peer chaincode query -o orderer2.example.com -C firstchannel -n bankaccount -c '{"Args":["queryAccountByProjectId","{\"selector\":{\"stakeholderId\":\"201\"}}"]}'
# add stakeholder details
peer chaincode install -n PrivateCama11 -v 1.0 -p github.com/chaincode/stakeholders
peer chaincode instantiate -o orderer1.example.com:7050 --tls true --cafile $ORDERER_CA -C firstchannel -n PrivateCama1 -v 1.0 -c '{"Args":[""]}'
peer chaincode invoke -n PrivateCama11 -c '{"Args":["addNewStakeholderInfo","1","Jumanji","fa@gnai.com","Epic","investor","loan","25/12/2019","10000$","17"]}' -C firstchannel --tls true --cafile $ORDERER_CA
peer chaincode query -n PrivateCama11 -c '{"Args":["showStakeholderInfo","1"]}' -C firstchannel --tls true --cafile $ORDERER_CA

# add camaterm details
peer chaincode install -n camaterm -v 1.0 -p github.com/chaincode/camaterm
peer chaincode instantiate -o orderer0.example.com:7050 -C firstchannel -n camaterm -v 1.0 -c '{"Args":[""]}'

peer chaincode invoke -n camaterm -c '{"Args":["addNewCamaTerm","1","101","204","Investment Recoupment","1","Fork Investors","500000","5","1000000","Domestic Sales","USA"," ","6000000"]}' -C firstchannel
peer chaincode invoke -n camaterm -c '{"Args":["addNewCamaTerm","2","101","207","WB Payment	","2","WB"," "," ","3000000","Foreign Sales","UK","10"," "]}' -C firstchannel 
peer chaincode invoke -n camaterm -c '{"Args":["addNewCamaTerm","3","101","205","UE Recoupment","1","Union Edge","500000","8.5"," ","Domestic Sales","USA","15"," "]}' -C firstchannel
peer chaincode invoke -n camaterm -c '{"Args":["addNewCamaTerm","4","101","206","Net Profits","4","Guy Pearce"," "," ","500000","Domestic Sales","USA"," ","1000000"]}' -C firstchannel
peer chaincode invoke -n camaterm -c '{"Args":["addNewCamaTerm","5","101","206","Net Profits","4","Guy Pearce"," "," ","500000","Foreign Sales","USA","20"," "]}' -C firstchannel



peer chaincode query -n camaterm -c '{"Args":["showCamaTerm","1"]}' -C firstchannel --tls true --cafile $ORDERER_CA
peer chaincode query -o orderer2.example.com -C firstchannel -n camaterm -c '{"Args":["queryCamaTermByProjectId","{\"selector\":{\"projectId\":\"101\"}, \"use_index\":[\"_design/indexOwnerDoc\", \"indexOwner\"]}"]}'
peer chaincode query -o orderer2.example.com -C firstchannel -n camaterm -c '{"Args":["queryCamaTermByProjectId","{\"selector\":{\"projectId\":\"101\"}}"]}'
