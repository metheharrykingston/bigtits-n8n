FROM docker.n8n.io/n8nio/n8n:latest

# Starter workflows — import via n8n UI (Workflows → Import from File).
COPY workflows /opt/bigtits/workflows

USER node