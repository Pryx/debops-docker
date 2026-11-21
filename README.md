# DebOps Docker Image

> **Disclaimer:** This is an unofficial Docker image and is not affiliated with or endorsed by the DebOps project.
> Original Dockerfile created by [Maciej Delmanowski](https://github.com/drybjed) and the DebOps project.

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

The image tags follow a set of rules rather than a fixed version list:

| Image tag | Contents |
|-----------|----------|
| `unstable` | DebOps `master` branch |
| `X.Y.Z` | That DebOps release, for example `3.4.1` |
| `X.Y` | Latest patch release in the `X.Y` minor series |
| `X` | Latest patch release in the `X` major series |
| `latest` | Highest stable DebOps version currently being published |

For a version such as `v3.4.1`, the published tags are `3.4.1`, `3.4`,
and `3`. The `v` prefix is the DebOps release-tag format; it is omitted
from Docker image tags.

The versions to publish are maintained automatically in `DEBOPS_VERSIONS`.
This is the latest patch release from each of the newest stable minor
series, plus `main`. When a newer DebOps release or patch is published,
the existing tags move to the appropriate new build; no README version
table needs to be updated.

## Building locally

```bash
# Build using DebOps master
docker build -t debops .

# Build a specific DebOps release
docker build --build-arg DEBOPS_VERSION=v3.2.0 -t debops:v3.2.0 .
```

## CI/CD

Images are built and pushed automatically via GitHub Actions:

- Push to `main` or run the workflow manually → rebuild every version in
  `DEBOPS_VERSIONS` and apply the tag rules described above
- The scheduled update workflow keeps `DEBOPS_VERSIONS` on the newest stable
  releases and opens a pull request when it changes

Required GitHub secrets: `DOCKER_USERNAME`, `DOCKER_ACCESS_TOKEN`.
