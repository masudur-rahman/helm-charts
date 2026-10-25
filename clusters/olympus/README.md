# olympus — Flux gitops tree

Staging copy generated in homelab-forge. **Copy this `clusters/olympus/` tree into the
`helm-charts` repo** (https://github.com/masudur-rahman/helm-charts), then push.

## Ownership split
- **homelab-forge (Ansible)** installs upstream third-party Helm charts as-is:
  Gateway API CRDs, cert-manager, kube-prometheus-stack, Loki, Alloy, Flux.
- **This tree (Flux)** holds only personal/modified manifests reconciled into the cluster.

## Layout
```
clusters/olympus/
  .sops.yaml                      # encrypt *.sops.yaml to the cluster age key
  infrastructure/
    gatewayclass.yaml             # GatewayClass -> Cilium
    gateway.yaml                  # Gateway (HTTP/HTTPS, *.mrahman.xyz, LB IP from .150-.169)
    cluster-issuer.yaml           # cert-manager ClusterIssuer (Let's Encrypt + Cloudflare DNS-01)
    certificate.yaml              # wildcard *.mrahman.xyz cert -> secret consumed by Gateway
    cloudflare-api-token.example.yaml  # template; sops-encrypt to cloudflare-api-token.sops.yaml
  apps/
    hubble-ui-httproute.yaml      # expose Hubble UI via Gateway API
    grafana-httproute.yaml        # expose Grafana via Gateway API
```

## Secrets
Encrypt the Cloudflare API token before committing:
```bash
cp cloudflare-api-token.example.yaml cloudflare-api-token.sops.yaml
# fill in real values, then:
sops --encrypt --in-place cloudflare-api-token.sops.yaml
```
The age public key is already wired in `.sops.yaml`. The matching private key lives in
homelab-forge `vault/compute.yml` (`vault_olympus_age_key`) and is pushed to the cluster
as the `sops-age` secret by the Ansible `flux.yml` task.

## Notes / verify before applying
- The Cloudflare token needs only Zone > DNS > Edit on `mrahman.xyz`.
- `grafana-httproute.yaml` backend Service name depends on the kube-prometheus-stack
  release name.
- Cross-namespace HTTPRoutes rely on the Gateway's `allowedRoutes.namespaces.from: All`.
