#!/bin/bash

# Crear directorio de datos si no existe
mkdir -p /eth/keystore

# Crear archivo de contraseña
echo "${NODE_PASS}" > /eth/password.txt

# Inicializar con genesis si no está inicializado
if [ ! -d /eth/geth ]; then
    echo "Inicializando blockchain..."
    geth init --datadir /eth genesis.json
fi

# Importar la cuenta si no existe
if [ ! -f /eth/keystore/* ]; then
    echo "Importando cuenta..."
    echo "${MINER_ACCOUNT2}" > /eth/account.txt
    geth account import --datadir /eth --password /eth/password.txt /eth/account.txt
fi

# Iniciar el nodo
exec geth \
    --datadir /eth \
    --networkid ${NETWORK_ID} \
    --http \
    --http.addr "0.0.0.0" \
    --http.port 8545 \
    --http.corsdomain "*" \
    --http.vhosts "*" \
    --http.api "eth,net,web3,personal,miner,admin,debug" \
    --ws \
    --ws.addr "0.0.0.0" \
    --ws.port 8546 \
    --ws.origins "*" \
    --ws.api "eth,net,web3,personal,miner,admin,debug" \
    --mine \
    --miner.threads ${MINER_THREADS} \
    --allow-insecure-unlock \
    --unlock ${MINER_ACCOUNT2} \
    --password /eth/password.txt \
    --syncmode full \
    --verbosity 3 