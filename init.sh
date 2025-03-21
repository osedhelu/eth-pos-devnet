#!/bin/bash

# Cargar variables de entorno
source .env

echo "🚀 Iniciando configuración de la red privada Ethereum..."

# Crear directorios para los nodos
echo "📁 Creando directorios para los nodos..."
mkdir -p node1 node2

# Crear archivos de contraseña
echo "🔑 Creando archivos de contraseña..."
echo "${NODE_PASS}" > node1/password.txt
echo "${NODE_PASS}" > node2/password.txt
chmod 600 node1/password.txt node2/password.txt

# Eliminar el prefijo 0x si existe y asegurarse de que la dirección esté en minúsculas
MINER_ACCOUNT1_CLEAN=$(echo "${MINER_ACCOUNT1#0x}" | tr '[:upper:]' '[:lower:]')
MINER_ACCOUNT2_CLEAN=$(echo "${MINER_ACCOUNT2#0x}" | tr '[:upper:]' '[:lower:]')

# Generar nodekey para el nodo 1
echo "🔑 Generando nodekey para el nodo 1..."
openssl rand -hex 32 > node1/nodekey
ENODE_KEY=$(cat node1/nodekey)
ENODE_ID=$(docker run --rm ethereum/client-go:latest bootnode -nodekeyhex $ENODE_KEY -writeaddress)

# Crear el archivo genesis.json
echo "⛓️  Generando archivo genesis.json..."
cat > genesis.json << EOL
{
  "config": {
    "chainId": ${NETWORK_ID},
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0,
    "istanbulBlock": 0,
    "muirGlacierBlock": 0,
    "berlinBlock": 0,
    "londonBlock": 0,
    "arrowGlacierBlock": 0,
    "grayGlacierBlock": 0,
    "mergeForkBlock": 0,
    "terminalTotalDifficulty": 0,
    "terminalTotalDifficultyPassed": true,
    "shanghaiTime": 0,
    "clique": {
      "period": 5,
      "epoch": 30000
    }
  },
  "difficulty": "1",
  "gasLimit": "800000000",
  "baseFeePerGas": "0x1",
  "extradata": "0x0000000000000000000000000000000000000000000000000000000000000000${MINER_ACCOUNT1_CLEAN}0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  "alloc": {
    "${MINER_ACCOUNT1_CLEAN}": { "balance": "100000000000000000000" },
    "${MINER_ACCOUNT2_CLEAN}": { "balance": "100000000000000000000" }
  },
  "nonce": "0x0000000000000042",
  "timestamp": "0x0",
  "mixHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000"
}
EOL

# Guardar el enode ID para el docker-compose
echo "ENODE_ID=$ENODE_ID" >> .env

# Verificar si docker está corriendo
echo "🐳 Verificando estado de Docker..."
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker no está corriendo. Por favor, inicia Docker Desktop y vuelve a ejecutar este script."
    exit 1
fi

# Limpiar los directorios geth existentes si existen
echo "🧹 Limpiando datos anteriores..."
rm -rf node1/geth node2/geth

# Inicializar los nodos con genesis.json
echo "🔄 Inicializando los nodos con genesis.json..."
docker run --rm -v $PWD/node1:/root/.ethereum -v $PWD/genesis.json:/root/genesis.json ethereum/client-go:latest init /root/genesis.json
docker run --rm -v $PWD/node2:/root/.ethereum -v $PWD/genesis.json:/root/genesis.json ethereum/client-go:latest init /root/genesis.json

echo "✅ Configuración completada exitosamente!"
echo ""
echo "📝 Resumen de la configuración:"
echo "- Network ID: $NETWORK_ID"
echo "- Chain Name: $CHAIN_NAME"
echo "- Minero Principal: 0x$MINER_ACCOUNT1_CLEAN"
echo "- Minero Secundario: 0x$MINER_ACCOUNT2_CLEAN"
echo "- Enode ID: $ENODE_ID"
echo "- HTTP Ports: $NODE1_HTTP_PORT, $NODE2_HTTP_PORT"
echo ""
echo "Para iniciar la red, ejecuta:"
echo "docker-compose up -d" 