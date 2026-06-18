# bigtits-n8n

Shared [n8n](https://n8n.io) connector server for BigTits (Meta, Slack, Sheets, etc.).

Deployed from this folder via `git subtree` → [bigtits-n8n](https://github.com/metheharrykingston/bigtits-n8n).

Build uses `public.ecr.aws/docker/library/node` + `npm install -g n8n` so Railway does not hit Docker Hub / `docker.n8n.io` pull rate limits.

## Starter workflows

Import in the n8n UI after first deploy:

- `workflows/bigtits-meta-marketing-publish.json`
- `workflows/bigtits-slack-post-message.json`

Then connect credentials and **activate** each workflow.