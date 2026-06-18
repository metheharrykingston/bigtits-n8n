# Avoid docker.n8n.io / Docker Hub pull rate limits on Railway builders.
# Node from AWS Public ECR (Docker Official Images mirror); n8n from npm.
FROM public.ecr.aws/docker/library/node:24-bookworm-slim

ENV NODE_ENV=production \
    N8N_DIAGNOSTICS_ENABLED=false

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates tini python3 make g++ \
    && npm install -g n8n@latest \
    && apt-get purge -y python3 make g++ \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /home/node/.n8n \
    && chown -R node:node /home/node

USER node
WORKDIR /home/node

COPY --chown=node:node workflows /opt/bigtits/workflows

EXPOSE 5678
ENTRYPOINT ["tini", "--"]
CMD ["n8n"]