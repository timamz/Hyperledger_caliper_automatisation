#!/bin/bash

function execute_benchmark() {
    cd ../fabric
    make clean docker-clean peer-docker orderer-docker tools-docker docker-thirdparty docker native

    cd ../fabric-samples/test-network
    ./network.sh up createChannel
    ./network.sh deployCC -ccn basic -ccp ../asset-transfer-basic/chaincode-javascript -ccl javascript

    cd ../../caliper-workspace
    npx caliper launch manager --caliper-workspace ./ --caliper-networkconfig networks/networkConfig.yaml --caliper-benchconfig benchmarks/myAssetBenchmark.yaml --caliper-flow-only-test

    mv report.html ../HLC_automatisation/
    cd ../HLC_automatisation/
}

function shut_down() {
    cd ../fabric-samples/test-network
    ./network.sh down

    cd ../../HLC_automatisation/
}

function edit_execute_parse() {

    local parameter=$1
    local key=$2
    local value=$3
    local output_path=$4

    echo "Executing function for parameter: $parameter with value: $value"

    python3 editor.py "$value" "$key"

    execute_benchmark

    python3 report_parser.py "$value" "$output_path"
    rm report.html

    shut_down
}

function reset_core() {
    rm ../fabric/sampleconfig/core.yaml
    cp ../fabric-samples/config/core.yaml ../fabric/sampleconfig/core.yaml
}

source .venv/bin/activate

json_file="parameters.json"
parameter_names=$(jq -r 'keys[]' "$json_file")

for param in $parameter_names; do
    key=$(jq -r --arg param "$param" '.[$param].key' "$json_file")
    values=$(jq -r --arg param "$param" '.[$param].values[]' "$json_file")
    output_path=$(jq -r --arg param "$param" '.[$param].path_to_output' "$json_file")

    for value in $values; do
        edit_execute_parse "$param" "$key" "$value" "$output_path"
    done

    reset_core
done

deactivate
exit
