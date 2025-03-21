#!/bin/bash

# Limpiar directorios anteriores si existen
rm -rf bootnode node1 node2

# Crear directorios
mkdir -p bootnode node1 node2

# Crear archivos de contraseña
echo "${NODE_PASS}" > node1/password.txt
echo "${NODE_PASS}" > node2/password.txt

# Inicializar cada nodo con genesis.json
echo "Inicializando bootnode..."
docker run --rm -v $(pwd)/genesis.json:/genesis.json \
  -v $(pwd)/bootnode:/root/.ethereum \
  ethereum/client-go:stable init --state.scheme=path /genesis.json

echo "Inicializando node1..."
docker run --rm -v $(pwd)/genesis.json:/genesis.json \
  -v $(pwd)/node1:/root/.ethereum \
  ethereum/client-go:stable init --state.scheme=path /genesis.json

echo "Inicializando node2..."
docker run --rm -v $(pwd)/genesis.json:/genesis.json \
  -v $(pwd)/node2:/root/.ethereum \
  ethereum/client-go:stable init --state.scheme=path /genesis.json

# Dar permisos
sudo chmod -R 777 bootnode node1 node2

echo "Nodos inicializados correctamente. Ahora puedes ejecutar 'docker compose up'" 