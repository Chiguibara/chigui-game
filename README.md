# Chigüi

A cozy virtual-pet game starring Chigüi, the Chigüibara mascot.

## Development

Only Docker is required; Flutter runs inside the container. Run `make` to list the shortcuts:

```bash
make image      # build the Flutter Docker image (first time, or after changing the Dockerfile)
make web        # run with hot reload at http://localhost:8080 (r = reload, q = quit)
make test       # run tests
make analyze    # static analysis
make build-web  # release web build into build/web
make build-site # production build for juego.chiguibara.es into build/web
make shell      # shell inside the container
```

Use `WEB_PORT=9000 make web` if port 8080 is taken.

After adding, renaming, or deleting files in `assets/` (sounds, fonts) or changing `pubspec.yaml`, reloading the page is not enough: quit `make web` with `q` and start it again.

Only the web platform exists for now. Windows (for players) and Android will be added later; see `CLAUDE.md`.

## Deployment

Every push to `main` runs the checks and, if they pass, publishes the web build to https://juego.chiguibara.es (`.github/workflows/deploy.yml`, configuration in `wrangler.jsonc`). It is a static Cloudflare Worker, separate from the website; `web/_headers` lets only chiguibara.es embed it.

One-time setup:

1. In Cloudflare, create an API token from the **Edit Cloudflare Workers** template, limited to your account and the `chiguibara.es` zone.
2. In GitHub (**Settings → Secrets and variables → Actions**), add `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` (shown in the Cloudflare dashboard sidebar).
3. Push to `main`: the first deploy creates `juego.chiguibara.es` as a custom domain.

The website embeds it in `/juego/` with:

```html
<iframe
  src="https://juego.chiguibara.es/?lang=es"
  title="Chigüi"
  allow="accelerometer; gyroscope; fullscreen; autoplay"
  style="width: 100%; aspect-ratio: 16 / 10; min-height: 640px; border: 0;"
></iframe>
```

Use `?lang=en` on the English page. `allow` lets the walk use the phone's motion sensor and play sounds inside the frame.

