echo '$HOST_NAME_KUBE'
until [ $HOST_NAME_KUBE -z ]
do
HOST_NAME_KUBE=$(kubectl -n ingress-nginx get svc ingress-nginx-controller  -o json | jq .status.loadBalancer.ingress[].hostname)
echo '$HOST_NAME_KUBE'
sleep 10
done

