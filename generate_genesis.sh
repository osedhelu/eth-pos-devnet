#!/bin/bash

# Cargar variables de entorno
source .env

# Crear genesis.json con las variables reemplazadas
cat > genesis.json << EOF
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
    "shanghaiTime": 0,
    "clique": {
      "period": 5,
      "epoch": 30000
    }
  },
  "difficulty": "1",
  "gasLimit": "800000000",
  "extradata": "0x0000000000000000000000000000000000000000000000000000000000000000${MINER_ACCOUNT1_CLEAN}0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  "alloc": {
    "${MINER_ACCOUNT1_CLEAN}": { "balance": "500000000000000000000000" },
    "${MINER_ACCOUNT2_CLEAN}": { "balance": "500000000000000000000000" }
  }
}
EOF

echo "Genesis file generated successfully!" 