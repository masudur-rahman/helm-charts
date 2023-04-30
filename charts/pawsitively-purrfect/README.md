# Pawsitively Purrfect Helm Chart

## Helm Repo
```bash
$ helm repo add masud https://masudur-rahman.github.io/helm-charts/stable
$ helm repo update

$ helm search repo masud/pawsitively-purrfect
```

## Install Chart
This application can be installed in two different modes. One where serving the Postgres database through a gRPC Server and in another one serving ArangoDB normally.

One where using ArangoDB as database running normally and another one where using Postgres as database which is served through a gRPC server.

To install `Pawsitively Purrfect` with ArangoDB database, just run the following command.
```bash
$ helm upgrade --install pawsitively-purrfect masud/pawsitively-purrfect -n purrfect --create-namespace
```

To install `Pawsitively Purrfect` with Postgres database, run the following command.
```bash
$ helm upgrade --install pawsitively-purrfect masud/pawsitively-purrfect -n purrfect \
    --create-namespace  --set grpc.enabled=true
```

## Verify Installation
To check if `Pawsitively Purrfect` is installed, run the following command:
```bash
$ kubectl get pods -n purrfect -l "app.kubernetes.io/instance=pawsitively-purrfect"

NAME                                             READY   STATUS    RESTARTS   AGE
pawsitively-purrfect-698f968b44-d5mt6            1/1     Running   0          15s
pawsitively-purrfect-arangodb-78db5b45bf-2wklw   1/1     Running   0          10s
```

## Uninstall the Chart
To uninstall `Pawsitively Purrfect`:
```bash
$ helm ls -n purrfect

$ helm uninstall pawsitively-purrfect -n purrfect
```

## Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| domain | Domain to serve the Pawsitively Purrfect Server | pawsitively.purrfect |
| grpc.enabled | if enabled, it will create a grpc server, serving postgres db rpc | false |
| grpc.port | gRPC server port | 8080 |
| service.port | Port, the server will start with | 62783 |
| image.repository | | pawsitively-purrfect |
| arangodb.image | | arangodb:3.10 |
| arangodb.password | | admin |
| postgres.image | | postgres:15.2-alpine | 
| postgres.user | | postgres | 
| postgres.password | | postgres | 
| postgres.database | | pawsitive | 
