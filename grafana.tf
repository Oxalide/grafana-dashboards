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

resource "grafana_dashboard" "Elasticsearch" {
  config_json = "${file("dashboards/elasticsearch.json")}"
}
