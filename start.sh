#!/bin/bash

function run_benchmark() {

    python3 editors/batchSize_editor.py $1
    echo "Running benchmark with value: $1"
    
    cd ../fabric
    make clean docker-clean peer-docker orderer-docker tools-docker docker-thirdparty docker native

    cd ../fabric-samples/test-network
    ./network.sh up createChannel
    ./network.sh deployCC -ccn basic -ccp ../asset-transfer-basic/chaincode-javascript -ccl javascript

    cd ../../caliper-workspace
    npx caliper launch manager --caliper-workspace ./ --caliper-networkconfig networks/networkConfig.yaml --caliper-benchconfig benchmarks/myAssetBenchmark.yaml --caliper-flow-only-test

    mv report.html ../automatisation/
    cd ../automatisation/
    python3 report_parser.py $1
    rm report.html

    cd ../fabric-samples/test-network
    ./network.sh down

    docker rmi -f $(docker images -aq)

    cd ../../automatisation/
}

source .venv/bin/activate

for value in 10 15 20 30 35 40 45 50
do
    run_benchmark $value 
done

deactivate
exit
