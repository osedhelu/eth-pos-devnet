#!/bin/bash

# Crear directorio de datos si no existe
mkdir -p /eth/keystore

# Crear archivo de contraseña
echo "${NODE_PASS}" > /eth/password.txt

# Inicializar con genesis si no está inicializado
if [ ! -d /eth/geth ]; then
    echo "Inicializando blockchain..."
    geth init --datadir /eth /eth/genesis.json
fi

# Importar la cuenta predefinida
if [ ! -f /eth/keystore/* ]; then
    echo "Configurando cuenta..."
    echo "${NODE_PASS}" > /eth/password.txt
    echo "${MINER_ACCOUNT2}" | sed 's/0x//' > /eth/key.txt
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
    --miner.etherbase ${MINER_ACCOUNT2} \
    --allow-insecure-unlock \
    --unlock ${MINER_ACCOUNT2} \
    --password /eth/password.txt \
    --verbosity 3 