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

# Crear cuenta si no existe
if [ ! -f /eth/keystore/* ]; then
    echo "Creando cuenta..."
    geth account new --datadir /eth --password /eth/password.txt
fi

# Obtener la dirección de la cuenta
ACCOUNT=$(geth account list --datadir /eth | head -n 1 | grep -o -E '0x[a-fA-F0-9]{40}')
echo "Usando cuenta: $ACCOUNT"

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
    --allow-insecure-unlock \
    --unlock $ACCOUNT \
    --password /eth/password.txt \
    --verbosity 3 