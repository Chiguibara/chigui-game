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
make shell      # shell inside the container
```

Use `WEB_PORT=9000 make web` if port 8080 is taken.

Only the web platform exists for now. Windows (for players) and Android will be added later; see `CLAUDE.md`.
