import kubernetes.client
from kubernetes import client, config

config.load_kube_config("~/.kube/config")   # I'm using file named "config" in the "/root" directory

v1 = kubernetes.client.CoreV1Api()
ret = v1.list_service_for_all_namespaces(watch=False)
for i in ret.items:
    print(i.status.load_balancer.ingress.hostname)