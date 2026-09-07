#!/usr/bin/env bash
set -euo pipefail

cd /workspaces/Ghost

# Ghost is the backend; Admin/Portal are separate host-side watchers.
# A Codespace can reconnect with only some of them still running, so each
# component is checked independently instead of treating port 2368 as proof
# that the whole development stack is alive.
backend_running=false
if (exec 3<>/dev/tcp/127.0.0.1/2368) 2>/dev/null; then
    backend_running=true
fi

echo "Starting Ghost dev stack..."
GHOST_URL="${GHOST_URL:-http://localhost:2368/}"

# Ghost's own `url` config (default http://localhost:2368) is what session
# CSRF checks compare the browser's Origin header against (see
# cookieCsrfProtection in ghost/core/core/server/services/auth/session/
# session-service.js). Codespaces serves everything through a forwarded
# https://<name>-2368.<domain> origin instead, so without this every
# authenticated admin request fails that origin check and bounces back to
# login. `url` is a top-level nconf key, so a bare `url` env var overrides
# it (see ghost/core/core/shared/config/loader.js's nconf.env() call).
# Local (non-Codespaces) VS Code Dev Containers forward to genuine
# localhost, so this only applies inside Codespaces itself.
if [ -n "${CODESPACES:-}" ] && [ -n "${CODESPACE_NAME:-}" ]; then
    export url="https://${CODESPACE_NAME}-2368.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-app.github.dev}"
    echo "Codespaces detected: setting Ghost url=$url so admin session origin checks match the forwarded tunnel" >> /tmp/ghost-backend.log

    # Keep Admin's backend discovery traffic inside the Docker network. If it
    # called localhost:2368 directly after Ghost's URL was switched to HTTPS,
    # Express would redirect it to the external Codespaces URL, where the
    # Vite-side fetch cannot complete the GitHub-authenticated flow.
    export GHOST_URL="http://ghost-dev-gateway:80/"
fi

if [[ "$backend_running" != true ]]; then
    { echo "=== $(date -Is) starting backend ==="; } >> /tmp/ghost-backend.log
    nohup pnpm --filter ghost dev >> /tmp/ghost-backend.log 2>&1 &
    backend_pid=$!
    disown

    echo "Waiting for Ghost Admin API..."
    site_endpoint="${GHOST_URL}ghost/api/admin/site/"
    backend_ready=false
    for _ in {1..120}; do
        # A transient curl failure is expected while Ghost is booting and must
        # not terminate the script because `set -e` is enabled.
        if response_code=$(curl --silent --output /dev/null --write-out '%{http_code}' --max-time 2 "$site_endpoint"); then
            :
        else
            response_code=000
        fi

        if [[ "$response_code" =~ ^[234][0-9][0-9]$ ]]; then
            backend_ready=true
            break
        fi

        if ! kill -0 "$backend_pid" 2>/dev/null; then
            echo "Ghost backend exited before becoming ready. See /tmp/ghost-backend.log."
            exit 1
        fi
        sleep 1
    done

    if [[ "$backend_ready" != true ]]; then
        echo "Ghost Admin API did not become ready within 120 seconds. See /tmp/ghost-backend.log."
        exit 1
    fi
else
    echo "Ghost backend already running on :2368; reusing it."
fi

# Admin's Vite server proxies /ember-cli-live-reload.js to Ember on :4200.
# Starting Admin and Ember concurrently creates a cold-start race: Vite can
# become reachable while Ember is still compiling, leaving the browser on a
# spinner with ECONNREFUSED for the live-reload script. Start the dependency
# first and wait for its real endpoint before exposing Admin.
emer_running=false
if curl --silent --output /dev/null --max-time 2 http://127.0.0.1:4200/ember-cli-live-reload.js; then
    ember_running=true
fi

if [[ "$ember_running" != true ]]; then
    { echo "=== $(date -Is) starting Ember ==="; } >> /tmp/ghost-frontends.log
    nohup pnpm --filter ghost-admin dev >> /tmp/ghost-frontends.log 2>&1 &
    ember_pid=$!
    disown

    echo "Waiting for Ember live-reload service on :4200..."
    ember_ready=false
    for _ in {1..180}; do
        if curl --silent --output /dev/null --max-time 2 http://127.0.0.1:4200/ember-cli-live-reload.js; then
            ember_ready=true
            break
        fi

        if ! kill -0 "$ember_pid" 2>/dev/null; then
            echo "Ember admin server exited before becoming ready. See /tmp/ghost-frontends.log."
            exit 1
        fi
        sleep 1
    done

    if [[ "$ember_ready" != true ]]; then
        echo "Ember live-reload service did not become ready within 180 seconds. See /tmp/ghost-frontends.log."
        exit 1
    fi
else
    echo "Ember live-reload service already running on :4200; reusing it."
fi

# These are the direct package dev commands used by Admin's Nx target. Running
# them explicitly here avoids Nx's continuous-dependency scheduling from
# bringing Admin's Vite server up before Ember is ready.
admin_running=false
if curl --silent --output /dev/null --max-time 2 http://127.0.0.1:5174/; then
    admin_running=true
fi

if [[ "$admin_running" != true ]]; then
    { echo "=== $(date -Is) starting Admin/Portal watchers ==="; } >> /tmp/ghost-frontends.log

    nohup pnpm --filter @tryghost/admin-x-framework dev >> /tmp/ghost-frontends.log 2>&1 &
    disown

    nohup pnpm --filter @tryghost/shade dev >> /tmp/ghost-frontends.log 2>&1 &
    disown

    nohup pnpm --filter @tryghost/admin dev >> /tmp/ghost-frontends.log 2>&1 &
    admin_pid=$!
    disown

    nohup pnpm --filter @tryghost/portal dev >> /tmp/ghost-frontends.log 2>&1 &
    disown

    echo "Starting Admin Vite on :5174..."
    admin_ready=false
    for _ in {1..120}; do
        if curl --silent --output /dev/null --max-time 2 http://127.0.0.1:5174/; then
            admin_ready=true
            break
        fi

        if ! kill -0 "$admin_pid" 2>/dev/null; then
            echo "Admin Vite exited before becoming ready. See /tmp/ghost-frontends.log."
            exit 1
        fi
        sleep 1
    done

    if [[ "$admin_ready" != true ]]; then
        echo "Admin Vite did not become ready within 120 seconds. See /tmp/ghost-frontends.log."
        exit 1
    fi
else
    echo "Admin dev server already running on :5174; reusing it."
fi

if [[ -n "${CODESPACES:-}" && -n "${CODESPACE_NAME:-}" ]]; then
    admin_url="https://${CODESPACE_NAME}-5174.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-app.github.dev}/__admin-dev__/"
    ghost_url="https://${CODESPACE_NAME}-2368.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-app.github.dev}/"
else
    admin_url="http://localhost:5174/__admin-dev__/"
    ghost_url="http://localhost:2368/"
fi

cat <<MSG
Ghost dev stack is ready.

  Ghost site:   $ghost_url
  Admin:        $admin_url
  Backend log:  tail -f /tmp/ghost-backend.log
  Frontend log: tail -f /tmp/ghost-frontends.log

Admin is the 5174 port in Codespaces. Open it directly from the Ports panel.

Only Admin + Portal dev watchers start by default. To add the public UMD
apps (Comments, Signup Form, Sodo Search, Announcement Bar, Admin Toolbar):
  pnpm nx run-many -t dev --projects=@tryghost/comments-ui,@tryghost/signup-form,@tryghost/sodo-search,@tryghost/announcement-bar,@tryghost/admin-toolbar
MSG
