#!/bin/bash

set -eou pipefail

echo "Packaging Helm charts..."
for chartDir in charts/*/ ; do
    chart=$(basename $chartDir)
    echo ""
    echo "==> $chart"
    helm package charts/$chart -d stable/$chart
done

echo ""
echo "Generating index.yaml for the charts..."
helm repo index --url https://masudur-rahman.github.io/helm-charts/stable stable

