# DebOps Docker Image

> **Disclaimer:** This is an unofficial Docker image and is not affiliated with or endorsed by the DebOps project.

A Docker image for running [DebOps](https://debops.org/) on Debian 12 (Bookworm).

Published to DockerHub as [`pryx/debops`](https://hub.docker.com/r/pryx/debops).

## Usage

```bash
docker run --rm -it -v /path/to/your/project:/home/ansible/src/controller pryx/debops
```

On startup, the entrypoint checks for a DebOps project at `/home/ansible/src/controller`.
If found, it installs any Ansible collections listed in `ansible/collections/requirements.yml`
before dropping into the shell. If no project is found, it starts normally without any setup.

## Versioning

Image tags correspond to DebOps releases:

| Image tag | DebOps version |
|-----------|---------------|
| `latest`  | master branch |
| `v3.2.0`  | DebOps 3.2.0  |

## Building locally

```bash
# Build using DebOps master
docker build -t debops .

# Build a specific DebOps release
docker build --build-arg DEBOPS_VERSION=v3.2.0 -t debops:v3.2.0 .
```

## CI/CD

Images are built and pushed automatically via GitHub Actions:

- Push to `main` → `pryx/debops:latest` (DebOps master)
- Push a tag (e.g. `v3.2.0`) → `pryx/debops:v3.2.0` + `pryx/debops:latest`

Required GitHub secrets: `DOCKER_USERNAME`, `DOCKER_ACCESS_TOKEN`.
