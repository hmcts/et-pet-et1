# ET1 on local Kubernetes

Install shared ingress and PostgreSQL once from the parent checkout:

```sh
bin/kubernetes ingress --context orbstack
bin/kubernetes postgres --context orbstack
bin/kubernetes azurite --context orbstack
bin/kubernetes support --build --context orbstack
```

Then, from this service directory:

```sh
../../bin/kubernetes up --context orbstack
../../bin/kubernetes status --context orbstack
../../bin/kubernetes logs --context orbstack
```

Open <https://et1.k8s.orb.local/>. Normal TLS verification passed using
OrbStack's local certificate integration; no port forwarding is required. Other
clusters/domains need their own certificate/trust setup, documented in the parent
README. OrbStack's automatic certificate setup can prompt for macOS trust
approval on first use; those prompts occurred and were approved during this
setup. The runner does not directly issue trust-changing commands.

This runs the application's existing `./run.sh` with `RAILS_ENV=production`.
Rails's existing SSL assumption is preserved: HTTPS terminates at ingress, and
the pod receives HTTP. ET1 connects to shared local PostgreSQL and database `etdb`.

Every `up` first runs the `et-local-et1-db-bootstrap` Job using the rendered web
Deployment's image and configuration. It creates the databases, runs schema/data
migrations and seeds using the existing seed file. Setup stops on failure, and
Helm deploys only after the Job succeeds. This requires the parent deployment
script's `bootstrapDatabase` support. Setup runs on every local `up`, so seeds
must remain safe to rerun.

Local values set `DOCKER_STATE=migrate`, matching production. The existing
`run.sh` runs migrations and then starts `Procfile`, which starts Puma and the
Solid Queue worker together. Database creation and seeding are handled by the
bootstrap Job before application startup. Charts are unchanged.

`up` waits for web readiness and rollout. Readiness checks that `/apply` can
render successfully; automated tests should start after `up` succeeds. Shared
PostgreSQL must be installed before the first ET1 deployment.

The claim start page at `/apply` can render. ET1 connects directly to the API
Service at `http://et-local-api-base.et-full-system.svc.cluster.local/api/v2`, using Service
port 80 rather than the pod port 8080. API and Azurite must be deployed separately.
Mail, ACAS, CCD and Notify use the shared support services. View captured mail
at <https://mail.k8s.orb.local/>. Shared PostgreSQL
data survives pod restarts and removing ET1.

`../../bin/kubernetes build` builds this checkout's Dockerfile into OrbStack as
`et-full-system-servers-et1:latest`, without Docker Compose. `up --build` builds
and deploys ET1 together; other applications are not deployed.

Defaults are `--context orbstack` and namespace `et-full-system`. Use another
`--context` on each cluster command, and select Docker builds separately using
`--docker-context`. `up --domain localhost` changes the host to `et1.localhost`;
`up --https-port 3443` configures local URLs for that port. Install the shared
controller with the same port selection. DNS/port exposure and local image
availability depend on the chosen cluster.

`serve` still offers port forwarding for diagnostics, but direct HTTP requests
can redirect to HTTPS because the production SSL assumption is retained. Use
the ingress URL for browser access.

To remove ET1 alone:

```sh
helm uninstall et-local-et1 --kube-context orbstack --namespace et-full-system
```

See the parent repo's `kubernetes/README.md` for shared infrastructure and other
contexts. These files belong to the ET1 repo; the runner supplies temporary
chart overrides without modifying the application source or shared base chart.
