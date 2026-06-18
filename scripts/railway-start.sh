#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="${ROOT}/node_modules/.bin:${PATH}"

# Railway injects PORT — n8n defaults to 5678 without this.
export N8N_PORT="${N8N_PORT:-${PORT:-5678}}"
export N8N_LISTEN_ADDRESS="${N8N_LISTEN_ADDRESS:-0.0.0.0}"
export N8N_USER_FOLDER="${N8N_USER_FOLDER:-/data}"
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS="${N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS:-false}"

mkdir -p "${N8N_USER_FOLDER}"
chmod 700 "${N8N_USER_FOLDER}" 2>/dev/null || true

if [[ -n "${RAILWAY_ENVIRONMENT:-}" ]] && [[ -z "${DATABASE_URL:-}" ]] && [[ -z "${PGHOST:-}" ]] && [[ -z "${DB_TYPE:-}" ]]; then
  echo "ERROR: Link the Postgres service to n8n on Railway (share DATABASE_URL), then redeploy."
  exit 1
fi

# Railway Postgres plugin exposes PG* and/or DATABASE_URL.
if [[ -z "${DB_TYPE:-}" ]]; then
  if [[ -n "${DATABASE_URL:-}" ]] || [[ -n "${PGHOST:-}" ]]; then
    export DB_TYPE=postgresdb
  fi
fi

if [[ "${DB_TYPE:-}" == "postgresdb" ]]; then
  if [[ -z "${DB_POSTGRESDB_HOST:-}" ]] && [[ -n "${DATABASE_URL:-}" ]]; then
    eval "$(
      node -e "
        const u = new URL(process.env.DATABASE_URL);
        const esc = (v) => v.replace(/'/g, \"'\\\\''\");
        console.log(\`export DB_POSTGRESDB_HOST='\${esc(u.hostname)}'\`);
        console.log(\`export DB_POSTGRESDB_PORT='\${esc(u.port || '5432')}'\`);
        console.log(\`export DB_POSTGRESDB_DATABASE='\${esc(u.pathname.replace(/^\\//, ''))}'\`);
        console.log(\`export DB_POSTGRESDB_USER='\${esc(decodeURIComponent(u.username))}'\`);
        console.log(\`export DB_POSTGRESDB_PASSWORD='\${esc(decodeURIComponent(u.password))}'\`);
      "
    )"
  fi

  export DB_POSTGRESDB_HOST="${DB_POSTGRESDB_HOST:-${PGHOST:-}}"
  export DB_POSTGRESDB_PORT="${DB_POSTGRESDB_PORT:-${PGPORT:-5432}}"
  export DB_POSTGRESDB_DATABASE="${DB_POSTGRESDB_DATABASE:-${PGDATABASE:-${POSTGRES_DB:-}}}"
  export DB_POSTGRESDB_USER="${DB_POSTGRESDB_USER:-${PGUSER:-${POSTGRES_USER:-}}}"
  export DB_POSTGRESDB_PASSWORD="${DB_POSTGRESDB_PASSWORD:-${PGPASSWORD:-${POSTGRES_PASSWORD:-}}}"
fi

echo "n8n starting on ${N8N_LISTEN_ADDRESS}:${N8N_PORT} (data: ${N8N_USER_FOLDER}, db: ${DB_TYPE:-sqlite})"

exec n8n