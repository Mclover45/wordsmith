HOST_NAME_KUBE=""
while [ -z "$HOST_NAME_KUBE"] 
do
HOST_NAME_KUBE=$(kubectl -n ingssress-nginx get svc ingress-nginx-controller  -o json | jq .status.loadBalancer.ingress[].hostname)
echo $HOST_NAME_KUBE
sleep 1
done

