# helm-charts
Helm Charts Repository for `masudur-rahman`'s applications.

## Configure Helm Repository

```sh
helm repo add masud https://masudur-rahman.github.io/helm-charts/stable
helm repo update

helm search repo masud

helm install sample-chart masud/sample-chart
```

## Update Helm index.yaml
```sh
make update-index
```
