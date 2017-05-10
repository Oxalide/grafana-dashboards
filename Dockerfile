FROM python:3.6
MAINTAINER Rayane BELLAZAAR <rayane.bellazaar@oxalide.com>
WORKDIR /grafana
ADD bot.py ./
ADD requirements.txt ./
RUN git clone https://github.com/Oxalide/grafana-dashboards.git
RUN pip3 install -r requirements.txt
ENTRYPOINT ["python", "bot.py"]
CMD ["--conf", "grafana-dashboards", "--grafana-url", "http://grafana-k8s"]
