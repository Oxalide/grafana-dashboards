# Grafana Dashboards

This repository, allow you to import some Grafana dashboard carried out by **Oxalide** to monitor your **Kubernetes cluster** using **Prometheus** as datasource.

## Dependencies

To use the content of this repository, you must to have a **Kubernetes cluster**, a **Grafana** and a **Prometheus** instance deployed on it.

This repository has been created to be used with **Oxalide's Prometheus chart** _(helm)_ and **Prometheus Operator** from **CoreOS**. So it's possible that repository doesn't works for you if you can't reproduce the same infrastructure.


## Content

In this repository you will find the following components : 
 * Grafana Dashboards _(json)_
 * A python script _(bot.py)_ which will create a prometheus datasource and import the dashboards.
 * A Dockefile to create a containerized environment to execute the script.
 
## Arguments _(script)_

To work, python script needs some parameters that you can customize.

|         Parameter          |                                Description                               |              Default                    |
|----------------------------|--------------------------------------------------------------------------|-----------------------------------------|
| `--conf`                   | Path where the dashboard are located                                     |                                         |
| `--grafana-url`            | Grafana web UI url _(e.g http://grafana.example.com)_                    | `http://grafana-k8s`                    |
| `--prometheus-endpoint`    | Prometheus endpoint _(e.g http://<kubernetes_prometheus_service>:port)_  | `http://prometheus-operated:9090`       |

## Deployment

To deploy these dashboards you have just to execute the following steps : 

1. Configure your own settings in the kubernetes job _(grafana-import-dashboards.yaml)_.
```
apiVersion: batch/v1
kind: Job
metadata:
  name: grafana-import-dashboard
  namespace: <YOUR_NAMESPACE>
spec:
  template:
    metadata:
      name: grafana-import-dashboard
    spec:
      containers:
      - name: grafana-import-dashboard
        image: oxalide/grafana-dashboards:latest
        imagePullPolicy: Always
        env:
        - name: GRAFANA_USERNAME
          valueFrom:
            secretKeyRef:
              name: grafana-secrets
              key: admin-user
        - name: GRAFANA_PASSWORD
          valueFrom:
            secretKeyRef:
              name: grafana-secrets
              key: admin-password
        command:
        - python
        - bot.py
        - --conf 
        - grafana-dashboards/dashboards 
        - --grafana-url 
        - <GRAFANA_URL>
        - --prometheus-endpoint
        - <PROMETHEUS_ENDPOINT>
restartPolicy: Never
```
2. Deploy it on your Kubernetes cluster.
```bash
kubectl create -f grafana-import-dashboard
```
