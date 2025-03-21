#!/bin/bash

# Cargar variables de entorno
source .env

# Crear el archivo genesis.json
# Los comentarios a continuación explican cada sección, pero no se incluirán en el archivo final

# config: Define las características y reglas de la blockchain
# - chainId: Identificador único de tu red
# - homesteadBlock, eip150Block, etc: Activa las diferentes actualizaciones de Ethereum
# - clique: Configura el consenso PoA (Proof of Authority)
#   - period: 5 segundos entre bloques
#   - epoch: Cada cuántos bloques se hace un checkpoint

cat > genesis.json << EOL
{
  "config": {
    "chainId": $NETWORK_ID,
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

echo "✅ Archivo genesis.json generado exitosamente"
echo "📝 Resumen de la configuración:"
echo "- Network ID: $NETWORK_ID"
echo "- Chain Name: $CHAIN_NAME"
echo "- Minero Principal: $MINER_ACCOUNT1"
echo "- Minero Secundario: $MINER_ACCOUNT2" 