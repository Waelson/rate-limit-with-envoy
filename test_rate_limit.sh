#!/bin/bash

TOTAL_REQUESTS=15000
ENDPOINT="http://localhost:8888"
HEADER="x-user-id: 12345"

# Arquivo temporário para armazenar a contagem dos códigos de status
STATUS_FILE=$(mktemp)
touch "$STATUS_FILE"

# Função para exibir barra de progresso
progress_bar() {
    local progress=$1
    local width=50  # Largura da barra
    local done=$((progress * width / TOTAL_REQUESTS))
    local remaining=$((width - done))
    local bar="$(printf "%${done}s" | tr ' ' '#')$(printf "%${remaining}s" | tr ' ' '-')"
    printf "\r[%s] %d/%d" "$bar" "$progress" "$TOTAL_REQUESTS"
}

# Executar requisições
for i in $(seq 1 $TOTAL_REQUESTS); do
    response=$(curl -s -o /dev/null -w "%{http_code}" -H "$HEADER" "$ENDPOINT")
    echo "$response" >> "$STATUS_FILE"
    progress_bar $i
done

# Exibir contagem final dos status codes
echo -e "\n\nResumo das Requisições:"
sort "$STATUS_FILE" | uniq -c | awk '{print "Status Code "$2": "$1" vezes"}'

# Remover arquivo temporário
rm "$STATUS_FILE"
