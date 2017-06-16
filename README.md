# Grafana Dashboards

This repository allows you to import some Grafana dashboard created by
**Oxalide** to monitor your **Kubernetes cluster** using **Prometheus** as
datasource.

## Dependencies

To use the content of this repository, you must have a **Kubernetes cluster**, a
**Grafana** and a **Prometheus** instance deployed on it.

This repository has been created to be used with **Oxalide's Prometheus chart**
_(helm)_ and **Prometheus Operator** from **CoreOS**. So it's possible that
that repository doesn't work for you if you can't reproduce the same
infrastructure.

This project has been developed with **Terraform 0.9**

## Deployment

To deploy these dashboards you have just to execute the following steps :

1. Configure your own grafana template for terraform using the file `grafana.tf`.
The provided file is just an exemple. You can pick and choose the dashbaords
you want.
2. Validate your configuration file using terraform
```
terraform plan
```

3. Deploy the dashboards
```
terraform apply
```
