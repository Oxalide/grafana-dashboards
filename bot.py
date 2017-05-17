#!/usr/bin/env python3

import sys
import os
import requests
import logging
import coloredlogs
import fnmatch
import argparse
import json

class GrafanaException(Exception):
    """
    Class for Grafana Exception
    """
    def __init__(self, message):
        Exception.__init__(self, u'Error {} : "{}"'.format(message['statusCode'], message['message']))

class Grafana(object):
    """
    Class to interact with grafana APIs
    """
    def __init__(self):
        # Initialize a requests session
        self.grafana_username = os.environ.get('GRAFANA_USERNAME')
        self.grafana_token = os.environ.get('GRAFANA_PASSWORD')
        if not self.grafana_username:
            logger.error("ERROR : Please set the environment variable 'GRAFANA_USERNAME'")
            sys.exit(1)
        if not self.grafana_token:
            logger.error("ERROR : Please set the environment variable 'GRAFANA_PASSWORD'")
            sys.exit(1)
        self.session = requests.Session()
        self.session.auth = requests.auth.HTTPBasicAuth(self.grafana_username, self.grafana_token)
        self.session.headers.update({
            'Accept': 'application/json',
            'Content-Type': 'application/json',
        })

    def import_dashboards(self, path, base_url):
        """
        Method to import Grafana Dashboards using API calls
        """
        pattern = "*.json"
        dashboards = []
        for root, dirs, files in os.walk(path):
            for basename in files:
                if fnmatch.fnmatch(basename, pattern):
                    dashboards.append(os.path.join(root, basename))
        if not dashboards:
            logger.error("No dashboard to import. exit.")
            sys.exit(1)
        for dashboard in dashboards:
            with open(dashboard, 'r+') as f:
                payload = {
                    'dashboard': json.load(f),
                    'overwrite': True,
                    'inputs': [{
                        'name': "DS_PROMETHEUS",
                        'type': "datasource",
                        'value': "prometheus-k8s",
                        'pluginId': "prometheus"
                    }]
                }
            logger.info("Dashboard : {}".format(payload['dashboard']['title']))
            response = self.session.post("{}/api/dashboards/import".format(base_url), data=json.dumps(payload))
            if response.status_code != 200:
                message = {
                    'statusCode': response.status_code,
                    'message': response.json()['message']
                }
                raise GrafanaException(message)
            else:
                logger.info('Dashboard "{}" was successfully imported'.format(payload['dashboard']['title']))

    def create_datastore(self, name, engine, url, access="proxy", basicAuth=False):
        """
        Method to create Grafana Datasource using API calls.
        """
        response = self.session.get("{}/api/datasources".format(base_url))
        if response.status_code != 200:
            message = {
                'statusCode': response.status_code,
                'message': response.json()['message']
            }
            raise GrafanaException(message)
        else:
            datasources = response.json()
            dts_filter = list(filter(lambda x: x['name'] == name, datasources))
            if dts_filter:
                logger.warning("Data source with the name '{}' already exist. Skip.".format(name))
            else:
                payload = {
                    'name': name,
                    'type': engine,
                    'url': url,
                    'access': access,
                    'basicAuth': basicAuth,
                    'isDefault': True
                }
                response = self.session.post("{}/api/datasources".format(base_url), data=json.dumps(payload))
                if response.status_code != 200:
                    message = {
                        'statusCode': response.status_code,
                        'message': response.json()['message']
                    }
                    raise GrafanaException(message)
                else:
                    logger.info('Datasource "{}" was successfully created'.format(name))

def main():
    try:
        grafana = Grafana()
        logger.info("Try to Create prometheus datasource")
        grafana.create_datastore("prometheus-k8s", "prometheus", cli.prometheus_endpoint)
        logger.info("Try to import grafana dashboards")
        grafana.import_dashboards(cli.conf, base_url)
    except GrafanaException as error:
        logger.error(error)
        sys.exit(1)

if __name__== '__main__':
    parser = argparse.ArgumentParser(description="Run")
    parser.add_argument('--conf', '-c',
                        required=True,
                        help='Conf directory (Grafana templates)')
    parser.add_argument('--grafana-url', '-u',
                        required=True,
                        help='Grafana URL')
    parser.add_argument('--prometheus-endpoint', '-s',
                        default="http://prometheus-operated:9090",
                        help='Prometheus endpoint (http[s]://<kubernetes servicename>:<port>)')
    cli = parser.parse_args()
    logger = logging.getLogger('run')
    log_level = 'INFO'
    coloredlogs.install(level=log_level)
    base_url = cli.grafana_url
    main()
