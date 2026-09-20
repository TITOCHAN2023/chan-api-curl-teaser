#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck disable=SC1091
[[ -f "$ROOT/.env" ]] && set -a && source "$ROOT/.env" && set +a
: "${OPENAI_API_KEY:?set OPENAI_API_KEY}"
MODEL="${OPENAI_MODEL:-gpt-4o-mini}"
PROMPT="${PROMPT:-Say hello in one short sentence.}"
bash "$ROOT/retry.sh" 3 -- curl -sS --fail-with-body \
  --connect-timeout 10 --max-time 60 \
  -X POST "https://api.openai.com/v1/chat/completions" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg m "$MODEL" --arg p "$PROMPT" '{model:$m,temperature:0.2,max_tokens:512,messages:[{role:"user",content:$p}]}')"
echo
