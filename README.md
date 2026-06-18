# bigtits-n8n

Shared [n8n](https://n8n.io) connector server for BigTits (Meta, Slack, Sheets, etc.).

Deployed from this folder via `git subtree` → [bigtits-n8n](https://github.com/metheharrykingston/bigtits-n8n).

Railway builds with **Nixpacks** (`npm install n8n`) — no Docker image pull from `docker.n8n.io` or Docker Hub.

**If Railway still shows `docker.n8n.io` in build logs:** the service is not connected to this repo. See [RAILWAY.md](../RAILWAY.md) § n8n — connect `metheharrykingston/bigtits-n8n`, branch `main`, empty Root Directory, then **Redeploy**.

## Starter workflows

Import in the n8n UI after first deploy:

- `workflows/bigtits-meta-marketing-publish.json`
- `workflows/bigtits-slack-post-message.json`

Then connect credentials and **activate** each workflow.