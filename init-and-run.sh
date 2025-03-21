#!/bin/bash

# Crear directorios para los nodos
mkdir -p node1/data
mkdir -p node2/data

# Inicializar los nodos con el genesis block
geth init --datadir node1/data genesis.json
geth init --datadir node2/data genesis.json

# Crear archivo de contraseña
echo "${NODE_PASS}" > node1/password.txt
echo "${NODE_PASS}" > node2/password.txt

# Importar la cuenta del minero al nodo 1
echo "${MINER_ACCOUNT1}" > node1/key.txt
geth account import --datadir node1/data --password node1/password.txt node1/key.txt

# Importar la cuenta con todos los tokens al nodo 2
echo "${MINER_ACCOUNT2}" > node2/key.txt
geth account import --datadir node2/data --password node2/password.txt node2/key.txt

# Iniciar el nodo 1
geth --datadir node1/data \
  --networkid ${NETWORK_ID} \
  --port ${NODE1_P2P_PORT} \
  --http \
  --http.addr "0.0.0.0" \
  --http.port ${NODE1_HTTP_PORT} \
  --http.corsdomain "*" \
  --http.api "eth,net,web3,personal,miner,admin" \
  --ws \
  --ws.addr "0.0.0.0" \
  --ws.port ${NODE1_WS_PORT} \
  --ws.origins "*" \
  --mine \
  --miner.threads ${MINER_THREADS} \
  --unlock ${MINER_ACCOUNT1} \
  --password node1/password.txt \
  --allow-insecure-unlock &

# Esperar un momento para que el nodo 1 inicie
sleep 5

# Iniciar el nodo 2
geth --datadir node2/data \
  --networkid ${NETWORK_ID} \
  --port ${NODE2_P2P_PORT} \
  --http \
  --http.addr "0.0.0.0" \
  --http.port ${NODE2_HTTP_PORT} \
  --http.corsdomain "*" \
  --http.api "eth,net,web3,personal,miner,admin" \
  --ws \
  --ws.addr "0.0.0.0" \
  --ws.port ${NODE2_WS_PORT} \
  --ws.origins "*" \
  --unlock ${MINER_ACCOUNT2} \
  --password node2/password.txt \
  --allow-insecure-unlock 