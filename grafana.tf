provider "grafana" {
  url  = "<GRAFANA_ENDPOINT>"
  auth = "<GRAFANA_USER>:<GRAFANA_PASSWORD> | <GRAFANA_API_TOKEN>"
}

variable "datasource_name" {
  default = "prometheus-k8s"
}

resource "grafana_data_source" "prometheus" {
  type       = "prometheus"
  name       = "${var.datasource_name}"
  url        = "http://prometheus-operated:9090/"
  is_default = true
}

data "template_file" "Kubernetes-Cluster-Monitoring" {
  template = "${file("dashboards/Kubernetes-cluster-monitoring.json")}"

  vars {
    DS_PROMETHEUS-K8S = "${var.datasource_name}"
  }
}

resource "grafana_dashboard" "Kubernetes-Cluster-Monitoring" {
  config_json = "${data.template_file.Kubernetes-Cluster-Monitoring.rendered}"

  depends_on = [
    "grafana_data_source.prometheus",
  ]
}

data "template_file" "Prometheus-Statistics" {
  template = "${file("dashboards/Prometheus-Statistics.json")}"

  vars {
    DS_PROMETHEUS-K8S = "${var.datasource_name}"
  }
}

resource "grafana_dashboard" "Prometheus-Statistics" {
  config_json = "${data.template_file.Prometheus-Statistics.rendered}"

  depends_on = [
    "grafana_dashboard.Kubernetes-Cluster-Monitoring",
  ]
}

data "template_file" "All-Nodes-Dashboard" {
  template = "${file("dashboards/all-nodes-dashboard.json")}"

  vars {
    DS_PROMETHEUS-K8S = "${var.datasource_name}"
  }
}

resource "grafana_dashboard" "All-Nodes-Dashboard" {
  config_json = "${data.template_file.All-Nodes-Dashboard.rendered}"

  depends_on = [
    "grafana_dashboard.Prometheus-Statistics",
  ]
}

data "template_file" "Kubernetes-Pods" {
  template = "${file("dashboards/kubernetes-pods.json")}"

  vars {
    DS_PROMETHEUS-K8S = "${var.datasource_name}"
  }
}

resource "grafana_dashboard" "Kubernetes-Pods" {
  config_json = "${data.template_file.Kubernetes-Pods.rendered}"

  depends_on = [
    "grafana_dashboard.All-Nodes-Dashboard",
  ]
}

data "template_file" "Node-Dashboard" {
  template = "${file("dashboards/node-dashboard.json")}"

  vars {
    DS_PROMETHEUS-K8S = "${var.datasource_name}"
  }
}

resource "grafana_dashboard" "Node-Dashboard" {
  config_json = "${data.template_file.Node-Dashboard.rendered}"

  depends_on = [
    "grafana_dashboard.Kubernetes-Pods",
  ]
}

data "template_file" "Requests" {
  template = "${file("dashboards/requests.json")}"

  vars {
    DS_PROMETHEUS-K8S = "${var.datasource_name}"
  }
}

resource "grafana_dashboard" "Requests" {
  config_json = "${data.template_file.Requests.rendered}"

  depends_on = [
    "grafana_dashboard.Node-Dashboard",
  ]
}
