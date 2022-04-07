    StateExisting=$(aws s3 ls s3://rbachkarou-kops | grep -o  wordsmith.rbachkarou.tl.scntl.com) 
if [ "$StateExisting" = "wordsmith.rbachkarou.tl.scntl.com" ] 
then 
    echo "Cluster already there" 
else 
    # Create cluster
    kops create cluster --name=wordsmith.rbachkarou.tl.scntl.com --state=s3://rbachkarou-kops --zones=eu-central-1a --node-count=2 --node-size=t3.medium --master-size=t3.medium
    kops update cluster --name wordsmith.rbachkarou.tl.scntl.com --yes --admin --state=s3://rbachkarou-kops
    kops validate cluster --wait 10m --state=s3://rbachkarou-kops
    # Istio install 
    istioctl install --set profile=minimal -y
    # Labeled for istio
    kubectl create namespace wordsmith
    kubectl label namespace wordsmith istio-injection=enabled
    # install grafana and kiali and prometeus
    kubectl apply -f istio-addons/kiali.yaml
    kubectl apply -f istio-addons/grafana.yaml
    kubectl apply -f istio-addons/prometheus.yaml
fi
  