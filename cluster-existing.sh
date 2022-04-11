    StateExisting=$(aws s3 ls $1 | grep -o  $2) 
if [ "$StateExisting" = "$2" ] 
then 
    echo "Cluster already there" 
else 
    # Create cluster
    kops create cluster --name=$2 --state=$1 --zones=eu-central-1a --node-count=2 --node-size=t3.medium --master-size=t3.medium
    kops update cluster --name $2 --yes --admin --state=$1
    kops validate cluster --wait 10m --state=$1
fi
  