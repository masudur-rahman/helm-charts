# Expense Tracker Bot Helm chart


## Helm Repo
```bash
helm repo add masud https://masudur-rahman.github.io/helm-charts/stable
helm repo update

helm search repo masud/expense-tracker-bot
```
## Install the chart
```bash
helm upgrade --install expense-tracker-bot masud/expense-tracker-bot -n demo \
    --create-namespace \
    --set telegram.token=<TELEGRAM_BOT_TOKEN> 
    # --set database.deploy=true # set to false if you want to use external database
    # --set database.postgres.user=<POSTGRES_USER> \
    # --set database.postgres.password=<POSTGRES_PASSWORD> \
    # --set database.postgres.db=<POSTGRES_DB> \
    # --set database.postgres.host=<POSTGRES_HOST> \
    # --set database.postgres.port=<POSTGRES_PORT> \
    # --set database.postgres.sslmode=<POSTGRES_SSL_MODE>
```

## Verify Installation
To check if `Expense Tracker Bot` is installed, run the following command:
```bash
$ kubectl get pods -n demo -l "app.kubernetes.io/instance=expense-tracker-bot"

NAME                                            READY   STATUS    RESTARTS      AGE
expense-tracker-bot-7989d96fcc-b4smq            1/1     Running   2 (30s ago)   31s
expense-tracker-bot-postgres-55dcb67965-95r7g   1/1     Running   0             31s
```
