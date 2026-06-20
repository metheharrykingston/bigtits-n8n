# bigtits-n8n

Shared [n8n](https://n8n.io) connector server for BigTits (Meta, Slack, Sheets, etc.).

Deployed from this folder via `git subtree` → [bigtits-n8n](https://github.com/metheharrykingston/bigtits-n8n).

Railway builds with **Nixpacks** (`npm install n8n`) — no Docker image pull from `docker.n8n.io` or Docker Hub.

Railway healthcheck should point to `/healthz`. This repo now sets that explicitly in `railway.json`.

Community packages are disabled by default in Railway startup because recent `n8n` startup on Postgres can crash during the `InstalledPackages` metadata check before the instance becomes healthy.

**If Railway still shows `docker.n8n.io` in build logs:** the service is not connected to this repo. See [RAILWAY.md](../RAILWAY.md) § n8n — connect `metheharrykingston/bigtits-n8n`, branch `main`, empty Root Directory, then **Redeploy**.

## Starter workflows

Import in the n8n UI after first deploy:

- `workflows/bigtits-meta-marketing-publish.json`
- `workflows/bigtits-slack-post-message.json`

Then connect credentials and **activate** each workflow.
