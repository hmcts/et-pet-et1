# ET1 on local Kubernetes

Install shared ingress once from the parent checkout:

```sh
bin/kubernetes ingress --context orbstack
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
is preserved: HTTPS terminates at ingress, and the pod receives HTTP. No database
or worker is deployed yet, so database-dependent pages report errors.

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
