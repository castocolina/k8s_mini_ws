
kubectl create -o yaml --dry-run configmap grafana-conf \
    --from-file=datasource.yaml=samples/grafana/provisioning/datasources/datasource.yml \
    --from-file=dashboard.yaml=samples/grafana/provisioning/dashboards/dashboard.yml \
    --from-file=prometheus-mon=samples/grafana/provisioning/dashboards/prom-mon.json \
    > manifests/observability/grafana/config-map.yaml