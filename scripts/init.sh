#!/bin/bash

# Crear cuenta si no existe
if [ ! -d /eth/keystore ]; then
    echo "Creando nueva cuenta..."
    echo "$ACCOUNT_PASSWORD" > /eth/password.txt
    geth account new --datadir /eth --password /eth/password.txt
    
    # Obtener la dirección de la cuenta creada
    ACCOUNT_ADDRESS=$(geth account list --datadir /eth | head -n 1 | grep -o -E '0x[a-fA-F0-9]{40}')
    echo "Cuenta creada: $ACCOUNT_ADDRESS"
    
    # Inicializar con genesis
    geth init --datadir /eth genesis.json
fi

# Iniciar el nodo
exec geth \
    --datadir /eth \
    --networkid ${NETWORK_ID:-1337} \
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
    --miner.threads 1 \
    --allow-insecure-unlock \
    --unlock ${ACCOUNT_ADDRESS} \
    --password /eth/password.txt \
    --syncmode full \
    --verbosity 3 