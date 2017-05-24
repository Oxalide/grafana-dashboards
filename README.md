# Grafana Dashboards

This repository, allow you to import some Grafana dashboard carried out by **Oxalide** to monitor your **Kubernetes cluster** using **Prometheus** as datasource.

## Dependencies

To use the content of this repository, you must to have a **Kubernetes cluster**, a **Grafana** and a **Prometheus** instance deployed on it.

This repository has been created to be used with **Oxalide's Prometheus chart** _(helm)_ and **Prometheus Operator** from **CoreOS**. So it's possible that repository doesn't works for you if you can't reproduce the same infrastructure.

You need also to use the latest version of terraform _(v.0.9.5)_

## Deployment

To deploy these dashboards you have just to execute the following steps :

1. Configure your own grafana template for terraform using the file : grafana.tf
```bash
provider "grafana" {
  url = "<GRAFANA_ENDPOINT>"
  auth = "<GRAFANA_USER>:<GRAFANA_PASSWORD> | <GRAFANA_API_TOKEN>"
}

resource "grafana_data_source" "prometheus" {
  type = "prometheus"
  name = "prometheus-k8s"
  url = "http://prometheus-operated:9090/"
  is_default = true
}

resource "grafana_dashboard" "Kubernetes-Cluster-Monitoring" {
  config_json = "${file("dashboards/Kubernetes-cluster-monitoring.json")}"
}

resource "grafana_dashboard" "Prometheus-Statistics" {
  config_json = "${file("dashboards/Prometheus-Statistics.json")}"
}

resource "grafana_dashboard" "All-Nodes-Dashboard" {
  config_json = "${file("dashboards/all-nodes-dashboard.json")}"
}

resource "grafana_dashboard" "Kubernetes-Pods" {
  config_json = "${file("dashboards/kubernetes-pods.json")}"
}

resource "grafana_dashboard" "Node-Dashboard" {
  config_json = "${file("dashboards/node-dashboard.json")}"
}

resource "grafana_dashboard" "Requests" {
  config_json = "${file("dashboards/requests.json")}"
}
```

2. Validate your configuration file using terraform

```
terraform plan
```

3. Deploy the dashboards
```
terraform apply
```
