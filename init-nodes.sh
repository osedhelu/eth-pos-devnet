#!/bin/bash

# Crear directorios
mkdir -p bootnode node1 node2

# Crear archivos de contraseña
echo "${NODE_PASS}" > node1/password.txt
echo "${NODE_PASS}" > node2/password.txt

# Inicializar cada nodo con genesis.json
docker run --rm -v $(pwd)/genesis.json:/genesis.json \
  -v $(pwd)/bootnode:/root/.ethereum \
  ethereum/client-go:stable init /genesis.json

docker run --rm -v $(pwd)/genesis.json:/genesis.json \
  -v $(pwd)/node1:/root/.ethereum \
  ethereum/client-go:stable init /genesis.json

docker run --rm -v $(pwd)/genesis.json:/genesis.json \
  -v $(pwd)/node2:/root/.ethereum \
  ethereum/client-go:stable init /genesis.json

# Dar permisos
chmod -R 777 bootnode node1 node2

echo "Nodos inicializados correctamente. Ahora puedes ejecutar 'docker compose up'" 