FROM node:20-bookworm-slim

# System dependencies:
#   browser          — headless browser Marp uses to render PDF/PPTX (see below)
#   make             — drives the build targets
#   fonts-*          — so exported slides render text (base image ships no fonts)
#
# The browser differs by architecture, and that is deliberate:
#   arm64  — Debian's chromium. Google publishes no arm64 Chrome .deb for
#            Linux, so the google-chrome-stable_current_amd64.deb route below
#            cannot work here at all.
#   amd64  — Google Chrome. Bookworm's chromium 150.0.7871.46 SIGTRAPs at
#            launch inside a container on amd64.
# Each is symlinked to /usr/local/bin/marp-browser so CHROME_PATH, the Makefile
# and the VS Code settings stay architecture-independent. If rendering breaks on
# one machine, change ONLY that architecture's branch — swapping the browser for
# both is what caused the fix / revert / re-fix loop this replaces.
#
# The launch smoke test stays in this same RUN layer: without it the image
# builds clean and then dies on the first `make pdf`, and a rebuild can
# silently reuse a cached layer holding a broken browser.
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        make \
        fonts-liberation \
        fonts-dejavu-core \
        ca-certificates; \
    case "$(dpkg --print-architecture)" in \
      amd64) \
        apt-get install -y --no-install-recommends wget; \
        wget -qO /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb; \
        apt-get install -y --no-install-recommends /tmp/chrome.deb; \
        rm /tmp/chrome.deb; \
        ln -s /usr/bin/google-chrome-stable /usr/local/bin/marp-browser; \
        ;; \
      arm64) \
        apt-get install -y --no-install-recommends chromium; \
        ln -s /usr/bin/chromium /usr/local/bin/marp-browser; \
        ;; \
      *) \
        echo "unsupported architecture: $(dpkg --print-architecture)" >&2; \
        exit 1; \
        ;; \
    esac; \
    rm -rf /var/lib/apt/lists/*; \
    marp-browser --headless --no-sandbox --disable-gpu \
        --dump-dom about:blank > /dev/null

# Point Marp at the browser installed above. CHROME_NO_SANDBOX and
# CHROME_DISABLE_GPU make explicit what Marp would otherwise infer from
# uid 0 + /.dockerenv, and match the flags the smoke test above proves work.
# Both are truthy-string checks, so the value must be 1 — CHROME_DISABLE_GPU=false
# would still disable the GPU.
ENV CHROME_PATH=/usr/local/bin/marp-browser \
    CHROME_NO_SANDBOX=1 \
    CHROME_DISABLE_GPU=1 \
    PUPPETEER_SKIP_DOWNLOAD=true

# Marp CLI, pinned exactly so two machines cannot drift onto different
# bundled-Puppeteer behavior.
RUN npm install -g @marp-team/marp-cli@4.5.0

WORKDIR /workspace
