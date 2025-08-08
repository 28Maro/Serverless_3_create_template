#!/usr/bin/env bash
set -euo pipefail

# Uso:
#   bash <(curl -sSL https://raw.githubusercontent.com/28Maro/Serverless_3_create_template/main/init-serverless-v3.sh) mi-proyecto [--no-install] [--git]
#   --no-install  omite npm install
#   --git         inicializa git y hace primer commit

TEMPLATE_REPO="28Maro/Serverless_3_create_template"

log() { printf "\033[0;32m%s\033[0m\n" "$*"; }
warn() { printf "\033[1;33m%s\033[0m\n" "$*"; }
err() { printf "\033[0;31m%s\033[0m\n" "$*"; }

# Args
PROJECT_NAME="${1:-}"
NO_INSTALL="false"
INIT_GIT="false"
for arg in "${@:2}"; do
  case "$arg" in
    --no-install) NO_INSTALL="true" ;;
    --git) INIT_GIT="true" ;;
  esac
done

if [ -z "$PROJECT_NAME" ]; then
  err "Debes indicar el nombre del proyecto"
  echo "Ejemplo:"
  echo "  bash <(curl -sSL https://raw.githubusercontent.com/$TEMPLATE_REPO/main/init-serverless-v3.sh) mi-proyecto"
  exit 1
fi

# Sanitiza nombre para package.json
PROJECT_SAFE=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')
[ -z "$PROJECT_SAFE" ] && PROJECT_SAFE="my-sls-v3-node22"

# Checks básicos
command -v curl >/dev/null || { err "curl no está instalado"; exit 1; }
command -v node >/dev/null || { err "Node no está instalado. Instala Node 22"; exit 1; }
command -v npm  >/dev/null || { err "npm no está instalado"; exit 1; }

if [ -d "$PROJECT_NAME" ]; then
  err "El directorio '$PROJECT_NAME' ya existe"
  exit 1
fi

log "Creando proyecto $PROJECT_SAFE"
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Descarga plantilla con degit
if ! command -v npx >/dev/null; then
  err "npx no disponible en PATH"
  exit 1
fi

log "Descargando plantilla desde $TEMPLATE_REPO"
npx --yes degit "$TEMPLATE_REPO" . >/dev/null

# Actualiza package.json.name
if command -v jq >/dev/null; then
  tmpfile="$(mktemp)"
  jq --arg name "$PROJECT_SAFE" '.name = $name' package.json > "$tmpfile" && mv "$tmpfile" package.json
else
  # Fallback sed simple
  sed -i.bak -E "s/\"name\": *\"[^\"]+\"/\"name\": \"$PROJECT_SAFE\"/g" package.json || true
  rm -f package.json.bak 2>/dev/null || true
fi

# Instala dependencias
if [ "$NO_INSTALL" = "true" ]; then
  warn "Omitiendo npm install por --no-install"
else
  log "Instalando dependencias"
  npm install
fi

# Git opcional
if [ "$INIT_GIT" = "true" ]; then
  log "Inicializando git"
  git init >/dev/null
  git add .
  git commit -m "chore: init from $TEMPLATE_REPO" >/dev/null || true
fi

log "Listo"
echo "Siguiente:"
echo "  cd $PROJECT_NAME"
[ "$NO_INSTALL" = "true" ] && echo "  npm install"
echo "  npm run dev"
echo
echo "Prueba HTTP:"
echo "  curl -X POST http://localhost:3000/hello -H 'content-type: application/json' -d '{\"name\":\"Omar\"}'"
echo
echo "Scheduler:"
echo "  deja 'npm run dev' abierto y verás ejecuciones cada 5 min"
echo "  o ejecuta: npm run invoke:local:scheduled"
