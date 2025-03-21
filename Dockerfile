FROM ethereum/client-go:stable

# Instalar herramientas necesarias
RUN apk update && apk add --no-cache \
    bash \
    curl \
    jq

# Crear directorio de trabajo
WORKDIR /eth

# Copiar scripts y archivos de configuración
COPY scripts/init.sh /eth/init.sh
COPY genesis.json /eth/genesis.json

# Dar permisos de ejecución
RUN chmod +x /eth/init.sh

# Puerto RPC
EXPOSE 8545
# Puerto WS
EXPOSE 8546
# Puerto P2P
EXPOSE 30303

ENTRYPOINT ["/eth/init.sh"] 