#!/bin/bash

TOTAL_REQUESTS=20000
ENDPOINT="http://localhost:8888"
HEADER="x-api-key: 0ac39f1c-9665-47f5-859c-05073f3fcb60"

# Arquivo temporário para armazenar a contagem dos códigos de status
STATUS_FILE=$(mktemp)
touch "$STATUS_FILE"

# Função para exibir barra de progresso e contagem de status codes em tempo real
progress_bar() {
    local progress=$1
    local width=50  # Largura da barra
    local done=$((progress * width / TOTAL_REQUESTS))
    local remaining=$((width - done))
    local bar="$(printf "%${done}s" | tr ' ' '#')$(printf "%${remaining}s" | tr ' ' '-')"

    # Exibir a barra de progresso
    printf "\r[%s] %d/%d" "$bar" "$progress" "$TOTAL_REQUESTS"

    # Exibir contagem de status codes em tempo real
    awk '{count[$1]++} END {for (code in count) printf " [HTTP Code %s: %d]", code, count[code]}' "$STATUS_FILE"
}

# Executar requisições
for i in $(seq 1 $TOTAL_REQUESTS); do
    response=$(curl -s -o /dev/null -w "%{http_code}" -H "$HEADER" "$ENDPOINT")

    # Salvar código de status no arquivo temporário
    echo "$response" >> "$STATUS_FILE"

    # Atualizar a exibição em tempo real
    progress_bar $i
done

# Exibir contagem final dos status codes
echo -e "\n\nResumo das Requisições:"
awk '{count[$1]++} END {for (code in count) print "HTTP Code " code ": " count[code] " vezes"}' "$STATUS_FILE"

# Remover arquivo temporário
rm "$STATUS_FILE"
