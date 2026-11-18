#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")/.."

command -v docker >/dev/null 2>&1 || { echo "Docker não encontrado. Instale Docker Engine primeiro."; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "Docker Compose plugin não encontrado."; exit 1; }

if [[ ! -f .env ]]; then
  read -r -p "Domínio apontado para o IP deste servidor (ex.: pc.seudominio.com): " DOMAIN
  [[ -n "$DOMAIN" && "$DOMAIN" != *"/"* && "$DOMAIN" != *" "* ]] || { echo "Domínio inválido."; exit 1; }
  command -v openssl >/dev/null 2>&1 || { echo "Instale openssl."; exit 1; }
  POSTGRES_PASSWORD="$(openssl rand -hex 32)"
  umask 077
  printf 'DOMAIN=%s\nPOSTGRES_PASSWORD=%s\n' "$DOMAIN" "$POSTGRES_PASSWORD" > .env
  echo "Arquivo .env criado com segredo aleatório. Não o publique."
fi

docker compose up -d
echo "Gateway iniciado. Acesse https://$(sed -n 's/^DOMAIN=//p' .env)/guacamole/"
echo "Login inicial do Guacamole: guacadmin / guacadmin. Troque a senha imediatamente."
