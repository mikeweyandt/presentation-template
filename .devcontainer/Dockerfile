FROM node:20-bookworm-slim

# System dependencies:
#   chromium         — headless browser Marp uses to render PDF/PPTX
#   make             — drives the build targets
#   fonts-*          — so exported slides render text (base image ships no fonts)
RUN apt-get update && apt-get install -y --no-install-recommends \
        chromium \
        make \
        fonts-liberation \
        fonts-dejavu-core \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Point Marp/Puppeteer at the system Chromium instead of downloading one.
# Marp CLI auto-detects Docker and launches Chromium with --no-sandbox.
ENV CHROME_PATH=/usr/bin/chromium \
    PUPPETEER_SKIP_DOWNLOAD=true

# Marp CLI (pinned to the v4 line for reproducible builds).
RUN npm install -g @marp-team/marp-cli@4

WORKDIR /workspace
