# Grafana Dashboards

This repository, allow you to import some Grafana dashboard carried out by **Oxalide** to monitor your **Kubernetes cluster** using **Prometheus** as datasource.

## Dependencies

To use the content of this repository, you must to have a **Kubernetes cluster**, a **Grafana** and a **Prometheus** instance deployed on it.

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
2. Deploy it on your Kubernetes cluster.
```bash
kubectl create -f grafana-import-dashboard
```
