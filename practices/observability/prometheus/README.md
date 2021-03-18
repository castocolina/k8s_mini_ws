#### Reference

    - https://github.com/nats-io/prometheus-nats-exporter/tree/master/walkthrough
    - https://github.com/vegasbrianc/prometheus
    - https://github.com/bakins/minikube-prometheus-demo

## ---

kubectl create -o yaml --dry-run configmap prometheus-conf --from-file=samples/prometheus/alert.rules
