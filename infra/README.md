# Infrastructure (`infra/`)

Infrastructure and local-orchestration assets for CareerOS.

**Status (S1-1):** directory scaffold only. Contents are added by later stories.

| Directory    | Purpose                                                          | Introduced in      |
| ------------ | ---------------------------------------------------------------- | ------------------ |
| `docker/`    | Per-service Dockerfiles (api, web).                              | S1-8               |
| `compose/`   | Docker Compose stacks for local dev (api, web, postgres, redis). | S1-8               |
| `terraform/` | Infrastructure as code for cloud environments.                   | later (deployment) |

No secrets are stored here; environment configuration is provided via `.env`
(see the root `.env.example`).
