#!/bin/bash
cd ../fabric-samples/test-network
./network.sh up createChannel
./network.sh deployCC -ccn basic -ccp ../asset-transfer-basic/chaincode-javascript -ccl javascript
cd ../../caliper-workspace
npx caliper launch manager --caliper-workspace ./ --caliper-networkconfig networks/networkConfig.yaml --caliper-benchconfig benchmarks/myAssetBenchmark.yaml --caliper-flow-only-test
mv report.html ../automatisation/reports/
cd ../fabric-samples/test-network
./network.sh down
cd ../../automatization/
docker rmi -f $(docker images -aq)
exit
