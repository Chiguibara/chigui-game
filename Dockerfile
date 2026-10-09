FROM ghcr.io/cirruslabs/flutter:3.44.0

# The container runs as the host user (see compose.yaml), so the SDK, the
# home directory, and git checkouts must be usable by any UID.
ENV HOME=/home/dev \
    PUB_CACHE=/home/dev/.pub-cache

RUN mkdir -p "$PUB_CACHE" "$HOME/.gradle" \
 && flutter config --no-analytics --no-cli-animations \
 && dart --disable-analytics \
 && flutter precache --web \
 && find /sdks/flutter -type d -exec chmod a+rwx {} + \
 && find /sdks/flutter/bin/cache -maxdepth 1 -type f -exec chmod a+rw {} + \
 && find /sdks/flutter -path "*/.dart_tool/*" -type f -exec chmod a+rw {} + \
 && chmod -R a+rwX "$HOME" \
 && git config --system --add safe.directory '*'

# NDK, platform, and CMake the Flutter Android build needs (flutter.ndkVersion
# in Flutter 3.44; plugins ask for platform 35), installed once here instead
# of on every build.
RUN yes | sdkmanager --install "ndk;28.2.13676358" "platforms;android-35" "cmake;3.22.1" > /dev/null \
 && find /opt/android-sdk-linux -maxdepth 1 -type d -exec chmod a+rwx {} +

# FLAC encoder for tools/make_sounds.py (all game audio is FLAC).
RUN apt-get update \
 && apt-get install -y --no-install-recommends flac \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
