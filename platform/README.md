# Bookstoast Platform

This directory is the Bookstoast control-plane application. It is intentionally separate from the Ghost publishing runtime.

## Responsibilities

The platform will own:

- Bookstoast accounts
- journals/publications
- journal ownership and permissions
- journal domains and tenant routing
- provisioning and lifecycle of journal publishing environments
- billing and plans later
- per-journal integrations such as ActivityPub later

## Publishing boundary

The existing repository root remains the customized Ghost publishing engine. The root `Dockerfile.production` builds that publishing runtime. This application has its own Dockerfile and can be deployed as a separate Coolify service.

## Target tenant model

```text
Bookstoast Platform
  |
  +-- Journal A -> Ghost A
  +-- Journal B -> Ghost B
  +-- Journal C -> Ghost C
```

Infrastructure can be shared underneath, while each journal gets its own isolated Ghost workload and logical data boundary.

## Current status

The first web shell is intentionally small. Authentication, journal records, provisioning, domains, and the control-plane database are the next implementation stages.
