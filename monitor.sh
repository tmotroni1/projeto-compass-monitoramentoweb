#!/bin/bash

URL="SEU IP PUBLICO"
WEBHOOK_URL="https://discord.com/api/webhooks/SEU_WEBHOOK_AQUI"
LOG_FILE="/home/ubuntu/meu_script.log"
DATA_HORA=$(date '+%Y-%m-%d %H:%M:%S')

STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$STATUS" -ne 200 ]; then
  echo "$DATA_HORA - Site fora do ar! Código: $STATUS" >> "$LOG_FILE"
  
  curl -H "Content-Type: application/json" \
       -X POST \
       -d "{\"content\": \":rotating_light: ALERTA: O site está fora do ar!\"}" \
       "$WEBHOOK_URL"
else
  echo "$DATA_HORA - Site OK (Código: $STATUS)" >> "$LOG_FILE"

fi