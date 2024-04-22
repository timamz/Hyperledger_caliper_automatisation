#!/bin/bash
cd ../fabric-samples/test-network
./network.sh up createChannel -s couchdb
./network.sh deployCC -ccn smallbank -ccp ../../caliper-benchmarks/src/fabric/scenario/smallbank/go -ccl go
cd ../../caliper-benchmarks
npx caliper launch manager --caliper-workspace ./ --caliper-networkconfig networks/fabric/test-network.yaml --caliper-benchconfig benchmarks/scenario/smallbank/config.yaml --caliper-flow-only-test --caliper-fabric-gateway-enabled
mv report.html ../automatization/reports
cd ../fabric-samples/test-network
./network.sh down
cd ../../automatization/