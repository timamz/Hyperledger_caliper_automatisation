#!/bin/bash

function run_benchmark() {

    local value=$1
    python3 editor.py $value
    echo "Running benchmark with value: $value"
    

    cd ../fabric
    make clean docker-clean peer-docker orderer-docker tools-docker docker-thirdparty docker native

    cd ../fabric-samples/test-network
    ./network.sh up createChannel
    ./network.sh deployCC -ccn basic -ccp ../asset-transfer-basic/chaincode-javascript -ccl javascript

    cd ../../caliper-workspace
    npx caliper launch manager --caliper-workspace ./ --caliper-networkconfig networks/networkConfig.yaml --caliper-benchconfig benchmarks/myAssetBenchmark.yaml --caliper-flow-only-test

    mv report.html ../automatisation/
    cd ../automatisation/
    python3 report_parser.py
    rm report.html

    cd ../fabric-samples/test-network
    ./network.sh down

    docker rmi -f $(docker images -aq)

    cd ../../automatisation/
}

source .venv/bin/activate

for value in 25 30
do
    run_benchmark $value
done

deactivate
exit
