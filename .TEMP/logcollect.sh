#!/bin/bash

if  [ "$(ls -A ./logs/)" ]; then
    printf 'Directory is NOT empty... Overwite?'
    read input
    if [ "$input" != "${input#[Yy]}" ] ;then 
        echo Yes
        rm ./logs/*
    else
        echo No
        exit
    fi
fi

echo "Kurtosis logs being redirected..."

kurtosis service logs cdk-v1 zkevm-prover-001 -f >& ./logs/zkevm-prover-001.log &
kurtosis service logs cdk-v1 zkevm-node-synchronizer-pless-001 -f >& ./logs/zkevm-node-synchronizer-pless-001.log &
kurtosis service logs cdk-v1 zkevm-node-synchronizer-001 -f >& ./logs/zkevm-node-synchronizer-001.log &
kurtosis service logs cdk-v1 zkevm-node-sequencer-001 -f >& ./logs/zkevm-node-sequencer-001.log &
kurtosis service logs cdk-v1 zkevm-node-sequence-sender-001 -f >& ./logs/zkevm-node-sequence-sender-001.log &
kurtosis service logs cdk-v1 zkevm-node-rpc-pless-001 -f >& ./logs/zkevm-node-rpc-pless-001.log &
kurtosis service logs cdk-v1 zkevm-node-rpc-001 -f >& ./logs/zkevm-node-rpc-001.log &
kurtosis service logs cdk-v1 zkevm-node-l2-gas-pricer-001 -f >& ./logs/zkevm-node-l2-gas-pricer-001.log &
kurtosis service logs cdk-v1 zkevm-node-eth-tx-manager-001 -f >& ./logs/zkevm-node-eth-tx-manager-001.log &
kurtosis service logs cdk-v1 zkevm-node-aggregator-001 -f >& ./logs/zkevm-node-aggregator-001.log &
kurtosis service logs cdk-v1 zkevm-dac-001 -f >& ./logs/zkevm-dac-001.log &
kurtosis service logs cdk-v1 zkevm-bridge-ui-001 -f >& ./logs/zkevm-bridge-ui-001.log &
kurtosis service logs cdk-v1 zkevm-bridge-service-001 -f >& ./logs/zkevm-bridge-service-001.log &
kurtosis service logs cdk-v1 zkevm-agglayer-001 -f >& ./logs/zkevm-agglayer-001.log & 

wait

pkill -9 -f kurtosis
pkill -9 -f redirect_logs*