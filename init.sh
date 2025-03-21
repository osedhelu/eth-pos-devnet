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
    "berlinBlock": 0,
    "londonBlock": 0,
    "clique": {
      "period": 5,
      "epoch": 30000
    }
  },
  "difficulty": "1",
  "gasLimit": "8000000",
  "extradata": "0x0000000000000000000000000000000000000000000000000000000000000000${MINER_ACCOUNT1}0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  "alloc": {
    "${MINER_ACCOUNT1}": { "balance": "100000000000000000000" },
    "${MINER_ACCOUNT2}": { "balance": "100000000000000000000" }
  }
}
EOL

# Verificar si docker está corriendo
echo "🐳 Verificando estado de Docker..."
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker no está corriendo. Por favor, inicia Docker Desktop y vuelve a ejecutar este script."
    exit 1
fi

# Inicializar los nodos con genesis.json
echo "🔄 Inicializando los nodos con genesis.json..."
docker run --rm -v $PWD/node1:/root/.ethereum -v $PWD/genesis.json:/root/genesis.json ethereum/client-go:latest init /root/genesis.json
docker run --rm -v $PWD/node2:/root/.ethereum -v $PWD/genesis.json:/root/genesis.json ethereum/client-go:latest init /root/genesis.json

echo "✅ Configuración completada exitosamente!"
echo ""
echo "📝 Resumen de la configuración:"
echo "- Network ID: $NETWORK_ID"
echo "- Chain Name: $CHAIN_NAME"
echo "- Minero Principal: $MINER_ACCOUNT1"
echo "- Minero Secundario: $MINER_ACCOUNT2"
echo "- HTTP Ports: $NODE1_HTTP_PORT, $NODE2_HTTP_PORT"
echo ""
echo "Para iniciar la red, ejecuta:"
echo "docker-compose up -d" 