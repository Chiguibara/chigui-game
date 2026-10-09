FROM ghcr.io/cirruslabs/flutter:3.44.0

# The container runs as the host user (see compose.yaml), so the SDK, the
# home directory, and git checkouts must be usable by any UID.
ENV HOME=/home/dev \
    PUB_CACHE=/home/dev/.pub-cache

RUN mkdir -p "$PUB_CACHE" \
 && flutter config --no-analytics --no-cli-animations \
 && dart --disable-analytics \
 && flutter precache --web \
 && find /sdks/flutter -type d -exec chmod a+rwx {} + \
 && find /sdks/flutter/bin/cache -maxdepth 1 -type f -exec chmod a+rw {} + \
 && find /sdks/flutter -path "*/.dart_tool/*" -type f -exec chmod a+rw {} + \
 && chmod -R a+rwX "$HOME" \
 && git config --system --add safe.directory '*'

WORKDIR /app
