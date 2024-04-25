#!/bin/bash
cd ../fabric
make clean docker-clean peer-docker orderer-docker tools-docker docker-thirdparty docker native
cd ../fabric-samples/test-network
./network.sh up createChannel -s couchdb
./network.sh deployCC -ccn smallbank -ccp ../../caliper-benchmarks/src/fabric/scenario/smallbank/go -ccl go
cd ../../caliper-benchmarks
npx caliper launch manager --caliper-workspace ./ --caliper-networkconfig networks/fabric/test-network.yaml --caliper-benchconfig benchmarks/scenario/smallbank/config.yaml --caliper-flow-only-test --caliper-fabric-gateway-enabled
mv report.html ../automatization/reports
cd ../fabric-samples/test-network
./network.sh down
cd ../../automatization/
docker rmi -f $(docker images -aq)
exit
