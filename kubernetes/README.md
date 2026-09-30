# ET1 on local Kubernetes

Install shared ingress and PostgreSQL once from the parent checkout:

```sh
bin/kubernetes ingress --context orbstack
bin/kubernetes postgres --context orbstack
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

This runs only Puma with `RAILS_ENV=production`. Rails's existing SSL assumption
is preserved: HTTPS terminates at ingress, and the pod receives HTTP. It connects
to the shared local PostgreSQL service and uses database `etdb`.

`up` runs ET1's database Job automatically before installing or updating the web
Deployment. It executes `bin/rails db:create db:migrate:with_data db:seed`, with
`DISABLE_ADMIN=true`, using the same deployed image, production environment and
local database settings. The Job starts no web server or queue worker.

If the Job fails, Helm stops before updating the web Deployment. The failed Job
is retained for diagnostics until the next deployment attempt:

```sh
kubectl --context orbstack -n et-full-system logs job/et-local-et1-database-setup
```

After successful setup, `up` waits for web readiness and rollout. Readiness checks
that `/apply` renders successfully. Automated tests should start after `up`
succeeds; existing pods can remain Ready while an upgrade's Job is running.
Local seeds create the development admin account from the existing seed file.
Shared PostgreSQL must be installed before the first ET1 deployment.

### Production adoption

The ET1 chart owns `templates/database-setup.yaml`; the base chart is unchanged.
`databaseSetup.enabled` defaults to `false` so existing production deployment
behaviour stays intact while this pattern is trialled locally. To adopt it in
production, enable the Job and disable startup migrations in the same values:

```yaml
databaseSetup:
  enabled: true
  create: false
  seed: false
base:
  environment:
    DOCKER_STATE: ""
```

The Job then runs only `db:migrate:with_data`. It includes versioned data
migrations, never development seeds. Rendering rejects a non-empty `DOCKER_STATE`
when the Job is enabled, avoiding two migration mechanisms.

Before enabling this in production, verify the Job can access the database,
identity, ConfigMaps, Secrets and SecretProviderClass before application resources
are installed/updated. Pre-install hooks run before ordinary chart resources,
so a SecretProviderClass created by the same release is not available on a fresh
installation. Those prerequisites need provisioning ahead of the hook (including
any new prerequisites on an upgrade). This production integration is not deployed
or validated by the local trial.

Existing pods serve during pre-upgrade migrations, so changes must be compatible
with that version. Application redeploys do not undo schema changes. The Job has
no automatic retry and a configurable 240-second deadline; inspect a failed run
before deploying a correction.

The claim start page at `/apply` can now render. No worker, API, mail server or
storage integration is deployed yet; completing/submitting a claim is a later
step. Shared PostgreSQL data survives pod restarts and removing ET1.

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


Production uses a Flux `HelmRelease` (see the ET1 files in `cnp-flux-config`).
Flux's Helm controller executes these hooks without developer cluster access;
CI publishes the application chart into `hmcts-charts`, which Flux consumes.
Hooks must remain enabled (`install.disableHooks` and `upgrade.disableHooks`
are false by default). Bump the ET1 chart version before publishing this change.

The shared Flux defaults currently configure three install/upgrade remediation
retries and `upgrade.remediation.remediateLastFailure: true`. Helm-controller
may rerun the hook and perform automatic remediation/rollback. The Job's
`backoffLimit: 0` prevents pod retries within that Job, not controller-level
retries. Review/override this release policy before production adoption to match
the intended correction-by-fresh-deploy workflow. Migrations must tolerate a
rerun; failed Job retention also lasts only until the next controller attempt.
